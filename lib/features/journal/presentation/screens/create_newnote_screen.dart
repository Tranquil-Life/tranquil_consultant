import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';
import 'package:tl_consultant/features/journal/data/models/note.dart';
import 'package:tl_consultant/features/journal/presentation/controllers/notes_controller.dart';

class NewNote extends StatefulWidget {
  const NewNote({Key? key}) : super(key: key);

  @override
  _NewNoteState createState() => _NewNoteState();
}

class _NewNoteState extends State<NewNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  bool _isItalic = false;
  bool _isBold = false;
  bool _isUnderline = false;
  bool _isCrossed = false;

  final NotesController noteController = Get.put(NotesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: false,
        title: "New note",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              maxLines: 1,
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TextField(
                controller: _noteController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: "What are your thoughts?",
                  border: InputBorder.none,
                ),
                style: TextStyle(
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  decoration: _isUnderline ? TextDecoration.underline : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    Get.defaultDialog(
                      confirm: SizedBox(
                        height: 40,
                        width: 180,
                        child: CustomButton(
                          onPressed: () {},
                          child: const Text("Apply Option"),
                        ),
                      ),
                      cancel: SizedBox(
                        height: 40,
                        width: 80,
                        child: CustomButton(
                          onPressed: () {},
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: ColorPalette.white),
                          ),
                        ),
                      ),
                      title: "Text options",
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Choose text options to apply to text:"),
                          ListTile(
                            title: const Text("Italic"),
                            onTap: () {
                              setState(() {
                                _isItalic = !_isItalic;
                              });
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: const Text("Bold"),
                            onTap: () {
                              setState(() {
                                _isBold = !_isBold;
                              });
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: const Text("Underline"),
                            onTap: () {
                              setState(() {
                                _isUnderline = !_isUnderline;
                              });
                              Get.back();
                            },
                          ),
                          ListTile(
                            title: const Text("Crossed Text"),
                            onTap: () {
                              setState(() {
                                _isCrossed = !_isCrossed;
                              });
                              Get.back();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                  child: const Text("Format"),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Add attachment logic
                  },
                  child: const Text("Attachment"),
                ),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: CustomButton(
                    onPressed: () async {
                      final title = _titleController.text;
                      final description = _noteController.text;
                      final note = NoteModel(
                        id: 0, // Set the ID as needed, or leave it as 0 if it's generated by the backend
                        title: title,
                        description: description,
                        hexColor: '#FFFFFF', // Set the color as needed
                        clientDp: '', // Set the clientDp as needed
                        clientName: '', // Set the clientName as needed
                        mood: null, // Set the mood as needed
                        dateUpdated:
                            DateTime.now(), // Set the dateUpdated as needed
                      );

                      try {
                        await noteController.addNote(
                          note,
                          title: title,
                          description: description,
                          hexColor: '#FFFFFF', // Pass the color as needed
                          clientDp: '', // Pass the clientDp as needed
                          clientName: '', // Pass the clientName as needed
                          dateUpdated:
                              DateTime.now(), // Pass the dateUpdated as needed
                        );
                        // Optionally, you can show a success message or navigate to another screen upon successful note creation
                      } catch (e) {
                        // Handle error
                        print('Error saving note: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Failed to save note. Please try again.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      "Save note",
                      style: TextStyle(color: ColorPalette.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }
}
