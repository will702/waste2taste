import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';
import 'providers.dart';

class AuthNotifier extends AsyncNotifier<AppUser?> {
  @override
  Future<AppUser?> build() async {
    final storage = ref.read(storageServiceProvider);
    final token = await storage.getAccessToken();
    if (token == null) return null;
    try {
      final api = ref.read(apiClientProvider);
      final response = await api.get('/auth/me');
      final data = response.data as Map<String, dynamic>;
      return AppUser(
        id: data['id'] as String,
        email: data['email'] as String,
        accessToken: token,
      );
    } on DioException catch (e) {
      if (e.message == 'session_expired') {
        await storage.clearTokens();
        return null;
      }
      rethrow; // network errors etc → AsyncError state
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(apiClientProvider);
      final storage = ref.read(storageServiceProvider);
      final response = await api.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      await storage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String?,
      );
      final user = data['user'] as Map<String, dynamic>;
      state = AsyncData(AppUser(
        id: user['id'] as String,
        email: user['email'] as String,
        accessToken: data['access_token'] as String,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    state = const AsyncLoading();
    try {
      final api = ref.read(apiClientProvider);
      final storage = ref.read(storageServiceProvider);
      final response = await api.post(
        '/auth/register',
        data: {'email': email, 'password': password},
      );
      final data = response.data as Map<String, dynamic>;
      await storage.saveTokens(
        accessToken: data['access_token'] as String,
        refreshToken: data['refresh_token'] as String?,
      );
      final user = data['user'] as Map<String, dynamic>;
      state = AsyncData(AppUser(
        id: user['id'] as String,
        email: user['email'] as String,
        accessToken: data['access_token'] as String,
      ));
    } catch (e, st) {
      state = AsyncError(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    final api = ref.read(apiClientProvider);
    final storage = ref.read(storageServiceProvider);
    try {
      await api.post('/auth/logout');
    } catch (_) {}
    await storage.clearTokens();
    state = const AsyncData(null);
  }
}

final authProvider =
    AsyncNotifierProvider<AuthNotifier, AppUser?>(AuthNotifier.new);
