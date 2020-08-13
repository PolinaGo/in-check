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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'game.dart';
import 'constants.dart' as Constants;


int maxScore = 0;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'In Check',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Poppins',
      ),
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => MyHomePage(),
        '/$Game': (BuildContext context) => Game(),
      }
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  final collectionReference = Firestore.instance.collection("maxScore");

  void updateGlobalScore() {
    collectionReference.document("global").get().then((value) => {if (maxScore > value.data['score']) { collectionReference
        .document("global")
        .updateData({
        'score': maxScore})
    } });
  }

  @override
  Widget build(BuildContext context) {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    updateGlobalScore();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 10,
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset('images/main_logo.png'),
                    ),
                  ),
                  Expanded(
                      flex: 2,
                      child: Score(Constants.LOCAL_BEST, maxScore)
                  ),
                  Expanded(
                    flex:2,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: collectionReference
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError)
                          return new Text(Constants.ERROR + '${snapshot.error}');
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return new Text(Constants.LOADING_GLOBAL);
                          default:
                            return Score(Constants.GLOBAL_BEST, snapshot.data.documents.elementAt(0).data['score']);
                        }
                      },
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: FractionalOffset.topCenter,
                      child: FlatButton(
                        shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                        textColor: Colors.white,
                        color: Colors.green.shade700,
                        child: Text(
                          Constants.GAME_START_MESSAGE,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                        onPressed: () => Navigator.pushReplacementNamed(context, '/$Game'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Text(
                    Constants.CREDITS,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade300,
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Score( String info, int score ) {
    return Column(
        children: <Widget>[
          Text(
            info,
          ),
          Text(
            "$score",
            style: Theme.of(context).textTheme.headline4,
          ),
        ],
    );
  }

}