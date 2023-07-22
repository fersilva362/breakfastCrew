import 'package:flutter/material.dart';
import 'package:user_app/services/note_service.dart';
import 'package:user_app/utilities/dialogs/delete_dialog.dart';

typedef DeleteNoteCallback = void Function(DatabaseNote note);

class NoteListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNoteCallback onDeleteNote;
  const NoteListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final myNote = notes[index].text;

          return ListTile(
            trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(context);
                if (shouldDelete) {
                  onDeleteNote(notes[index]);
                }
              },
              icon: const Icon(Icons.delete),
            ),
            title: Text(
              myNote,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }
}
