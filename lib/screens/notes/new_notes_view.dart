// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_service.dart';

import 'package:share_plus/share_plus.dart';

import 'package:beginners_course/service/crud/notes_services.dart';

import 'package:flutter/material.dart';

class NewNotesViewsPage extends StatefulWidget {
  const NewNotesViewsPage({super.key});

  @override
  State<NewNotesViewsPage> createState() => _NewNotesViewsPageState();
}

class _NewNotesViewsPageState extends State<NewNotesViewsPage> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textcontroller;

  @override
  void initState() {
    _notesService = NotesService();
    _textcontroller = TextEditingController();
    super.initState();
  }

  Future<DatabaseNote> createNewNote() async {
    final exisitingnote = _note;
    if (exisitingnote != null) {
      return exisitingnote;
    }
    final currentUser = Authservice.firebase().currentUser!;
    final email = currentUser.email;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteifTextIsEmpty() {
    final note = _note;
    if (_textcontroller.text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  void _saveNoteifTextNotEmpty() async {
    final note = _note;
    final text = _textcontroller.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(note: note, text: text);
    }
  }

  void _textControllerlistener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _notesService.updateNote(note: note, text: text);
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
                // await showCannotShareEmptyNoteDialog(context);
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
          future: createNewNote(),
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
                return CircularProgressIndicator();
            }
          }),
    );
  }
}
