import 'flutter_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.staging,
    name: "Staging",
    baseUrl: "https://resilient-heart-staging.up.railway.app/api/v1",
  );

  runMain();
}
