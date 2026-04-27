import 'dart:io';

void main() {
  var dir = Directory('lib');
  var files = dir.listSync(recursive: true).whereType<File>().where((f) => f.path.endsWith('.dart'));
  
  for (var file in files) {
    var content = file.readAsStringSync();
    var newContent = content
        .replaceAll('package:attend/auth/', 'package:attend/features/auth/presentation/screens/')
        .replaceAll('package:attend/admin/', 'package:attend/features/admin/presentation/screens/')
        .replaceAll('package:attend/student/', 'package:attend/features/student/presentation/screens/')
        .replaceAll('package:attend/teacher/', 'package:attend/features/teacher/presentation/screens/');
        
    if (content != newContent) {
      file.writeAsStringSync(newContent);
      print('Updated: ' + file.path);
    }
  }
}
