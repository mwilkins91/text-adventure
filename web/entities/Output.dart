import 'dart:html';
import '../Exceptions//Element_Query.dart';
import 'Character.dart';
import 'dart:math';
import 'dart:convert';

class RawHtml implements NodeTreeSanitizer {
  @override
  void sanitizeTree(Node node) {}
}

class Output {
  final String _displayID;
  Element _display;

  Output(this._displayID) {
    _display = querySelector(_displayID);
    _verifyHtmlIsCorrect();
    _display.addEventListener('animationend', (event) {
      var e = event as AnimationEvent;
      if (e.animationName == 'typing') {
        (e.target as Element).classes.add('typewriter-done');
      }
    });
  }

  void _verifyHtmlIsCorrect() {
    if (_display == null) {
      throw Element_Not_Found_Exception(_displayID);
    }
  }

  void write(String text) {
    _display.appendHtml('<p>$text</p>');
  }

  void characterSpeaks(Character char, String speech) {
    var existingBox = querySelector('#${char.textBoxID}');
    var speechNode = '''
          <p
            class="typewriter" style="animation: typing 0.5s steps(${speech.length}, end), blink-caret 0.75s step-end infinite;">
              ${speech.trim()}
          </p>
    ''';

    if (existingBox != null) {
      existingBox
          .querySelector('.character-speech-text')
          .appendHtml(speechNode, treeSanitizer: RawHtml());
    } else {
      _display.appendHtml('''
      <div id="${char.textBoxID}" class="character-speech-box">
        <h3 class="character-speech-box-name">${char.fullName}</h3>
        <div class="character-speech-box-content" >
          <img src="${char.portraitPath}" alt="${char.fullName}">
          <div class="character-speech-text">
            $speechNode
          </div>
        </div>
      </div>
    ''', treeSanitizer: RawHtml());
    }
  }
}
