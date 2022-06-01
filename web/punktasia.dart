library punktasia;

import 'dart:async';
import 'gamesystem.dart';
import 'dart:html';

GameSystem game = new GameSystem();
const oneSecond = const Duration(seconds: 1);

void main() {
  game.gainFunc(null);
  Timer.periodic(oneSecond, game.gainFunc);
}
