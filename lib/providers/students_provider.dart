import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/student.dart';

final studentsProvider = StateNotifierProvider<StudentsNotifier, List<Student>>((ref) {
  final notifier = StudentsNotifier();
  notifier.fetchStudents();  // важливо викликати
  return notifier;
});
class StudentsNotifier extends StateNotifier<List<Student>> {
  
  StudentsNotifier() : super([]);



  bool get loading => isLoading;
  String? get errorMessage => error;

  final String _baseUrl = 'https://students-1e3a1-default-rtdb.europe-west1.firebasedatabase.app/';

  bool isLoading = false;
  String? error;

  Future<void> fetchStudents() async {
    isLoading = true;
    state = [];
    try {
      final response = await http.get(Uri.parse('$_baseUrl.json'));
      final data = json.decode(response.body);
      if (data != null) {
        final loaded = <Student>[];
        (data as Map<String, dynamic>).forEach((id, jsonEntry) {
          loaded.add(Student(
            id: id,
            firstName: jsonEntry['firstName'],
            lastName: jsonEntry['lastName'],
            department: DepartmentType.values.firstWhere((d) => d.name == jsonEntry['department']),
            grade: jsonEntry['grade'],
            gender: Gender.values.firstWhere((g) => g.name == jsonEntry['gender']),
          ));
        });
        state = loaded;
      }
    } catch (e) {
      error = 'Помилка при завантаженні студентів';
    } finally {
      isLoading = false;
    }
  }

  Future<void> add(Student student) async {
    isLoading = true;
    try {
      final response = await http.post(Uri.parse('$_baseUrl.json'),
        body: json.encode({
          'firstName': student.firstName,
          'lastName': student.lastName,
          'department': student.department.name,
          'grade': student.grade,
          'gender': student.gender.name,
        }),
      );
      final id = json.decode(response.body)['name'];
      state = [...state, student.copyWith().copyWith(id: id)];
    } catch (e) {
      error = 'Помилка при створенні студента';
    } finally {
      isLoading = false;
    }
  }

  Future<void> edit(int index, Student student) async {
    isLoading = true;
    try {
      await http.put(Uri.parse('$_baseUrl/${student.id}.json'),
        body: json.encode({
          'firstName': student.firstName,
          'lastName': student.lastName,
          'department': student.department.name,
          'grade': student.grade,
          'gender': student.gender.name,
        }),
      );
      final newState = [...state];
      newState[index] = student;
      state = newState;
    } catch (e) {
      error = 'Помилка при редагуванні студента';
    } finally {
      isLoading = false;
    }
  }

  void removeStudentLocal(Student student) {
    state = state.where((s) => s.id != student.id).toList();
    
  }

  void insertStudentLocal(Student student, int index) {
    final newState = [...state];
    newState.insert(index, student);
    state = newState;
  }

  Future<void> removeFromFirebase(Student student) async {
    try {
      await http.delete(Uri.parse('$_baseUrl/${student.id}.json'));
    } catch (e) {
      error = 'Помилка при видаленні студента';
    }
  }
}
