import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_file_path.g.dart';

@riverpod
class GetFilePath extends _$GetFilePath {
  @override
  String build() {
    return "";
  }

  void setFilePath(filePath) {
    state = filePath;
  }
}
