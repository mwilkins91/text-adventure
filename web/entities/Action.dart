RegExp ALL_PUNCTUATION = RegExp(r'[.,\/#!$%\^&\*;:{}=\-_`~()\?]');

class Action {
  String rawText;
  dynamic parsedText;

  Action(String text) {
    rawText = text;
    parsedText = Action.parse(text);
  }

  static bool isNotMeaninglessWord(String word, [others]) {
    var MEANINGLESS_WORDS = ['a', 'and', 'the', 'are', 'is'];

    return !MEANINGLESS_WORDS.contains(word.toLowerCase());
  }

  static dynamic parse(String text) {
    text = text.trim();
    var textTokens = text
        .replaceAll(ALL_PUNCTUATION, '')
        .split(' ')
        .map((e) => e.trim().toLowerCase())
        .where((element) => element != '')
        .where(isNotMeaninglessWord);

    var verbs = [];
    var nouns = [];
  }
}
