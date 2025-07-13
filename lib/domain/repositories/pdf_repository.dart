import 'package:pdf_reader/domain/entities/pdf_file.dart';

abstract class PdfRepository {
  Future<PdfFile?> pickPdfFile();
}