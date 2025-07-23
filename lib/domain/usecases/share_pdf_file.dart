import 'dart:io';
import 'package:share_plus/share_plus.dart';

class SharePdfFile {
  Future<void> call(String path) async {
    final file = File(path);
    final params = ShareParams(
      text: 'Check this PDF File',
      files: [XFile(path)], 
    );
    if (file.existsSync()) {
      await SharePlus.instance.share(params);
    }
  }
}
