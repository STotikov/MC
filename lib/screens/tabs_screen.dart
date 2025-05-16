import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/new_student_form.dart';
import 'departments_screen.dart';

import '../providers/students_provider.dart';
import '../widgets/student_item.dart';

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedIndex = 0;

  void _selectTab(int index) => setState(() => _selectedIndex = index);

  void _openAddStudentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => const NewStudentForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final students = ref.watch(studentsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Students' : 'Departments'),
      ),
      body: _selectedIndex == 0
          ? ListView.builder(
              itemCount: students.length,
              itemBuilder: (ctx, i) => Dismissible(
                key: ValueKey(students[i].id),
                background: Container(color: Colors.red),
                onDismissed: (_) {
                  final removed = students[i];
                    final notifier = ref.read(studentsProvider.notifier);

                  ref.read(studentsProvider.notifier).removeStudentLocal(removed);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Student removed'),
                      action: SnackBarAction(
                        label: 'Undo',
                        onPressed: () => ref
                            .read(studentsProvider.notifier)
                            .insertStudentLocal(removed, i),
                      ),
                    ),
                  ).closed.then((reason) {
                    if (reason != SnackBarClosedReason.action) {
                      notifier.removeFromFirebase(removed);
                    }
                  });
                },
                child: InkWell(
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) => NewStudentForm(student: students[i], index: i),
                  ),
                  child: StudentItem(student: students[i]),
                ),
              ),
            )
          : DepartmentsScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _selectTab,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Departments'),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _openAddStudentModal(context),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}