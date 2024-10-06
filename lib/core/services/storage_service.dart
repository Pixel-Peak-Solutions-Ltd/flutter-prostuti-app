// lib/services/storage_service.dart
import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as appwrite_models;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'appwrite_services.dart';

class StorageService {
  final Storage _storage;

  StorageService(Client client) : _storage = Storage(client);

  /// Uploads a file to the specified bucket.
  Future<appwrite_models.File?> uploadFile({
    required String bucketId,
    required String filePath,
    String? fileId, // Optional: provide a specific file ID or use default
  }) async {
    try {
      final file = File(filePath);
      final response = await _storage.createFile(
        bucketId: bucketId,
        fileId: fileId ?? ID.unique(),
        file: InputFile.fromPath(path: ''),
        // Optionally, add permissions
        // permissions: ['*'],
      );
      return response;
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  /// Lists all files in the specified bucket.
  Future<List<appwrite_models.File>> listFiles({
    required String bucketId,
    int limit = 25,
    int offset = 0,
  }) async {
    try {
      final response = await _storage.listFiles(
        bucketId: bucketId,
      );
      return response.files;
    } catch (e) {
      throw Exception('List Files failed: $e');
    }
  }

  /// Deletes a file from the specified bucket.
  Future<void> deleteFile({
    required String bucketId,
    required String fileId,
  }) async {
    try {
      await _storage.deleteFile(
        bucketId: bucketId,
        fileId: fileId,
      );
    } catch (e) {
      throw Exception('Delete File failed: $e');
    }
  }

// Add more methods as needed (e.g., getFile)
}

final storageServiceProvider = Provider<StorageService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return StorageService(client);
});
