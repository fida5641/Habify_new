import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/note.dart';

class NoteService {
  final ValueNotifier<List<CustomNote>> notes = ValueNotifier([]);

  NoteService() {
    _openBox();
  }

  Future<void> _openBox() async {
    if (!Hive.isBoxOpen('notes')) {
      await Hive.openBox<CustomNote>('notes'); // ✅ Open the box first
    }
    // loadNotes();
  }

  Future<void> addNote(CustomNote note) async {
    final box = Hive.box<CustomNote>('notes');
    await box.add(note);
    // loadNotes(); // Refresh UI
  }

  // Future<void> loadNotes() async {
  //   await _openBox();
  //   final box = Hive.box<CustomNote>('notes');
  //   notes.value = box.values.toList();
  // }

  Future<void> updateNote(int index, CustomNote updatedNote) async {
    final box = Hive.box<CustomNote>('notes');
    await box.putAt(index, updatedNote);
    // loadNotes(); // Refresh UI
  }

  Future<void> deleteAllNotes() async {
    final box = Hive.box<CustomNote>('notes');
    await box.clear();
    // loadNotes(); // Refresh UI
  }
}
