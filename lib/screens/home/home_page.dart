// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:beginners_course/const/routes.dart';
import 'package:beginners_course/enum/menu_action.dart';
import 'package:beginners_course/screens/notes/create_Update_delete.dart';
import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/cloud/cloud_note.dart';
import 'package:beginners_course/service/cloud/firebase_cloud_storage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final FirebaseCloudStorage _notesService;
  String get userId => Authservice.firebase().currentUser!.id;

  @override
  void initState() {
    super.initState();
    _notesService = FirebaseCloudStorage();
    // _notesService.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: _notesService.allNotes(ownerUserId: userId),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                final noteCount = snapshot.data ?? 0;
                final text = noteCount;
                return Text(text.toString().trim());
              } else {
                return const Text('');
              }
            },
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(newnotesview);
                },
                icon: Icon(Icons.add)),
            PopupMenuButton<MenuAction>(onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final logout = await showLogout(context);
                  log(logout.toString());
                  if (logout) {
                    await Authservice.firebase().logOut();
                    if (mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          loginroute, (route) => false);
                    }
                  }
                  break;
                default:
              }
            }, itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Logout'),
                )
              ];
            })
          ],
          backgroundColor: Colors.amber,
        ),
        body: StreamBuilder(
            stream: _notesService.allNotes(ownerUserId: userId),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allnotes = snapshot.data as Iterable<CloudNote>;
                    return Notebuilder(
                      allnotes: allnotes,
                      ondelete: (allnotes) async {
                        await _notesService.deleteNote(
                            documentId: allnotes.documentId);
                      },
                      onEdit: (note) {
                        Navigator.of(context)
                            .pushNamed(newnotesview, arguments: note);
                      },
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }

                default:
                  return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

Future<bool> showLogout(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to Sign Out'),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel')),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'))
          ],
        );
      }).then((value) => value ?? false);
}
