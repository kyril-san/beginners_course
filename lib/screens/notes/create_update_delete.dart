// ignore_for_file: prefer_const_constructors

import 'package:beginners_course/service/cloud/cloud_note.dart';
import 'package:flutter/material.dart';

// typedef DeleteNote = void Function(CloudNote note);

class Notebuilder extends StatelessWidget {
  final Function(CloudNote note) ondelete;
  final Function(CloudNote note) onEdit;

  const Notebuilder({
    super.key,
    required this.allnotes,
    required this.ondelete,
    required this.onEdit,
  });

  final Iterable<CloudNote> allnotes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: allnotes.length,
        itemBuilder: ((context, index) {
          return ListTile(
            onTap: () => onEdit(allnotes.elementAt(index)),
            title: Text(
              allnotes.elementAt(index).text,
              style: TextStyle(color: Colors.black),
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () {
                  ondelete(allnotes.elementAt(index));
                },
                icon: Icon(Icons.delete)),
          );
        }));
  }
}
