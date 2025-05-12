import 'package:flutter/material.dart';
import 'package:habify/models/note.dart';

class NoteItem extends StatelessWidget {
  final CustomNote note;
  final int noteIndex;
  final Function(int) onDelete;

  const NoteItem({
    super.key,
    required this.note,
    required this.noteIndex,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: ListTile(
        title: Text(note.title,
            style: const TextStyle(color: Colors.white70, fontSize: 20)),
        subtitle:
            Text(note.content, style: const TextStyle(color: Colors.white54)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.white),
          onPressed: () => onDelete(noteIndex),
        ),
      ),
    );
  }
}
