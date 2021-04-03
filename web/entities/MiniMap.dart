import 'dart:convert';
import 'dart:html';
import '../Exceptions/Element_Query.dart';
import '../Exceptions/Invalid_Move.dart';
import '../Exceptions/Missing_Map.dart';
import '../maps/maps.dart';
import '../utils.dart';

enum Direction { up, left, down, right }

class MiniMap {
  final String _displayID;
  String _mapFileName;
  List _mapJSON;
  Element _display;
  SpanElement _prompt;
  SpanElement _caret;
  bool hasRendered = false;
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

  Element getPlayer() {
    return querySelector('[data-is-players-location="true"]');
  }

  Element getMapLocation(int x, int y) {
    return querySelector('[data-x="$x"][data-y="$y"]');
  }

  void movePlayer(Direction direction) {
    var player = getPlayer();
    var x = int.parse(player.dataset['x']);
    var y = int.parse(player.dataset['y']);

    var newX = x;
    var newY = y;
    if (direction == Direction.down) {
      newY = y + 1;
    }
    if (direction == Direction.left) {
      newX = x - 1;
    }
    if (direction == Direction.right) {
      newX = x + 1;
    }
    if (direction == Direction.up) {
      newY = y - 1;
    }

    var newLoc = getMapLocation(newX, newY);
    if (newLoc.text == '|' || newLoc.text == '-') {
      throw InvalidMove('$newX, $newY');
    }
    player.dataset.update('isPlayersLocation', (value) => 'false');
    newLoc.dataset.update('isPlayersLocation', (value) => 'true');
  }

  void render() {
    if (hasRendered) {
      return;
    }
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
            return '<span class="grid-item" data-is-players-location="$isStart" data-x="$x" data-y="$y" data-is-start="$isStart" >$char</span>';
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
    // Forumla:
    // xch == move X times the with of a character (-1px per border you have to pass) + 50% to center horizontally
    // xch == move Y times the height of a character (-1px per border you have to pass) + 50% to center Vert
    minimapEl.style
        .setProperty('left', 'calc((-${x}ch - ${int.parse(x) * 2}px) + 50%)');
    minimapEl.style
        .setProperty('top', 'calc((-${y}em - ${int.parse(y) * 2}px) + 50%)');

    hasRendered = true;
    return;
  }
}
