
// __brick__/repository/{{feature_name.snakeCase()}}_repo.dart
import 'package:prostuti/core/services/dio_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:prostuti/common/view_model/auth_notifier.dart';

part '{{feature_name.snakeCase()}}_repo.g.dart';

@riverpod
{{feature_name.pascalCase()}}Repo {{feature_name.camelCase()}}Repo({{feature_name.pascalCase()}}RepoRef ref) {
final accessToken = ref.watch(authNotifierProvider);

if (accessToken == null) {
throw Exception('Access token is null. Cannot create {{feature_name.pascalCase()}}Repo.');
}
final dioService = ref.watch(dioServiceProvider(accessToken: accessToken));
return {{feature_name.pascalCase()}}Repo(dioService);
}

class {{feature_name.pascalCase()}}Repo {
final DioService _dioService;

{{feature_name.pascalCase()}}Repo(this._dioService);
}