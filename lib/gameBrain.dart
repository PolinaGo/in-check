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

import 'dart:math';
import 'constants.dart' as Constants;


class GameBrain {
  int _questionNumber;
  var _randomizer;
  List<String> questionBank;

  GameBrain() {
    _randomizer = new Random();
    _questionNumber = 0;
    questionBank = ['Glasses', 'Chair', 'Desk', 'Pillow', 'Smile', 'Toy', 'Bag', 'Curtain', 'Hand', 'Shoe', 'Flower', 'Plant', 'Cat', 'Sunglasses', 'Foot'];
    questionBank.shuffle(_randomizer);
  }

  void nextQuestion() {
      _questionNumber++;
  }
  int getQuestionNumber() {
    return _questionNumber;
  }
  String getQuestion() {
    return isFinished() ? "" : questionBank[_questionNumber];
  }

  bool isFinished() {
    if (_questionNumber >= Constants.QUIZ_LENGTH) return true;
    return false;
  }
}