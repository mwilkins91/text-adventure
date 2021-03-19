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
  final String _inputID;
  final String _displayID;
  Element _display;
  SpanElement _prompt;
  SpanElement _caret;
  final List<Function> _handlers = [];

  Input(this._inputID, this._displayID) {
    _display = querySelector(_displayID);

    if (_display == null) {
      throw Element_Not_Found_Exception(_displayID);
    }

    _display.appendHtml('''
      <span id="terminal-prompt">&#65310;</span><span id="terminal-caret"></span>
    ''');

    _prompt = _display.querySelector('#terminal-prompt');
    _caret = _display.querySelector('#terminal-caret');

    _display.addEventListener(
        'focus', (event) => _display.classes.add('focused'));

    _display.addEventListener(
        'blur', (event) => _display.classes.remove('focused'));

    _display.addEventListener('keydown', (event) {
      var e = event as KeyboardEvent;

      var isBackspace = e.keyCode == 8;
      var isPreviousNodeTextNode = _caret.previousNode.nodeType == 3;
      var isNextNodeTextNode = _caret.nextNode?.nodeType == 3;
      var canBeBackspaced = isBackspace && isPreviousNodeTextNode;
      if (canBeBackspaced) {
        _caret.previousNode.remove();
        return;
      }

      var isMaxLength = _display.text.length >= 300;
      if (isMaxLength) return;

      var isValidCharacter =
          REG_EXP_VALID_CHAR.hasMatch(String.fromCharCode(e.keyCode)) ||
              REG_EXP_VALID_CHAR.hasMatch(e.key);

      if (isValidCharacter && e.key.length == 1) {
        _display.insertBefore(Text(e.key), _caret);
        return;
      }

      var isLeftArrow = e.keyCode == 37;
      var isRightArrow = e.keyCode == 39;

      var previousCharacter = _caret.previousNode?.clone(false);
      var selectedCharacter = _caret.firstChild?.clone(false);
      var nextCharacter = _caret.nextNode?.clone(false);
      if (isLeftArrow && isPreviousNodeTextNode) {
        _caret.previousNode?.remove();
        _caret.firstChild?.remove();
        if (selectedCharacter != null) {
          _display.insertBefore(selectedCharacter, _caret.nextNode);
        }
        _caret.append(previousCharacter);
        return;
      }

      if (isRightArrow && isNextNodeTextNode) {
        _caret.nextNode?.remove();
        _caret.firstChild?.remove();
        if (selectedCharacter != null) {
          _display.insertBefore(selectedCharacter, _caret);
        }
        _caret.append(nextCharacter);
        return;
      }

      var isEnter = e.keyCode == 13;
      if (isEnter) {
        _handleSubmit();
      }
    });
  }

  void _handleSubmit() {
    _handlers.forEach((func) => func(read()));
  }

  void addSubmitHandler(Function handler) {
    _handlers.add(handler);
  }

  String read() {
    return _display.text;
  }
}
