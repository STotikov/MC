import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student.dart';
import '../providers/students_provider.dart';
import 'package:uuid/uuid.dart';

class NewStudentForm extends ConsumerStatefulWidget {
  final Student? student;
  final int? index;
  const NewStudentForm({super.key, this.student, this.index});

  @override
  ConsumerState<NewStudentForm> createState() => _NewStudentFormState();
}

class _NewStudentFormState extends ConsumerState<NewStudentForm> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _gradeController = TextEditingController();
  DepartmentType _selectedDepartment = DepartmentType.it;
  Gender _selectedGender = Gender.male;

  @override
  void initState() {
    super.initState();
    if (widget.student != null) {
      _firstNameController.text = widget.student!.firstName;
      _lastNameController.text = widget.student!.lastName;
      _selectedDepartment = widget.student!.department;
      _selectedGender = widget.student!.gender;
      _gradeController.text = widget.student!.grade.toString();
    }
  }

  void _submit() {
    final grade = int.tryParse(_gradeController.text.trim()) ?? 0;
    final student = Student(
      id: widget.student?.id ?? const Uuid().v4(),
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      department: _selectedDepartment,
      grade: grade,
      gender: _selectedGender,
    );
    if (widget.student != null && widget.index != null) {
      ref.read(studentsProvider.notifier).edit(widget.index!, student);
    } else {
      ref.read(studentsProvider.notifier).add(student);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.student != null ? 'Edit Student' : 'Add Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              DropdownButtonFormField<DepartmentType>(
                value: _selectedDepartment,
                decoration: const InputDecoration(labelText: 'Department'),
                onChanged: (val) => setState(() => _selectedDepartment = val!),
                items: DepartmentType.values.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Row(
                      children: [
                        Icon(departmentIcons[d]),
                        const SizedBox(width: 8),
                        Text(d.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
              DropdownButtonFormField<Gender>(
                value: _selectedGender,
                decoration: const InputDecoration(labelText: 'Gender'),
                onChanged: (val) => setState(() => _selectedGender = val!),
                items: Gender.values.map((g) {
                  return DropdownMenuItem(value: g, child: Text(g.name));
                }).toList(),
              ),
              TextField(
                controller: _gradeController,
                decoration: const InputDecoration(labelText: 'Grade (0-100)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submit,
                child: Text(widget.student != null ? 'Save' : 'Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
