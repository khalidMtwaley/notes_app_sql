import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notessqll/models/notes_model.dart';
import 'package:notessqll/presentation/cubit/notes_cubit.dart';
import 'package:notessqll/presentation/cubit/notes_state.dart';


class NotesPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showNoteDialog(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<NotesCubit, NotesState>(
        listener: (context, state) {
          if (state is NotesError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is NotesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is NotesLoaded) {
            return ListView.builder(
              itemCount: state.notes.length,
              itemBuilder: (context, index) {
                final note = state.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(note.content),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      context.read<NotesCubit>().deleteNote(note.id!);
                    },
                  ),
                  onTap: () {
                    _showNoteDialog(context, note: note);
                  },
                );
              },
            );
          } else {
            return Center(child: Text("No notes available."));
          }
        },
      ),
    );
  }

  void _showNoteDialog(BuildContext context, {Note? note}) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(note == null ? "Add Note" : "Edit Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Title"),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: "Content"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final title = _titleController.text;
              final content = _contentController.text;
              if (title.isNotEmpty && content.isNotEmpty) {
                if (note == null) {
                  context.read<NotesCubit>().addNote(Note(
                        title: title,
                        content: content,
                      ));
                } else {
                  context.read<NotesCubit>().updateNote(Note(
                        id: note.id,
                        title: title,
                        content: content,
                      ));
                }
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
