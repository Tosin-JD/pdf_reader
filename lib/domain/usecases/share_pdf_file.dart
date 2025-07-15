import 'dart:io';
import 'package:share_plus/share_plus.dart';

class SharePdfFile {
  Future<void> call(String path) async {
    final file = File(path);
    if (file.existsSync()) {
      await Share.shareXFiles([XFile(path)], text: 'Check out this PDF');
    }
  }
}
