import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/widgets/note_card_widget.dart';

import '../model/note.dart';
import 'add_edit_note_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    refreshNotes();
  }

  Future refreshNotes() async {
    setState(() {
      isLoading = true;
    });

    notes = await NoteDatabase.instance.getAllnotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Notes"),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text(
                    "kosong",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  )
                : buildNotesView(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final route =
              MaterialPageRoute(builder: (context) => AddEditNotePage());
          await Navigator.push(context, route);
          refreshNotes();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildNotesView() => MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 4,
      crossAxisSpacing: 4,
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return GestureDetector(
            onTap: () async {
              final route = MaterialPageRoute(
                  builder: (context) => NoteDetailPage(noteId: note.id));
              await Navigator.push(context, route);
              refreshNotes();
            },
            child: NoteCardWidget(note: note, index: index));
      });
}
