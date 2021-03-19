import 'dart:html';
import 'entities/Input.dart';
import 'entities/Output.dart';

void main() {
  var input = Input('#input-display');
  var output = Output('#output-display');

  input.addSubmitHandler((text) => print(text));
  input.addSubmitHandler((text) => output.write(text));
  input.addSubmitHandler((text) => input.clear());
}
