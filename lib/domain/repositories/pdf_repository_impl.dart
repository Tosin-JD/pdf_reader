import 'package:file_picker/file_picker.dart';
import 'package:pdf_reader/domain/entities/pdf_file.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';

class PdfRepositoryImpl implements PdfRepository {
  @override
  Future<PdfFile?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      return PdfFile(
        path: result.files.single.path!,
        name: result.files.single.name,
      );
    }
    return null;
  }
}
