// You have generated a new plugin project without specifying the `--platforms`
// flag. A plugin project with no platform support was generated. To add a
// platform, run `flutter create -t plugin --platforms <platforms> .` under the
// same directory. You can also find a detailed instruction on how to add
// platforms in the `pubspec.yaml` at
// https://flutter.dev/docs/development/packages-and-plugins/developing-packages#plugin-platforms.

import 'package:args/args.dart';

class QwertyCli {
  void main(List<String> arguments) {
    final parser = ArgParser()
      ..addFlag(
        'help',
        abbr: 'h',
        negatable: false,
        help: 'Show help',
      )
      ..addOption(
        'create-project',
        abbr: 'c',
        help: 'Create a new Flutter project',
      )
      ..addOption(
        'state-management',
        abbr: 's',
        help: 'Choose state management option',
        allowed: ['bloc', 'getX'],
        mandatory: true,
      );

    ArgResults argResults = parser.parse(arguments);

    final commandMap = {
      // ignore: avoid_print
      'help': () => print(parser.usage),
      'create-project': () {
        var projectName =
            argResults['create-project'] ?? 'qwerty_flutter_project';
        createProject(projectName);
      }
    };

    if (argResults['help'] as bool) {
      commandMap['help']!();
    } else if (argResults.wasParsed('create-project')) {
      commandMap['create-project']!();
    } else {
      // ignore: avoid_print
      print('Unknown command. Use  --help to see available options.');
    }
  }

  void createProject(String projectName) {
    // ignore: avoid_print
    print('Creating Flutter project: $projectName');
  }
}
