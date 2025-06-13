import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NotesService {
  static Future<String> addNote(String note) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/notes.txt');
    await file.writeAsString('$note\n', mode: FileMode.append);
    return "Note added.";
  }

  static Future<String> readNotes() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/notes.txt');
    if (await file.exists()) {
      return await file.readAsString();
    } else {
      return "No notes yet.";
    }
  }
}
