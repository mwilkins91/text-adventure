import 'dart:html';
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

  input.addSubmitHandler((text) => print(text));
  input.addSubmitHandler((text) => output.characterSpeaks(bob, text.trim()));
  input.addSubmitHandler((text) => input.clear());
  map.render();
}
