import 'package:envied/envied.dart';

part 'env_prod.g.dart';

@Envied(path: 'assets/env/.env.prod', obfuscate: true)
abstract class EnvProd {
  @EnviedField(varName: 'BASE_URL')
  static String baseUrl = _EnvProd.baseUrl;
}
