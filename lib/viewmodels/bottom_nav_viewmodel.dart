import 'package:flutter/material.dart';
import 'package:habify/features/add_habit.dart';
import 'package:habify/features/chart/chart_screen.dart';
import 'package:habify/features/tasks/progress_screen.dart';
import 'package:habify/models/note.dart';
import 'package:habify/services/note_service.dart';
import 'package:habify/views/profile.dart';
import '../views/home.dart';

class BottomNavViewModel {
  final ValueNotifier<int> selectedIndex = ValueNotifier(0);
  final NoteService _noteService;
  final String username;

  final List<Widget> pages;

  BottomNavViewModel( this.username)
      : _noteService = NoteService(),
        pages = [
          HomeScreen(username: username, taskCompletionPercentage: 0.0),
            ChartScreen(),
           AddScreen(username: username),
           ProgressScreen(),
           ProfileScreen(username: username),
        ];

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void showAddOptions(BuildContext context, Function switchToAddScreen,
      Function showAddNotePopup) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.task),
                title: const Text('Add Task'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/add', arguments: {
                    'username': username, // Replace with actual username
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.note_add),
                title: const Text('Add Note'),
                onTap: () {
                  Navigator.pop(context);
                  showAddNotePopup();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showAddNotePopup(BuildContext context, NoteService _noteService) {
    TextEditingController titleController = TextEditingController();
    TextEditingController contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = titleController.text.trim();
                String content = contentController.text.trim();

                if (title.isNotEmpty && content.isNotEmpty) {
                  CustomNote note = CustomNote(title: title, content: content);
                  await _noteService.addNote(
                      note); // ✅ Ensure _noteService is passed as a parameter
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
