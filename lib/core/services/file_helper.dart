import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  final Dio _dio = Dio();

  Future<String?> downloadFile(String url, String fileName) async {
    try {
      // Get the device's temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/$fileName";

      // Download the file
      await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {}
        },
      );

      return filePath;
    } catch (e) {
      return null;
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      final result = await OpenFilex.open(filePath);
    } catch (e) {}
  }
}
