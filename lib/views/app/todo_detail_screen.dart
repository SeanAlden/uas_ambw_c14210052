import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uas_ambw_c14210052/controllers/todo_controller.dart';
import 'package:uas_ambw_c14210052/models/todo_model.dart';

class TodoDetailScreen extends StatelessWidget {
  final Todo todo;

  const TodoDetailScreen({super.key, required this.todo});

  @override
  Widget build(BuildContext context) {
    final TodoController controller = Get.find();

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String formattedDueDate =
        DateFormat('EEEE, d MMMM y', 'id_ID').format(todo.dueDate);
    final String formattedDueTime =
        DateFormat('HH:mm', 'id_ID').format(todo.dueDate);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Detail Tugas',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
        actions: [
          if (!todo.isArchived)
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              tooltip: 'Archive',
              onPressed: () async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text('Arsipkan tugas ini?'),
                    actions: [
                      TextButton(
                          onPressed: () => Get.back(result: false),
                          child: const Text('Batal')),
                      ElevatedButton(
                        onPressed: () => Get.back(result: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: const Text('Arsipkan'),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  await controller.archiveTodo(todo);
                  Get.back();
                  Get.snackbar(
                    'Berhasil',
                    'Tugas "${todo.taskName}" telah diarsipkan.',
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: colorScheme.surfaceVariant,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    todo.taskName,
                    style: textTheme.headlineMedium?.copyWith(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusChip(context, todo.isCompleted),
                  ),
                  const Divider(height: 32, thickness: 1),
                  _buildDetailRow(
                    context: context,
                    icon: Icons.calendar_today,
                    title: 'Batas Waktu',
                    content: '$formattedDueDate - Pukul $formattedDueTime',
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context: context,
                    icon: Icons.category,
                    title: 'Kategori',
                    content: todo.category ?? 'Tidak ada kategori',
                    contentWidget: todo.category != null
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Chip(
                              label: Text(
                                todo.category!,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                              ),
                              backgroundColor: colorScheme.secondaryContainer,
                              side: BorderSide.none,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    context: context,
                    icon: Icons.description,
                    title: 'Deskripsi',
                    content: (todo.description?.isNotEmpty ?? false)
                        ? todo.description!
                        : 'Tidak ada deskripsi',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, bool isCompleted) {
    final Color chipColor =
        isCompleted ? Colors.green.shade100 : Colors.orange.shade100;
    final Color contentColor =
        isCompleted ? Colors.green.shade800 : Colors.orange.shade800;
    final IconData icon =
        isCompleted ? Icons.check_circle : Icons.hourglass_empty;
    final String label = isCompleted ? 'Selesai' : 'Belum Selesai';

    final Color darkChipColor =
        isCompleted ? Colors.green.shade800 : Colors.orange.shade800;
    final Color darkContentColor =
        isCompleted ? Colors.green.shade100 : Colors.orange.shade100;

    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Chip(
      label: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          color: isDark ? darkContentColor : contentColor,
        ),
      ),
      backgroundColor: isDark ? darkChipColor : chipColor,
      avatar: Icon(
        icon,
        color: isDark ? darkContentColor : contentColor,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      side: BorderSide.none,
    );
  }

  Widget _buildDetailRow({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    Widget? contentWidget,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: textTheme.titleMedium?.copyWith(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: textTheme.bodySmall?.color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 28.0),
          child: contentWidget ??
              Text(
                content,
                style: textTheme.bodyLarge?.copyWith(
                  fontFamily: 'Poppins',
                  height: 1.5,
                ),
              ),
        ),
      ],
    );
  }
}
