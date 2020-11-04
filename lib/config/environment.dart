import 'package:flutter_riverpod/flutter_riverpod.dart';

class Environment {
  final movieDbKey = const String.fromEnvironment('movieDbApiKey');
}

final environmentProvider = Provider<Environment>((ref) {
  return Environment();
});
