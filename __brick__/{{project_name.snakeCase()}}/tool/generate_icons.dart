// ignore_for_file: avoid_print

import 'dart:io';

void main(List<String> args) async {
  print('Running flutter_launcher_icons...');

  // Run the flutter_launcher_icons package
  final process = await Process.start(
    'dart',
    ['run', 'flutter_launcher_icons', ...args],
    runInShell: true,
    mode: ProcessStartMode.inheritStdio,
  );

  final exitCode = await process.exitCode;

  if (exitCode != 0) {
    print('Error running flutter_launcher_icons');
    exit(exitCode);
  }

  print('Restoring AndroidManifest.xml configuration...');

  final manifestFile = File('android/app/src/main/AndroidManifest.xml');
  if (!await manifestFile.exists()) {
    print('Error: AndroidManifest.xml not found at ${manifestFile.path}');
    exit(1);
  }

  String content = await manifestFile.readAsString();

  // The pattern to match the icon overwrite
  // It usually overwrites android:icon="@mipmap/launcher_icon"
  // We want to restore it to android:icon="${icon}"

  final iconPattern = RegExp(r'android:icon="@mipmap/[^"]+"');
  if (content.contains(iconPattern)) {
    final newContent = content.replaceAll(iconPattern, 'android:icon="\${icon}"');
    await manifestFile.writeAsString(newContent);
    print('Successfully restored android:icon="\${icon}" in AndroidManifest.xml');
  } else {
    // Check if it's already correct or something else is wrong
    if (content.contains('android:icon="\${icon}"')) {
      print('AndroidManifest.xml already contains android:icon="\${icon}". No changes needed.');
    } else {
      print('Warning: Could not find android:icon attribute to restore in AndroidManifest.xml');
    }
  }
}
