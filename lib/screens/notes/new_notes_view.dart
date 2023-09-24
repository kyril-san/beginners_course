// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/crud/notes_services.dart';
import 'package:flutter/material.dart';

class NewNotesViewsPage extends StatefulWidget {
  const NewNotesViewsPage({super.key});

  @override
  State<NewNotesViewsPage> createState() => _NewNotesViewsPageState();
}

class _NewNotesViewsPageState extends State<NewNotesViewsPage> {
  DatabaseNotes? _note;
  late final NotesService _notesService;
  late final TextEditingController _textcontroller;

  @override
  void initState() {
    _notesService = NotesService();
    _textcontroller = TextEditingController();
    super.initState();
  }

  Future<DatabaseNotes> createNewNote(BuildContext context) async {
    final exisitingnote = _note;
    if (exisitingnote != null) {
      return exisitingnote;
    }
    final currentUser = Authservice.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createnote(owner: owner);
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
      await _notesService.updateNotes(note: note, text: text);
    }
  }

  void _textControllerlistener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textcontroller.text;
    await _notesService.updateNotes(note: note, text: text);
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
        title: Text('New Note'),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<DatabaseNotes>(
          future: createNewNote(context),
          builder: (context, index) {
            switch (index.connectionState) {
              case ConnectionState.done:
                _note = index.data;
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
