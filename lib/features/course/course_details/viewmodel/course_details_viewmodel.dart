import 'package:flutter_riverpod/flutter_riverpod.dart';

final isExpandedProvider = StateProvider.autoDispose<bool>((ref) => false);
