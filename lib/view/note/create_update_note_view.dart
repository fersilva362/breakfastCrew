import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:user_app/services/auth/auth_service.dart';
import 'package:user_app/services/cloud/cannot_share_empty_note.dart';
import 'package:user_app/services/cloud/cloud_note.dart';
import 'package:user_app/services/cloud/firebase_cloud_storage.dart';
import 'dart:developer' as devtools show log;

import 'package:user_app/utilities/generic/get_arguments.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _noteService;
  late final TextEditingController _textController;
  @override
  void initState() {
    _noteService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  Future<CloudNote> createOrGetExistingNote() async {
    final widgetNote = context.getArguments<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currenteUser = AuthService.firebase().currentUser!;
    //final email = currenteUser.email;
    final userId = currenteUser.id;
    final newNote = await _noteService.createNewNote(ownerUserId: userId);
    _note = newNote;

    return newNote;
  }

  void _deleteNoteIfTextEmpty() async {
    final text = _textController.text;
    final note = _note;
    if (text.isEmpty && note != null) {
      await _noteService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;

    if (text.isNotEmpty && note != null) {
      await _noteService.updateNote(documentId: note.documentId, text: text);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    final text = _textController.text;
    if (note == null) {
      return;
    }
    await _noteService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextController() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
    devtools.log('pass in setupTextController ');
  }

  @override
  void dispose() {
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
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (text.isEmpty || _note == null) {
                devtools.log(text);
                await showCannotShareEmptyNote(context: context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
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
