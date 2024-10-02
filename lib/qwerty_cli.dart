import 'package:args/args.dart';
import 'package:qwerty_cli/constants.dart';
import 'package:qwerty_cli/utils/common_helpers.dart';
import 'package:qwerty_cli/utils/project_helpers.dart';

class QwertyCli {
  void main(List<String> arguments) {
    final parser = ArgParser()
      ..addFlag(help, abbr: 'h', negatable: false, help: helpMessage)
      ..addOption(create, abbr: 'c', help: createMessage)
      ..addOption(stateManagement, abbr: 's', help: stateManagementMessage);

    ArgResults argResults = parser.parse(arguments);

    final projectName = argResults[create];
    final stateManagementOption = argResults[stateManagement];

    final commandMap = {
      help: () => print(parser.usage),
      create: () => createProject(projectName, stateManagementOption)
    };

    if (argResults[help] as bool) {
      commandMap[help]!();
    } else if (argResults.wasParsed(create)) {
      if (projectName == null || stateManagementOption == null) {
        printMessage(suggestionMessage, color: yellow);
        return;
      }

      checkDependencies();
      commandMap[create]!();
    } else {
      printMessage(unknownCommand, color: red);
    }
  }
}
