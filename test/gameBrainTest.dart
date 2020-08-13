// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter_test/flutter_test.dart';
import 'package:incheck/gameBrain.dart';
import 'package:incheck/constants.dart' as Constants;

void main() {
  test('GameBrain initialized', () {
    final GameBrain gameBrain = GameBrain();
    assert(gameBrain != null);
    assert(gameBrain.questionBank != null);
  });
  test('GameBrain increments questions correctly', () {
    final GameBrain gameBrain = GameBrain();
    assert(gameBrain.getQuestionNumber() == 0);
    gameBrain.nextQuestion();
    assert(gameBrain.getQuestionNumber() == 1);
  });
  test('GameBrain reads questions correctly', () {
    final GameBrain gameBrain = GameBrain();
    gameBrain.nextQuestion();
    gameBrain.nextQuestion();
    gameBrain.nextQuestion();
    assert(gameBrain.getQuestionNumber() == 3);
    assert(gameBrain.getQuestion() ==  gameBrain.questionBank[3]);
  });
  test('GameBrain finishes correctly', () {
    final GameBrain gameBrain = GameBrain();
    for (int i = 0; i < Constants.QUIZ_LENGTH; i++) {
      gameBrain.nextQuestion();
    }
    assert(gameBrain.isFinished());
    assert(gameBrain.getQuestion() == "");
  });
}
