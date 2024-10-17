
// __brick__/repository/{{name.snakeCase()}}_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part '{{name.snakeCase()}}_repo.g.dart';

@riverpod
{{name.pascalCase()}}Repo {{name.camelCase()}}Repo({{name.pascalCase()}}RepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create {{name.pascalCase()}}Repo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return {{name.pascalCase()}}Repo(dioService);
}

class {{name.pascalCase()}}Repo {
final DioService _dioService;

{{name.pascalCase()}}Repo(this._dioService);
}