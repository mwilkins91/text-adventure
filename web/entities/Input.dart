import 'dart:html';

class Element_Not_Found_Exception extends Error {
  String id;
  Element_Not_Found_Exception(this.id);

  @override
  String toString() {
    if (id != null) {
      return 'Element $id not found!';
    }
    return 'No id found!';
  }
}

class Wrong_Element_Exception extends Error {
  String id;
  String expected;
  String actual;
  Wrong_Element_Exception(this.id, this.expected, this.actual);

  @override
  String toString() {
    return 'Element $id not of type $expected, found $actual instead!';
  }
}

var REG_EXP_VALID_CHAR = RegExp(r'([a-zA-Z]|\s|[.,!?\\-])');

class Input {
  String inputID;
  String displayID;
  Element display;
  SpanElement prompt;
  SpanElement caret;

  Input(this.inputID, this.displayID) {
    display = querySelector(displayID);

    if (display == null) {
      throw Element_Not_Found_Exception(displayID);
    }

    display.appendHtml('''
      <span id="terminal-prompt">&#65310;</span><span id="terminal-caret"></span>
    ''');

    prompt = display.querySelector('#terminal-prompt');
    caret = display.querySelector('#terminal-caret');

    display.addEventListener(
        'focus', (event) => display.classes.add('focused'));

    display.addEventListener(
        'blur', (event) => display.classes.remove('focused'));

    display.addEventListener('keydown', (event) {
      var e = event as KeyboardEvent;

      var isBackspace = e.keyCode == 8;
      var isPreviousNodeTextNode = caret.previousNode.nodeType == 3;
      var isNextNodeTextNode = caret.nextNode?.nodeType == 3;
      var canBeBackspaced = isBackspace && isPreviousNodeTextNode;
      if (canBeBackspaced) {
        caret.previousNode.remove();
        return;
      }

      var isMaxLength = display.text.length >= 300;
      if (isMaxLength) return;

      var isValidCharacter =
          REG_EXP_VALID_CHAR.hasMatch(String.fromCharCode(e.keyCode)) ||
              REG_EXP_VALID_CHAR.hasMatch(e.key);

      if (isValidCharacter && e.key.length == 1) {
        display.insertBefore(Text(e.key), caret);
        return;
      }

      var isLeftArrow = e.keyCode == 37;
      var isRightArrow = e.keyCode == 39;

      var previousCharacter = caret.previousNode?.clone(false);
      var selectedCharacter = caret.firstChild?.clone(false);
      var nextCharacter = caret.nextNode?.clone(false);
      if (isLeftArrow && isPreviousNodeTextNode) {
        caret.previousNode?.remove();
        caret.firstChild?.remove();
        if (selectedCharacter != null) {
          display.insertBefore(selectedCharacter, caret.nextNode);
        }
        caret.append(previousCharacter);
        return;
      }

      if (isRightArrow && isNextNodeTextNode) {
        caret.nextNode?.remove();
        caret.firstChild?.remove();
        if (selectedCharacter != null) {
          display.insertBefore(selectedCharacter, caret);
        }
        caret.append(nextCharacter);
        return;
      }
    });
  }

  String read() {
    return display.text;
  }
}
