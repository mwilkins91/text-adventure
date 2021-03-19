import 'dart:html';
import 'entities/Input.dart';

void main() {
  var input = Input('#input', '#input-display');
  input.addSubmitHandler((text) => print(text));
}
