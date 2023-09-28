// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/cloud/cloud_note.dart';
import 'package:beginners_course/service/cloud/firebase_cloud_storage.dart';
import 'package:beginners_course/utils/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:beginners_course/utils/generics/get_args.dart';

import 'package:share_plus/share_plus.dart';

import 'package:flutter/material.dart';

class NewNotesViewsPage extends StatefulWidget {
  const NewNotesViewsPage({super.key});

  @override
  State<NewNotesViewsPage> createState() => _NewNotesViewsPageState();
}

class _NewNotesViewsPageState extends State<NewNotesViewsPage> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textcontroller;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textcontroller = TextEditingController();
    super.initState();
  }

  Future<CloudNote> createNewNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textcontroller.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = Authservice.firebase().currentUser!;
    final userId = currentUser.id;
    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteifTextIsEmpty() {
    final note = _note;
    if (_textcontroller.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteifTextNotEmpty() async {
    final note = _note;
    final text = _textcontroller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
          note: note, text: text, documentId: note.documentId);
    }
  }

  void _textControllerlistener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _notesService.updateNote(
        note: note, text: text, documentId: note.documentId);
  }

  void _setupTextControllerListener() {
    _textcontroller.removeListener(_textControllerlistener);
    _textcontroller.addListener(_textControllerlistener);
  }

  @override
  void dispose() {
    super.dispose();
    _deleteNoteifTextIsEmpty();
    _saveNoteifTextNotEmpty();
    _textcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "context.loc.note",
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textcontroller.text;
              if (_note == null || text.isEmpty) {
                await cannotShareEmptyNoteDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share),
          ),
        ],
        // title: Text('New Note'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder(
          future: createNewNote(context),
          builder: (context, index) {
            switch (index.connectionState) {
              case ConnectionState.done:
                _setupTextControllerListener();
                return TextField(
                  controller: _textcontroller,
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  decoration:
                      InputDecoration(hintText: 'Write down your notes here'),
                );

              default:
                return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
