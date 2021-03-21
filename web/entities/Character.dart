import '../utils.dart';

var INVALID_ID_CHARS_PATTERN = RegExp(r'\s|=');

class Character {
  String id;
  String firstName;
  String lastName;
  String portraitPath;

  Character({this.firstName, this.lastName, this.portraitPath}) {
    id = '$fullName-${createIDofLength(fullName.length)}'
        .replaceAll(INVALID_ID_CHARS_PATTERN, '_');
  }

  bool isCharactersID(String comparisonID) {
    return id == comparisonID;
  }

  bool isSameCharacter(Character char) {
    return char.id == id;
  }

  String get fullName {
    return firstName + ' ' + lastName;
  }

  String get textBoxID {
    return id + '-speech-box';
  }
}
