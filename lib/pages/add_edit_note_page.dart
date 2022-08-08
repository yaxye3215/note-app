import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/widgets/Note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({Key? key, this.note}) : super(key: key);

  final Note? note;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  final _formKey = GlobalKey<FormState>();

  late bool isImportant;
  late int number;
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [buildButtonSave()],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
            isImportant: isImportant,
            onChangedIsmportant: (value) {
              setState(() {
                isImportant = value;
              });
            },
            number: number,
            onChangeNumber: (value) {
              setState(() {
                number = value;
              });
            },
            title: title,
            onChangeTitle: (value) {
              title = value;
            },
            description: description,
            onChangeDescription: (value) {
              description = value;
            }),
      ),
    );
  }

  Widget buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
          onPressed: addOrEditNote,
          style: ElevatedButton.styleFrom(onPrimary: Colors.white),
          child: const Text("Save")),
    );
  }

  void addOrEditNote() async {
    final isvalid = _formKey.currentState!.validate();
    if (isvalid) {
      final isUpdate = widget.note != null;
      if (isUpdate) {
        await updateNote();
      } else {
        await addNote();
      }
      Navigator.pop(context);
    }
  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());

    await NoteDatabase.instance.createNote(note);
  }

  Future updateNote() async {
    final note = widget.note?.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.updateNote(note!);
  }
}
