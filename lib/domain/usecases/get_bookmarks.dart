import 'package:pdf_reader/domain/entities/bookmark.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';

class GetBookmarks {
  final PdfRepository repository;

  GetBookmarks(this.repository);

  Future<List<Bookmark>> call(String filePath) {
    return repository.getBookmarks(filePath);
  }
}