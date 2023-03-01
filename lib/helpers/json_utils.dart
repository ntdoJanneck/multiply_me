library json_utils;

import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class JsonUtils {
  /// Returns the local path to save json data at.
  static Future<File> _localPath(String? filename) async {
    final directory = await getApplicationSupportDirectory();
    filename = (filename != null) ? "/$filename" : "";
    return File("${directory.path}$filename");
  }

  /// Writes a File with the content [content] to the path returned by [_localPath] with the [filename].
  static Future<File> writeJsonFile(String content, String filename) async {
    final file = await _localPath(filename);
    try {
      log("[JSON UTILS] Writing file");
      return file.writeAsString(content);
    } catch (e) {
      log("[JSON UTILS] Failed to write file: $e");
      rethrow;
    }
  }

  /// Reads the file with [filename] at the path returned by [_localPath].
  static Future<String> readJsonFile(String filename) async {
    final file = await _localPath(filename);
    try {
      final content = await file.readAsString();
      log("[JSON UTILS] Loaded File");
      return content;
    } catch (e) {
      return "";
    }
  }

  static Future<void> deleteJsonFile(String filename) async {
    try {
      final file = await _localPath(filename);
      await file.delete();
    } catch (e) {
      rethrow;
    }
  }
}
