import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tl_consultant/app/presentation/theme/colors.dart';
import 'package:tl_consultant/app/presentation/widgets/buttons.dart';
import 'package:tl_consultant/app/presentation/widgets/custom_app_bar.dart';

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
                            CheckboxListTile(
                              title: const Text("Italic"),
                              value: _isItalic,
                              onChanged: (value) {
                                setState(() {
                                  _isItalic = value ?? false;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Bold"),
                              value: _isBold,
                              onChanged: (value) {
                                setState(() {
                                  _isBold = value ?? false;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Underline"),
                              value: _isUnderline,
                              onChanged: (value) {
                                setState(() {
                                  _isUnderline = value ?? false;
                                });
                              },
                            ),
                            CheckboxListTile(
                              title: const Text("Crossed Text"),
                              value: _isCrossed,
                              onChanged: (value) {
                                setState(() {
                                  _isCrossed = value ?? false;
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Text("Format"),
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
