import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/students_provider.dart';
import '../widgets/student_item.dart';
import '../widgets/new_student_form.dart';

class StudentsScreen extends ConsumerWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final notifier = ref.read(studentsProvider.notifier);
    final isLoading = notifier.loading;
    final error = notifier.errorMessage;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(child: Text(error));
    }

    if (students.isEmpty) {
      return const Center(child: Text('Список студентів порожній'));
    }

    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (ctx, i) {
        final student = students[i];

        return Dismissible(
          key: ValueKey(student.id),
          background: Container(color: Colors.red),
          onDismissed: (_) {
            notifier.removeStudentLocal(student);

            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context)
                .showSnackBar(
                  SnackBar(
                    duration: const Duration(seconds: 3),
                    content: const Text('Студента видалено'),
                    action: SnackBarAction(
                      label: 'Undo',
                      onPressed: () {
                        notifier.insertStudentLocal(student, i);
                      },
                    ),
                  ),
                )
                .closed
                .then((reason) {
              if (reason != SnackBarClosedReason.action) {
                notifier.removeFromFirebase(student);
              }
            });
          },
          child: InkWell(
            onTap: () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) => NewStudentForm(student: student, index: i),
            ),
            child: StudentItem(student: student),
          ),
        );
      },
    );
  }
}
