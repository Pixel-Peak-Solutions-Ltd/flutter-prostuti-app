// lib/services/database_service.dart
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'appwrite_services.dart';

class DatabaseService {
  final Databases _databases;

  DatabaseService(Client client) : _databases = Databases(client);

  Future<Document> createDocument({
    required String databaseId,
    required String collectionId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final document = await _databases.createDocument(
        databaseId: databaseId,
        collectionId: collectionId,
        data: data,
        documentId: '', // Replace with actual user ID
      );
      return document;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Document>> listDocuments({
    required String databaseId,
    required String collectionId,
    int limit = 25,
    int offset = 0,
  }) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: databaseId,
        collectionId: collectionId,
      );
      return response.documents;
    } catch (e) {
      rethrow;
    }
  }

// Add more methods as needed (e.g., updateDocument, deleteDocument)
}

final databaseServiceProvider = Provider<DatabaseService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return DatabaseService(client);
});
