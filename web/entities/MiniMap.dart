import 'dart:convert';
import 'dart:html';
import '../Exceptions/Element_Query.dart';
import '../Exceptions/Missing_Map.dart';
import '../maps/maps.dart';
import '../utils.dart';

class MiniMap {
  final String _displayID;
  String _mapFileName;
  List _mapJSON;
  Element _display;
  SpanElement _prompt;
  SpanElement _caret;
  final List<Function> _handlers = [];

  MiniMap(this._displayID, this._mapFileName) {
    _display = querySelector(_displayID);
    _mapJSON = ALL_MAPS[_mapFileName];
    if (_mapJSON == null) {
      throw Missing_Maps(_mapFileName);
    }
    _verifyHtmlIsCorrect();
  }

  void _verifyHtmlIsCorrect() {
    if (_display == null) {
      throw Element_Not_Found_Exception(_displayID);
    }
  }

  Element getStartPosition() {
    return querySelector('[data-is-start="true"]');
  }

  void render() {
    var griddedMap = _mapJSON
        .asMap()
        .entries
        .map((entry) {
          var y = entry.key;
          String row = entry.value;
          return row.split('').asMap().entries.map((e) {
            var x = e.key;
            var char = e.value;
            var isStart = char.toLowerCase() == 's';
            return '<span class="grid-item" data-x="$x" data-y="$y" data-is-start="$isStart" >$char</span>';
          }).join('');
        })
        .join('\n')
        .replaceAll('.', ' ');

    _display.appendHtml('<pre id="rendered-mini-map">$griddedMap</pre>',
        treeSanitizer: RawHtml());
    var startEle = getStartPosition();
    var minimapEl = querySelector('#rendered-mini-map');
    var x = startEle.dataset['x'];
    var y = startEle.dataset['y'];

    minimapEl.style.setProperty('position', 'absolute');
    minimapEl.style.setProperty('left', 'calc(-${x}ch + 50%)');
    minimapEl.style.setProperty('top', 'calc(-${y}em + 50%)');
    return;
  }
}
