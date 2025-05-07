enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String baseUrl;
  final String socketBaseUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String name,
    required String baseUrl,
    required String socketBaseUrl,
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      baseUrl: baseUrl,
      socketBaseUrl: socketBaseUrl,
    );
    return _instance!;
  }

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.baseUrl,
    required this.socketBaseUrl,
  });

  static FlavorConfig get instance {
    return _instance!;
  }

  static bool isProduction() => _instance!.flavor == Flavor.production;

  static bool isStaging() => _instance!.flavor == Flavor.staging;

  static bool isDevelopment() => _instance!.flavor == Flavor.development;
}
