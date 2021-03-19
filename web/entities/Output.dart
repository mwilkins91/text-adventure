import 'dart:html';
import '../Exceptions//Element_Query.dart';

class Output {
  final String _displayID;
  Element _display;

  Output(this._displayID) {
    _display = querySelector(_displayID);
    _verifyHtmlIsCorrect();
  }

  void _verifyHtmlIsCorrect() {
    if (_display == null) {
      throw Element_Not_Found_Exception(_displayID);
    }
  }

  void write(String text) {
    _display.appendHtml('<p>$text</p>');
  }
}
