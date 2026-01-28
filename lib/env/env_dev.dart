import 'package:envied/envied.dart';

part 'env_dev.g.dart';

@Envied(path: 'assets/env/.env.dev', obfuscate: true)
abstract class EnvDev {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _EnvDev.baseUrl;
}
