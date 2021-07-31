
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:plottertopicos/utils/constants.dart';

class Archive {

  static Future<void> save(Map<String, dynamic> data, String name) async {
    final file = File('$PATH/$name.odt');
    await file.writeAsString(json.encode(data));
  }

  static Future<String> open() async {
    final path = await FilePicker.platform.pickFiles(
      type: FileType.custom, 
      allowedExtensions: ['odt'],
    );
    final file = File(path.files.first.path);
    return await file.readAsString();
  }
}