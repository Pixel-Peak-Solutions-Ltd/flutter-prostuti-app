import 'flutter_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.production,
    name: "Production",
    baseUrl: "https://prostuti-app-backend-production.up.railway.app/api/v1",
  );

  runMain();
}
