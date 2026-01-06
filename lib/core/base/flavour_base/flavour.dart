abstract class Flavour {
  final String baseUrl;
  Flavour({required this.baseUrl});
}

class FlavourImpl extends Flavour {
  FlavourImpl({required super.baseUrl});
}
