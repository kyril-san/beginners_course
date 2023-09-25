// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:beginners_course/const/routes.dart';
import 'package:beginners_course/enum/menu_action.dart';
import 'package:beginners_course/service/auth/auth_service.dart';
import 'package:beginners_course/service/crud/notes_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NotesService _notesService;
  String get userEmail => Authservice.firebase().currentUser!.email!;

  @override
  void initState() {
    super.initState();
    _notesService = NotesService();
    _notesService.open();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Ui'),
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
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginroute, (route) => false);
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
      body: FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.active:
                        if (snapshot.hasData) {
                          final allnotes = snapshot.data as List<DatabaseNote>;
                          return ListView.builder(
                              itemCount: allnotes.length,
                              itemBuilder: ((context, index) {
                                return ListTile(
                                  title: Text(
                                    allnotes[index].text,
                                    style: TextStyle(color: Colors.black),
                                    maxLines: 1,
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  // tileColor: Colors.red,
                                );
                              }));
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }

                      default:
                        return CircularProgressIndicator();
                    }
                  });
            default:
              return CircularProgressIndicator();
          }
        },
      ),
    );
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
