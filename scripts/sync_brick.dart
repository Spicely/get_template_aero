import 'dart:io';

const String referenceDir = 'aero_template_reference';
const String brickDir = '__brick__/{{project_name.snakeCase()}}';

const Map<String, String> replacements = {'aero_template_reference': '{{project_name.snakeCase()}}', 'com.example': '{{org_name}}', 'A reference implementation for the Aero template.': '{{description_info}}'};

Future<void> main() async {
  final currentDir = Directory.current;
  final refPath = '${currentDir.path}/$referenceDir';
  final brickPath = '${currentDir.path}/$brickDir';

  final refDirectory = Directory(refPath);
  if (!await refDirectory.exists()) {
    print('Error: Reference directory not found at $refPath');
    exit(1);
  }

  // Clear existing brick directory
  final brickDirectory = Directory(brickPath);
  if (await brickDirectory.exists()) {
    print('Cleaning existing brick directory...');
    await brickDirectory.delete(recursive: true);
  }
  await brickDirectory.create(recursive: true);

  print('Syncing files from $referenceDir to $brickDir...');

  await for (final entity in refDirectory.list(recursive: true)) {
    if (entity is File) {
      if (_shouldIgnore(entity.path)) continue;

      final relativePath = entity.path.substring(refPath.length + 1);
      final newRelativePath = _applyReplacements(relativePath);
      final newPath = '$brickPath/$newRelativePath';

      final newFile = File(newPath);
      await newFile.parent.create(recursive: true);

      // Check if text file
      if (_isTextFile(entity.path)) {
        try {
          final content = await entity.readAsString();
          final newContent = _applyReplacements(content);
          await newFile.writeAsString(newContent);
        } catch (e) {
          print('Warning: Could not read/write ${entity.path} as text. Copying raw bytes. Error: $e');
          await entity.copy(newFile.path);
        }
      } else {
        await entity.copy(newFile.path);
      }
    }
  }

  print('Sync complete!');
}

bool _shouldIgnore(String path) {
  if (path.contains('/.git/')) return true;
  if (path.contains('/.dart_tool/')) return true;
  if (path.contains('/build/')) return true;
  if (path.contains('/.idea/')) return true;
  if (path.contains('/.vscode/')) return true;
  if (path.contains('pubspec.lock')) return true;
  if (path.contains('.DS_Store')) return true;
  if (path.contains('/.grade/')) return true;
  if (path.contains('local.properties')) return true;
  return false;
}

bool _isTextFile(String path) {
  final extension = path.split('.').last.toLowerCase();
  return ['dart', 'yaml', 'md', 'json', 'xml', 'txt', 'gradle', 'kts', 'properties', 'html', 'css', 'js', 'sh', 'xcconfig', 'plist'].contains(extension);
}

String _applyReplacements(String content) {
  var result = content;
  replacements.forEach((key, value) {
    result = result.replaceAll(key, value);
  });
  return result;
}
