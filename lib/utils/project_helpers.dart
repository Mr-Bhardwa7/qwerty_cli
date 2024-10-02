import 'package:qwerty_cli/constants.dart';
import 'package:qwerty_cli/utils/common_helpers.dart';

void createProject(String projectName, String selectedStateManagement) {
  if (!allowedStateManagementOptions.contains(selectedStateManagement)) {
    printMessage(
      'Invalid state management option: "$selectedStateManagement"',
      color: red,
    );
    printMessage(
        'Valid options are: ${allowedStateManagementOptions.join(', ')}',
        color: yellow);
    return;
  }

  printMessage('Creating Flutter app.', color: yellow, isBold: true);
  // Create Flutter app
  runCommand('flutter', ['create', projectName]);

  // Copy boilerplate based on state management
  switch (selectedStateManagement.toLowerCase()) {
    case 'bloc':
      _addBlocDependencies(projectName);
      // copyBoilerplateFromGit(projectName, stateManagement.toLowerCase());
      break;
    case 'getx':
      _addGetxDependencies(projectName);
      // copyBoilerplateFromGit(projectName, stateManagement.toLowerCase());
      break;
    default:
      printMessage('Unknown state management solution.', color: red);
  }

  printMessage(
    'Flutter app "$projectName" created successfully!',
    color: green,
    isBold: true,
  );
}

void _addBlocDependencies(String projectName) {
  addDependency(projectName, 'flutter_bloc', '^8.0.0');
}

void _addGetxDependencies(String projectName) {
  printMessage('Dependencies: Yet to be defined', color: yellow);
}
