import 'flutter_config.dart';
import 'main.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.development,
    name: "Development",
    baseUrl: "https://resilient-heart-dev.up.railway.app/api/v1",
  );

  runMain();
}
