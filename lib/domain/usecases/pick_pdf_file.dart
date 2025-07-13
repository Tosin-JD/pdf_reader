import 'package:pdf_reader/domain/entities/pdf_file.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';

class PickPdfFile {
  final PdfRepository repository;

  PickPdfFile(this.repository);

  Future<PdfFile?> call() => repository.pickPdfFile();
}