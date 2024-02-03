class LocaleModel {
  final String _languageCode;
  final String _name;
  LocaleModel({
    required languageCode,
    required name,
  })  : _languageCode = languageCode,
        _name = name;

  String get name => _name;
  String get languageCode => _languageCode;
}
