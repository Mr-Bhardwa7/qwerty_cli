const unknownCommand = "Unknown command. Use  --help to see available options.";
const suggestionMessage =
    "Usage: qwerty-cli -c <app_name> -s <state_management>";
List<String> allowedStateManagementOptions = ['bloc', 'getX'];
const repoUrl = 'https://github.com/Mr-Bhardwa7/flutter_boiler_plate_with_bloc';

//commands
const help = "help";
const create = "create-project";
const stateManagement = "state-management";

//commands message
const helpMessage = "Show help";
const createMessage = "Create a new Flutter project";
String stateManagementMessage =
    "Choose state management option: [${allowedStateManagementOptions.join(', ')}]";

//print message colors
const String reset = '\x1B[0m';
const String green = '\x1B[32m';
const String red = '\x1B[31m';
const String yellow = '\x1B[33m';
const String bold = '\x1B[1m';
