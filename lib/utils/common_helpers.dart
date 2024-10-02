import 'dart:io';

import 'package:qwerty_cli/constants.dart';

void copyBoilerplateFromGit(String projectName, String stateManagement) {
  String branch = 'master';

  // Clone the repository into a temporary directory
  final tempDir = Directory.systemTemp.createTempSync('boilerplate_');
  printMessage(
      'Cloning $stateManagement boilerplate from $repoUrl (branch: $branch)...');

  // Clone the specific branch of the Git repository
  runCommand('git', ['clone', '-b', branch, repoUrl, tempDir.path]);

  // Copy the contents of the cloned repo to the lib folder of the new Flutter app
  final libSource = Directory('${tempDir.path}/lib');
  final libDestination = Directory('$projectName/lib');

  if (libSource.existsSync()) {
    // Create the destination lib directory if it doesn't exist
    if (!libDestination.existsSync()) {
      libDestination.createSync(recursive: true);
    }

    // Copy all files and directories from the source lib folder to the destination
    for (var entity in libSource.listSync(recursive: false)) {
      if (entity is File) {
        // Copy files directly to the destination
        entity
            .copySync('${libDestination.path}/${entity.uri.pathSegments.last}');
      } else if (entity is Directory) {
        // Create the new directory in the destination
        final newDir =
            Directory('${libDestination.path}/${entity.uri.pathSegments.last}');
        newDir.createSync(recursive: true); // Create the directory

        // Copy contents of the directory
        for (var subEntity in entity.listSync()) {
          if (subEntity is File) {
            // Copy files
            subEntity
                .copySync('${newDir.path}/${subEntity.uri.pathSegments.last}');
          } else if (subEntity is Directory) {
            // Recursively copy sub-directories
            _copyDirectory(subEntity, newDir);
          }
        }
      }
    }
    printMessage(
      'Successfully configured the $stateManagement project to $libDestination',
      color: green,
    );
  } else {
    printMessage(
      'Lib folder does not exist in the cloned repository.',
      color: red,
    );
  }

  // Clean up the temporary directory
  tempDir.deleteSync(recursive: true);

  printMessage(
    'Configuring $stateManagement boilerplate to $projectName/lib.',
    color: yellow,
    isBold: true,
  );
}

void addDependency(String projectName, String packageName, String? version) {
  final pubspecFile = File('$projectName/pubspec.yaml');
  final pubspecContent = pubspecFile.readAsStringSync();

  // Parse the YAML
  var lines = pubspecContent.split('\n');
  int index = lines.indexWhere((line) => line.startsWith('dependencies:')) + 1;

  if (!lines.any((line) => line.trim().startsWith('$packageName:'))) {
    // Add the dependency
    if (version == null) {
      lines.insert(index, '  $packageName:');
    } else {
      lines.insert(index, '  $packageName: $version');
    }

    // Write back the modified content
    pubspecFile.writeAsStringSync(lines.join('\n'));

    // Run flutter pub get to install dependencies
    runCommand('flutter', ['pub', 'get'], workingDirectory: projectName);

    printMessage(
      'Added $packageName dependency to $projectName.',
      color: green,
      isBold: true,
    );
  } else {
    printMessage(
      '$packageName is already listed in $projectName/pubspec.yaml.',
      color: yellow,
    );
  }
}

void _copyDirectory(Directory source, Directory destination) {
  final newDir =
      Directory('${destination.path}/${source.uri.pathSegments.last}');
  newDir.createSync(); // Create the directory

  for (var entity in source.listSync()) {
    if (entity is File) {
      entity.copySync('${newDir.path}/${entity.uri.pathSegments.last}');
    } else if (entity is Directory) {
      _copyDirectory(entity, newDir); // Recursive copy for subdirectories
    }
  }
}

void runCommand(String command, List<String> args, {String? workingDirectory}) {
  var result = Process.runSync(
    command,
    args,
    runInShell: true,
    workingDirectory: workingDirectory,
  );

  if (result.exitCode != 0) {
    printMessage(
      'Error running command: $command ${args.join(' ')}',
      color: red,
    );
    printMessage('Error: ${result.stderr}', color: red);
    exit(result.exitCode);
  } else {
    print('${result.stdout}');
  }
}

bool _isExecutableAvailable(String command) {
  return Process.runSync('where', [command]).exitCode == 0;
}

void checkDependencies() {
  if (!_isExecutableAvailable('flutter')) {
    printMessage(
      'Error: Flutter is not installed or not found in the specified path.',
      color: red,
    );
    printMessage(
        'Please install Flutter from https://flutter.dev/docs/get-started/install');
    exit(1);
  }

  if (!_isExecutableAvailable('git')) {
    printMessage(
      'Error: Git is not installed or not found in your PATH.',
      color: red,
    );
    printMessage('Please install Git from https://git-scm.com/downloads');
    exit(1);
  }
}

void printMessage(String message, {String color = reset, bool isBold = false}) {
  String formattedMessage = message;

  if (isBold) {
    formattedMessage = '$bold$formattedMessage';
  }

  print('$color$formattedMessage$reset');
}
