
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:plottertopicos/utils/constants.dart';

class Archive {

  static Future<void> save(Map<String, dynamic> data, String name) async {
    final file = File('$PATH/$name.odt');
    await file.writeAsString(json.encode(data));
  }

  static Future<Map<String, dynamic>> open() async {
    try {
      final path = await FilePicker.platform.pickFiles(
        type: FileType.custom, 
        allowedExtensions: ['odt'],
      );

      if (path == null) {
        throw Exception('No se eligio un archivo');
      }

      final file = File(path.files.first.path);
      return json.decode(await file.readAsString());
    } catch (e) {
      throw Exception(e.message);
    }
  }
}