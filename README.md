# In Check

A flutter application that simulates a real-life finding game.

This game is developed by Polina Govorkova for Firebase ML team as Starter project.

### Purpose of the project:
- Set up dev environment required for further work
- Get familiar with dart/flutter development/testing
- Get familiar with firebase console and apis, specifically firebase ml

### Purpose of the game:
- Keep kids busy while parents can code without distractions :wink:

## Game:
##### Idea:
Given a list of household objects, find them within time limits and get points.

##### Specific rules:
- Each game consists of 10 questions.
- To score a point for each question, you need to take a picture of an object, specified by the question. Objects are assigned randomly from a given list of common objects.
- If your picture has that object, and you do it in a timely manner (before timer expires), you get a point.
The timer is currently set to 30 seconds. If timer expires, or your image is unrecognizable/doesn't have the object, you are automatically moved to the next question, and no points are awarded.
- You can go back and forth between camera view and the task, but the timer runs even when the camera is open.

NOTE: You can change game length and time, allocated for searching in the constants.dart file.

#### Game screenshots (for a 5 question game with 20s timer):
| <img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/main_page.jpg" width="162" height="342" />
| <img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/q1.jpg" width="162" height="342" />
| <img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/q2.jpg" width="162" height="342" />
| <img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/q3.jpg" width="162" height="342" />
| <img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/final_score.jpg" width="162" height="342" /> |

### Access:
The game will need
- internet to update global score, otherwise connection is not required.
- camera to take pictures of different objects (permission required).

### Technology:
Currently works on Android only.
The game uses
- ImagePicker to get image from the camera
- Cloud Firestore to keep data online
- Firebase ML Vision plugin to access accuracy of the images

<img src="https://github.com/PolinaGo/InCheck/blob/master/images/files_for_readme/game_flow.png"/>

## Testing:
- Main      - :warning: (partial, widget)
- Game      - :x: (none)
- GameBrain - :white_check_mark: (full, unit)

## TODOs:
- Expanded list of objects to find
- Full testing
- Add IOS support


#### Graphics credits:
- Free logo created at LogoMakr.com
- Object icons used from Pixel Perfect and Freepik at flaticon.com
- Diagram created using https://app.diagrams.net/
