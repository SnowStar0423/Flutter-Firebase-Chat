class LocaleModel {
  final String _code;
  final String _name;
  LocaleModel({
    required code,
    required name,
  })  : _code = code,
        _name = name;

  String get name => _name;
  String get code => _code;
}
