import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/api_client.dart';
import '../services/ml_kit_service.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) => StorageService());

final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.read(storageServiceProvider);
  final client = ApiClient(storage);
  client.init();
  return client;
});

final mlKitServiceProvider = Provider<MlKitService>((ref) {
  final service = MlKitService();
  ref.onDispose(() => service.dispose());
  return service;
});
