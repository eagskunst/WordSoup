# Word Search

The Word Search game made with Dart and Flutter.

## Installing

For help getting started with Flutter, view the [online documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

Clone this project, then run `flutter pub get` to get the dependencies and `flutter pub run build_runner build` to generate the code related to JSON parsing.

Connect your device or start your emulator and write on your console `flutter run` or create an APK/IPA with `flutter build android`/`flutter build ios`.

You can run from web from the web-version branch.

## Use cases
This apps use a modified version of this [Multi Select child grid](https://gist.github.com/slightfoot/a002dd1e031f5f012f810c6d5da14a11). You could find this useful when building a big layout that wraps around a Gesture Detector and need to get which widget is below the user is finger. 

Other than that, the word creating algorithm works with a random that generates the word direction (vertical, horizontal, and diagonal), generates the random word and a initial position. The initial position is generated by force-bruiting checking all the possible positions and getting the first one that fits. This method could fail if the word can't be added in that direction. If that is the case, there's a method that *generatesWithFallback*, which uses all the possible words in the first generated direction. If no word can be added, the board is restarted and the process goes all over again until the board completes and the UI changes.

The algorithm is supposed to run as async code,and while it's running, show a progress bar. The UI changes almost immediately with the new board, it's not the desired behavior, but the code runs too fast so ¯\\_(ツ)_/¯

## Contributing

This is a college project for the time being. I probably won't accept PR but I will look into issues.