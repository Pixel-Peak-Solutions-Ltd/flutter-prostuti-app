import 'flutter_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.production,
    name: "Production",
    baseUrl: "https://resilient-heart-staging.up.railway.app/api/v1",
    socketBaseUrl: 'https://resilient-heart-staging.up.railway.app',
  );

  runMain();
}
