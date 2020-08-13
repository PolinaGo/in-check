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

import 'dart:async';
import 'dart:io';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'gameBrain.dart';
import 'main.dart';
import 'constants.dart' as Constants;

class Game extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GameState();
}

class _GameState extends State<Game> {
  int score = 0;
  GameBrain gameBrain = GameBrain();

  String prevTrueLabel;
  File prevImageFile;

  File _imageFile;
  bool _correctness;

  final ImageLabeler _imageLabeler = FirebaseVision.instance.imageLabeler();

  Timer timer;
  int timeLeft;

  void checkAnswer(List<ImageLabel> labels) {
    bool correctness;
    correctness = false;
    for (ImageLabel label in labels) {
      if (label.text == gameBrain.getQuestion()) {
        correctness = true;
      }
    }
    setState(() {
      if (correctness) score++;
      _correctness = correctness;
    });
  }

  void evaluateQuestionAndProceed() async {
    final File imageFile =
    await ImagePicker.pickImage(source: ImageSource.camera);

    if (imageFile != null) {
      await processImage(imageFile);
      timer.cancel();
      proceedToNextQuestion();
    }
  }

  Future <void> processImage(File imageFile) async {

    final FirebaseVisionImage visionImage =
      FirebaseVisionImage.fromFile(imageFile);

    List<ImageLabel> labels;
    labels = await _imageLabeler.processImage(visionImage);

    checkAnswer(labels);
    setState(() {
      _imageFile = imageFile;
    });
  }

  void proceedToNextQuestion() {
    prevTrueLabel = gameBrain.getQuestion();
    prevImageFile = _imageFile;
    gameBrain.nextQuestion();
    setTimer();
    setState(() {});
  }

  void setTimer() {
    timer = new Timer(Duration(seconds: 1), timerTick);
    timeLeft = Constants.TIMER_TIME;
  }

  void timerTick() {
    if (timeLeft == 0) {
      _imageFile = null;
      _correctness = false;
      proceedToNextQuestion();
    }
    else {
      timer = new Timer(Duration(seconds: 1), timerTick);
      setState(() {
        timeLeft = timeLeft - 1;
      });
    }
  }

  void gameOver() {
    if (maxScore < score) {
      maxScore = score;
    }
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    if (timer == null) setTimer();

    String trueLabel = gameBrain.getQuestion();
    int gameLength = Constants.QUIZ_LENGTH;
    int questionNumber = gameBrain.getQuestionNumber()+1;

    if (gameBrain.isFinished()) timer.cancel();
    bool finished = gameBrain.isFinished();
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: (questionNumber == 1) ? 4 : 10,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: (questionNumber == 1) ?
                  Container()
                    :
                  Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 2.0, color: _correctness == true ? Colors.green : Colors.red),
                        borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Column(
                      children: <Widget> [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Image.asset('images/questions/$prevTrueLabel.png'),
                                  ),
                                  Expanded(
                                    child: prevImageFile == null ?
                                    Text(
                                      Constants.TIMER_EXPIRED_MESSAGE,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 20,
                                      ),
                                    )
                                        :
                                    Image.file(prevImageFile),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                (_correctness == null) ?
                            ""
                                :
                            (_correctness) ?
                               Constants.SUCCESS_MESSAGE + "$prevTrueLabel!"
                                :
                               Constants.FAILURE_MESSAGE + "$prevTrueLabel!",
                            style: TextStyle(fontSize: 20),),
                          )),
                      ]
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 14,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: finished ?
                  Center(
                      child: Text(
                           Constants.FINAL_SCORE_MESSAGE + "$score/$gameLength",
                          style: TextStyle(
                            fontSize: 25.0,
                          ),
                      ),
                  )
                    :
                  Column(
                      children: <Widget> [
                        Text(Constants.CURRENT_SCORE_MESSAGE + "$score/$gameLength"),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                              Constants.QUESTION_ANNOUNCEMENT_MESSAGE + "$questionNumber!",
                              style: TextStyle(
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Image.asset('images/questions/$trueLabel.png'),
                        ),
                      ]
                  ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(15.0),
                child:
                FlatButton(
                  shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  textColor: Colors.white,
                  color: finished ? Colors.red.shade700 : Colors.green.shade700,
                  child: Text(
                    finished ? Constants.EXIT_MESSAGE : Constants.NEXT_QUESTION_MESSAGE + '$trueLabel!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                  onPressed: finished ? gameOver : evaluateQuestionAndProceed,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: finished ?
                Container()
                  :
                Center(
                  child: Text(
                    Constants.TIME_ANNOUNCEMENT_MESSAGE + "$timeLeft",
                    style: Theme.of(context).textTheme.headline4,
                  ),
              ),
            ),
            Expanded(
              flex: (questionNumber == 1) ? 6 : 0,
              child: Container(),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _imageLabeler.close();
    super.dispose();
  }
}