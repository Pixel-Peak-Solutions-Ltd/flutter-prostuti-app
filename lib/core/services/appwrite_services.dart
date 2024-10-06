import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Replace with your Appwrite project details
const String appwriteEndpoint = 'https://[APPWRITE_ENDPOINT]';
const String appwriteProjectId = '[YOUR_PROJECT_ID]';

final appwriteClientProvider = Provider<Client>((ref) {
  final client = Client()
      .setEndpoint(appwriteEndpoint) // Your Appwrite Endpoint
      .setProject(appwriteProjectId); // Your project ID

  // Optionally, set the self-signed status or any other configurations
  // .setSelfSigned(status: true);

  return client;
});
