import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/habit.dart';
import '../models/user.dart';

class StatisticsPdfService {
  Future<Uint8List> generateStatisticsPdf({
    required User user,
    required String? profilePhotoPath,
    required List<Habit> habits,
    required int bestStreak,
    required double overallProgress,
    required DateTime month,
    required int Function(Habit habit) getCompleted,
    required int Function(Habit habit) getExpected,

    required String Function(int completed, int expected)
        habitCompletedText,

    required String reportTitle,
    required String overallProgressLabel,
    required String habitsLabel,
    required String noHabitsLabel,
    required String levelLabel,
    required String experienceLabel,
    required String bestStreakLabel,
    required String generatedAtLabel,
    required String pageLabel,
    required String monthLabel,
  }) async {
    final pdf = pw.Document();

    // ----------------------------
    // FOTO DE PERFIL
    // ----------------------------
    Uint8List? profilePhotoBytes;

    if (profilePhotoPath != null) {
      final file = File(profilePhotoPath);

      if (await file.exists()) {
        profilePhotoBytes = await file.readAsBytes();
      }
    }

    // ----------------------------
    // LOGO DO APP
    // ----------------------------
    Uint8List? logoBytes;

    try {
      final logoData = await rootBundle.load(
        'assets/images/logo.png',
      );

      logoBytes = logoData.buffer.asUint8List();
    } catch (_) {
      logoBytes = null;
    }

    // ----------------------------
    // ÍCONES DOS HÁBITOS
    // ----------------------------
    final Map<String, Uint8List?> habitIcons = {};

    for (final habit in habits) {
      if (habitIcons.containsKey(habit.iconName)) {
        continue;
      }

      try {
        final iconData = await rootBundle.load(
          'assets/icons/${habit.iconName}.png',
        );

        habitIcons[habit.iconName] =
            iconData.buffer.asUint8List();
      } catch (_) {
        habitIcons[habit.iconName] = null;
      }
    }

    // ----------------------------
    // PDF
    // ----------------------------
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),

        header: (context) {
          return _buildHeader(
            logoBytes: logoBytes,
            monthLabel: monthLabel,
            reportTitle: reportTitle,
          );
        },

        footer: (context) {
          return _buildFooter(
            context,
            generatedAtLabel,
            pageLabel,
          );
        },

