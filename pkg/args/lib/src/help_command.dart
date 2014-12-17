// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library args.help_command;

import '../command_runner.dart';

/// The built-in help command that's added to every [CommandRunner].
///
/// This command displays help information for the various subcommands.
class HelpCommand extends Command {
  final name = "help";
  String get description =>
      "Display help information for ${runner.executableName}.";
  String get usage => "${runner.executableName} help [command]";

  void run() {
    // Show the default help if no command was specified.
    if (options.rest.isEmpty) {
      runner.printUsage();
      return;
    }

    // Walk the command tree to show help for the selected command or
    // subcommand.
    var commands = runner.commands;
    var command = null;
    var commandString = runner.executableName;

    for (var name in options.rest) {
      if (commands.isEmpty) {
        command.usageException(
            'Command "$commandString" does not expect a subcommand.');
      }

      if (commands[name] == null) {
        if (command == null) {
          runner.usageException('Could not find a command named "$name".');
        }

        command.usageException(
            'Could not find a subcommand named "$name" for "$commandString".');
      }

      command = commands[name];
      commands = command.subcommands;
      commandString += " $name";
    }

    command.printUsage();
  }
}
