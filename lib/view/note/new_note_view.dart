import 'package:flutter/material.dart';
import 'package:user_app/services/auth/auth_service.dart';
import 'package:user_app/services/note_service.dart';
import 'dart:developer' as devtools show log;

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NoteService _noteService;
  late final TextEditingController _textController;
  @override
  void initState() {
    _noteService = NoteService();
    _textController = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createNewNote() async {
    final existingNote = _note;
    if (existingNote != null) {
      devtools.log('pasa por el if de createNewNote ');
      return existingNote;
    }
    final currenteUser = AuthService.firebase().currentUser!;
    final email = currenteUser.email!;
    final owner = await _noteService.getUser(email: email);

    final newNote = await _noteService.createNote(owner: owner);
    return newNote;
  }

  void _deleteNoteIfTextEmpty() async {
    final text = _textController.text;
    final note = _note;
    if (text.isEmpty && note != null) {
      await _noteService.deleteNote(
        id: note.id,
      );
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (text.isNotEmpty && note != null) {
      await _noteService.updateNote(
        text: text,
        note: note,
      );
    }
    devtools.log('deberia haber pasado por aca y save it pero note is $note');
    devtools.log(text);
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note == null) {
      return;
    }
    await _noteService.updateNote(
      text: text,
      note: note,
    );
  }

  void _setupTextController() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    devtools.log('pass in setupTextController ');
  }

  @override
  void dispose() {
    devtools.log('note after dispose ${_note.toString()}');
    _deleteNoteIfTextEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
        future: createNewNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data;
              devtools.log('_note is $_note');
              _setupTextController();

              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration:
                    const InputDecoration(hintText: 'Please write here'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
