import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notessqll/data_base_helper/data_base_helper.dart';
import 'package:notessqll/models/notes_model.dart';
import 'package:notessqll/presentation/cubit/notes_state.dart';



class NotesCubit extends Cubit<NotesState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  NotesCubit() : super(NotesInitial());

  void loadNotes() async {
    emit(NotesLoading());
    try {
      final notes = await _databaseHelper.getNotes();
      emit(NotesLoaded(notes));
    } catch (e) {
      emit(NotesError("Failed to load notes"));
    }
  }

  void addNote(Note note) async {
    try {
      await _databaseHelper.addNote(note);
      loadNotes(); 
    } catch (e) {
      emit(NotesError("Failed to add note"));
    }
  }

  void updateNote(Note note) async {
    try {
      await _databaseHelper.updateNote(note);
      loadNotes(); 
    } catch (e) {
      emit(NotesError("Failed to update note"));
    }
  }

  void deleteNote(int id) async {
    try {
      await _databaseHelper.deleteNote(id);
      loadNotes();
    } catch (e) {
      emit(NotesError("Failed to delete note"));
    }
  }
}
