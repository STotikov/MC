import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';

class DepartmentsScreen extends ConsumerWidget {
  const DepartmentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentsProvider);
    final notifier = ref.read(studentsProvider.notifier);

    if (notifier.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.errorMessage != null) {
      return Center(child: Text(notifier.errorMessage!));
    }

    final departmentCounts = {
      DepartmentType.finance: 0,
      DepartmentType.law: 0,
      DepartmentType.it: 0,
      DepartmentType.medical: 0,
    };

    for (var student in students) {
      departmentCounts[student.department] =
          departmentCounts[student.department]! + 1;
    }

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(12),
      children: departmentCounts.entries.map((entry) {
        final department = entry.key;
        final count = entry.value;

        return Card(
          elevation: 4,
          margin: const EdgeInsets.all(8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.indigo.shade100,
                  Colors.indigo.shade400,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(departmentIcons[department], size: 40),
                const SizedBox(height: 10),
                Text(department.name.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text('$count student${count == 1 ? '' : 's'}'),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}