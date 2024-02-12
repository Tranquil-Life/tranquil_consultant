import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tl_consultant/core/constants/end_points.dart';
import 'dart:convert';

import 'package:tl_consultant/features/journal/data/models/note.dart';

class NotesController extends GetxController {
  static NotesController instance = Get.find();
  RxList<Note> notes = <Note>[].obs;

  @override
  void onInit() {
    fetchNotes(); // Fetch notes when controller initializes
    super.onInit();
  }

  Future<void> fetchNotes() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}${JournalEndPoints.fetchNote}'));
      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        notes.value = responseData.map((data) => Note.fromJson(data)).toList();
      } else {
        throw Exception('Failed to fetch notes');
      }
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  void addNote(String title, String note) {
    // Logic to add note remains the same
  }

  // Other methods like clearData remain the same
}
