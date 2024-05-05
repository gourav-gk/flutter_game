import 'dart:io';

void main() {
  print("hello world");
  stdout.write("hello world");
  var name = stdin.readLineSync();
  stdout.write(name);
}
