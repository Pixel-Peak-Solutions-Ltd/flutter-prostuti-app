import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'appwrite_services.dart';

class AuthService {
  final Account _account;

  AuthService(Client client) : _account = Account(client);

  Future<Session?> login(
      {required String email, required String password}) async {
    try {
      final session = await _account.createEmailPasswordSession(
          email: email, password: password);
      return session;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUser() async {
    try {
      final user = await _account.get();
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
    } catch (e) {
      rethrow;
    }
  }

  Future<Session?> register(
      {required String email,
      required String password,
      required String name}) async {
    try {
      final user = await _account.create(
        userId: ID.unique(),
        email: email,
        password: password,
        name: name,
      );
      final session = await _account.createEmailPasswordSession(
          email: email, password: password);
      return session;
    } catch (e) {
      rethrow;
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  final client = ref.watch(appwriteClientProvider);
  return AuthService(client);
});