        build: (context) {
          return [
            pw.SizedBox(height: 12),

            // PERFIL
            _buildUserSection(
              user: user,
              bestStreak: bestStreak,
              profilePhotoBytes: profilePhotoBytes,
              levelLabel: levelLabel,
              experienceLabel: experienceLabel,
              bestStreakLabel: bestStreakLabel,
            ),

            pw.SizedBox(height: 24),

            // PROGRESSO GERAL
            _buildOverallProgress(
              overallProgress,
              overallProgressLabel,
            ),

            pw.SizedBox(height: 24),

            // TÍTULO HÁBITOS
            pw.Text(
              habitsLabel,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),

            pw.SizedBox(height: 12),

            if (habits.isEmpty)
              pw.Text(
                noHabitsLabel,
                style: const pw.TextStyle(
                  fontSize: 11,
                ),
              ),

            // LISTA DE HÁBITOS
            ...habits.map(
              (habit) {
                final completed =
                    getCompleted(habit);

                final expected =
                    getExpected(habit);

                final double progress =
                    expected == 0
                        ? 0.0
                        : completed / expected;

                return _buildHabitItem(
                  habit: habit,
                  completed: completed,
                  expected: expected,
                  progress: progress,
                  iconBytes: habitIcons[habit.iconName],
                  completedText: habitCompletedText(
                    completed,
                    expected,
                  ),
                );
              },
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  // ============================================================
  // HEADER
  // ============================================================

  pw.Widget _buildHeader({
    required Uint8List? logoBytes,
    required String monthLabel,
    required String reportTitle,
  }) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment:
              pw.CrossAxisAlignment.center,
          children: [
            if (logoBytes != null)
              pw.Container(
                width: 45,
                height: 45,
                child: pw.ClipOval(
                  child: pw.Image(
                    pw.MemoryImage(logoBytes),
                    fit: pw.BoxFit.cover,
                  ),
                ),
              ),

            if (logoBytes != null)
              pw.SizedBox(width: 14),

            pw.Expanded(
              child: pw.Column(
                crossAxisAlignment:
                    pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Tracking Your Habits',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight:
                          pw.FontWeight.bold,
                    ),
                  ),

                  pw.SizedBox(height: 3),

                  pw.Text(
                    reportTitle,
                    style:
                        const pw.TextStyle(
                      fontSize: 13,
                    ),
                  ),

                  pw.SizedBox(height: 2),

                  pw.Text(
                    monthLabel,
                    style:
                        const pw.TextStyle(
                      fontSize: 10,
                      color:
                          PdfColors.grey700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 10),

        pw.Divider(
          thickness: 0.7,
        ),
      ],
    );
  }

  // ============================================================
  // PERFIL
  // ============================================================

  pw.Widget _buildUserSection({
    required User user,
    required int bestStreak,
    required Uint8List? profilePhotoBytes,
    required String levelLabel,
    required String experienceLabel,
    required String bestStreakLabel,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),

      decoration: pw.BoxDecoration(
        border: pw.Border.all(
          color: PdfColors.grey400,
        ),

        borderRadius:
            pw.BorderRadius.circular(8),
      ),

      child: pw.Row(
        crossAxisAlignment:
            pw.CrossAxisAlignment.center,

        children: [
          // FOTO
          pw.Container(
            width: 72,
            height: 72,

            decoration: pw.BoxDecoration(
              shape: pw.BoxShape.circle,

              border: pw.Border.all(
                color: PdfColors.grey400,
              ),
            ),

            child:
                profilePhotoBytes != null
                    ? pw.ClipOval(
                        child: pw.Image(
                          pw.MemoryImage(
                            profilePhotoBytes,
                          ),
                          fit:
                              pw.BoxFit.cover,
                        ),
                      )
                    : pw.Center(
                        child: pw.Text(
                          user.name.isNotEmpty
                              ? user.name[0]
                                  .toUpperCase()
                              : '?',

                          style:
                              pw.TextStyle(
                            fontSize: 28,
                            fontWeight:
                                pw.FontWeight.bold,
                          ),
                        ),
                      ),
          ),

          pw.SizedBox(width: 20),

          // INFORMAÇÕES
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,

              children: [
                pw.Text(
                  user.name,
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight:
                        pw.FontWeight.bold,
                  ),
                ),

                pw.SizedBox(height: 8),

                pw.Text(
                  '$levelLabel: ${user.level}',
                  style:
                      const pw.TextStyle(
                    fontSize: 11,
                  ),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  '$experienceLabel: ${user.experience} XP',
                  style:
                      const pw.TextStyle(
                    fontSize: 11,
                  ),
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  '$bestStreakLabel: $bestStreak',
                  style:
                      const pw.TextStyle(
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // PROGRESSO GERAL
  // ============================================================

  pw.Widget _buildOverallProgress(
    double progress,
    String overallProgressLabel,
  ) {
    final safeProgress =
        progress.clamp(0.0, 1.0).toDouble();

    final percentage =
        (safeProgress * 100).round();

    return pw.Column(
      crossAxisAlignment:
          pw.CrossAxisAlignment.start,

      children: [
        pw.Row(
          mainAxisAlignment:
              pw.MainAxisAlignment
                  .spaceBetween,

          children: [
            pw.Text(
              overallProgressLabel,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),

            pw.Text(
              '$percentage%',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight:
                    pw.FontWeight.bold,
              ),
            ),
          ],
        ),

        pw.SizedBox(height: 8),

        pw.LinearProgressIndicator(
          value: safeProgress,
          minHeight: 8,

          backgroundColor:
              PdfColors.grey300,

          valueColor:
              PdfColors.blue,
        ),
      ],
    );
  }

  // ============================================================
  // HÁBITO
  // ============================================================

  pw.Widget _buildHabitItem({
    required Habit habit,
    required int completed,
    required int expected,
    required double progress,
    required Uint8List? iconBytes,
    required String completedText,
  }) {
    final safeProgress =
        progress.clamp(0.0, 1.0).toDouble();

    final percentage =
        (safeProgress * 100).round();

    return pw.Container(
      margin:
          const pw.EdgeInsets.only(
        bottom: 12,
      ),

      padding:
          const pw.EdgeInsets.only(
        bottom: 8,
      ),

      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey300,
            width: 0.5,
          ),
        ),
      ),

      child: pw.Row(
        crossAxisAlignment:
            pw.CrossAxisAlignment.center,

        children: [
          // ÍCONE
          pw.Container(
            width: 34,
            height: 34,

            child: iconBytes != null
                ? pw.ClipOval(
                    child: pw.Image(
                      pw.MemoryImage(
                        iconBytes,
                      ),
                      fit:
                          pw.BoxFit.cover,
                    ),
                  )
                : pw.Center(
                    child: pw.Text(
                      '•',
                      style:
                          const pw.TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
          ),

          pw.SizedBox(width: 10),

          // CONTEÚDO
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment:
                  pw.CrossAxisAlignment.start,

              children: [
                pw.Row(
                  mainAxisAlignment:
                      pw.MainAxisAlignment
                          .spaceBetween,

                  children: [
                    pw.Expanded(
                      child: pw.Text(
                        habit.name,

                        style:
                            pw.TextStyle(
                          fontSize: 12,
                          fontWeight:
                              pw.FontWeight
                                  .bold,
                        ),
                      ),
                    ),

                    pw.Text(
                      '$percentage%',

                      style:
                          pw.TextStyle(
                        fontSize: 11,
                        fontWeight:
                            pw.FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 3),

                pw.Text(
                  completedText,

                  style:
                      const pw.TextStyle(
                    fontSize: 9,
                    color:
                        PdfColors.grey700,
                  ),
                ),

                pw.SizedBox(height: 5),

                pw.LinearProgressIndicator(
                  value: safeProgress,
                  minHeight: 5,

                  backgroundColor:
                      PdfColors.grey300,

                  valueColor:
                      PdfColors.blue,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // FOOTER
  // ============================================================

  pw.Widget _buildFooter(
    pw.Context context,
    String generatedAtLabel,
    String pageLabel,
  ) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(
        top: 10,
      ),
      child: pw.Text(
        '$generatedAtLabel ${_formatDate(DateTime.now())}'
        '  •  $pageLabel ${context.pageNumber}/${context.pagesCount}',
        style: const pw.TextStyle(
          fontSize: 8,
          color: PdfColors.grey600,
        ),
      ),
    );
  }

  // ============================================================
  // FORMATAÇÃO
  // ============================================================

  String _formatDate(
    DateTime date,
  ) {
    final day =
        date.day.toString().padLeft(
              2,
              '0',
            );

    final month =
        date.month.toString().padLeft(
              2,
              '0',
            );

    return '$day/$month/${date.year}';
  }

}