import 'dart:html';
import 'Exceptions/Invalid_Move.dart';
import 'entities/Input.dart';
import 'entities/Output.dart';
import 'entities/Character.dart';
import 'entities/MiniMap.dart';

void main() {
  var input = Input('#input-display');
  var output = Output('#output-display');
  var bob = Character(
      firstName: 'Bob',
      lastName: 'Willson',
      portraitPath: '/assets/bob-char-portrait.png');
  var map = MiniMap('#map', 'level-1');

  void handleMovement(String text) {
    try {
      if (text == 'left') {
        return map.movePlayer(Direction.left);
      }
      if (text == 'up') {
        return map.movePlayer(Direction.up);
      }
      if (text == 'right') {
        return map.movePlayer(Direction.right);
      }
      if (text == 'down') {
        return map.movePlayer(Direction.down);
      }
    } catch (err) {
      if (err is InvalidMove) {
        return output.write('Invalid move!');
      }
    }
    output.characterSpeaks(bob, text.trim());
  }

  input.addSubmitHandler(handleMovement);
  input.addSubmitHandler((text) => input.clear());
  map.render();
}
