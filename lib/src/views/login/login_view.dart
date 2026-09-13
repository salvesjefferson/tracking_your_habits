import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tracking_your_habits/l10n/app_localizations.dart';
import '/src/viewmodels/login_viewmodel.dart';
import '../home/home_view.dart';
import '../register/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _waitingForVerification = false;

  @override
  void initState() {
    super.initState();

    _checkPendingVerification();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkPendingVerification() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null && !user.emailVerified) {
      if (!mounted) return;

      setState(() {
        _waitingForVerification = true;
        _emailController.text = user.email ?? '';
      });
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = context.read<LoginViewModel>();

    final success = await viewModel.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (!mounted) return;

    if (!success) {
      _showError(viewModel.errorCode);
      return;
    }

    final verified = await viewModel.checkEmailVerified();

    if (!mounted) return;

    if (!verified) {
      setState(() {
        _waitingForVerification = true;
      });

      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const HomeView(),
      ),
    );
  }

  Future<void> _checkVerification() async {
    final viewModel = context.read<LoginViewModel>();

    final verified = await viewModel.checkEmailVerified();

    if (!mounted) return;

    if (verified) {
      setState(() {
        _waitingForVerification = false;
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomeView(),
        ),
      );

      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(context)!.emailNotVerified,
        ),
      ),
    );
  }

  Future<void> _resendVerification() async {
    final viewModel = context.read<LoginViewModel>();

    final success = await viewModel.resendEmailVerification();

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.verificationEmailSent,
          ),
        ),
      );

      return;
    }

    _showError(viewModel.errorCode);
  }

  Future<void> _logoutVerification() async {
    final viewModel = context.read<LoginViewModel>();

    await viewModel.logout();

    if (!mounted) return;

    setState(() {
      _waitingForVerification = false;
      _emailController.clear();
      _passwordController.clear();
    });
  }

  Future<void> _resetPassword() async {
    final l10n = AppLocalizations.of(context)!;

    final email = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController(
          text: _emailController.text.trim(),
        );

        return AlertDialog(
          title: Text(l10n.forgotPassword),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              labelText: l10n.email,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                final email = controller.text.trim();

                if (email.isNotEmpty) {
                  Navigator.of(dialogContext).pop(email);
                }
              },
              child: Text(l10n.confirm),
            ),
          ],
        );
      },
    );

    if (!mounted || email == null || email.isEmpty) {
      return;
    }

    final viewModel = context.read<LoginViewModel>();

    final success = await viewModel.resetPassword(email);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.passwordResetEmailSent,
          ),
        ),
      );

      return;
    }

    _showError(viewModel.errorCode);
  }

  void _showError(String? errorCode) {
    if (errorCode == null) return;

    final l10n = AppLocalizations.of(context)!;

    String message;

    switch (errorCode) {
      case 'invalid-email':
        message = l10n.invalidEmail;
        break;

      case 'user-not-found':
        message = l10n.userNotFound;
        break;

      case 'wrong-password':
        message = l10n.wrongPassword;
        break;

      case 'invalid-credential':
        message = l10n.invalidCredential;
        break;

      case 'email-already-in-use':
        message = l10n.emailAlreadyInUse;
        break;

      case 'weak-password':
        message = l10n.weakPassword;
        break;

      case 'network-request-failed':
        message = l10n.networkRequestFailed;
        break;

      case 'too-many-requests':
        message = l10n.tooManyRequests;
        break;

      default:
        message = l10n.authenticationError;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  Widget _buildVerificationView(
      BuildContext context,
      LoginViewModel viewModel,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.mark_email_unread_outlined,
              size: 64,
            ),

            const SizedBox(height: 24),

            Text(
              l10n.verifyEmail,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 16),

            Text(
              '${l10n.verificationEmailDescription}\n\n${FirebaseAuth.instance.currentUser?.email ?? ''}',
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: viewModel.isLoading
                    ? null
                    : _checkVerification,
                child: viewModel.isLoading
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(),
                )
                    : Text(l10n.alreadyVerified),
              ),
            ),

            const SizedBox(height: 12),

            TextButton(
              onPressed: viewModel.isLoading
                  ? null
                  : _resendVerification,
              child: Text(l10n.resendVerificationEmail),
            ),

            TextButton(
              onPressed: viewModel.isLoading
                  ? null
                  : _logoutVerification,
              child: Text(l10n.logout),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginView(
      BuildContext context,
      LoginViewModel viewModel,
      ) {
    final l10n = AppLocalizations.of(context)!;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // LOGO
              ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 32),

              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: l10n.email,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.enterEmail;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return l10n.enterPassword;
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: viewModel.isLoading ? null : _login,
                  child: viewModel.isLoading
                      ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(),
                  )
                      : Text(l10n.login),
                ),
              ),

              TextButton(
                onPressed: viewModel.isLoading
                    ? null
                    : _resetPassword,
                child: Text(l10n.forgotPassword),
              ),

              const SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RegisterView(),
                    ),
                  );
                },
                child: Text(l10n.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
      ),
      
      body: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          
          if (_waitingForVerification) {
            return _buildVerificationView(
              context,
              viewModel,
            );
          }

          return _buildLoginView(
            context,
            viewModel,
          );
        },
      ),
    );
  }
}