import 'package:pdf_reader/domain/entities/bookmark.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';

class AddBookmark {
  final PdfRepository repository;

  AddBookmark(this.repository);

  Future<void> call(String filePath, Bookmark bookmark) {
    return repository.addBookmark(filePath, bookmark);
  }
}