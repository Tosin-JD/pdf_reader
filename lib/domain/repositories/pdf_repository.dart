import 'package:pdf_reader/domain/entities/bookmark.dart';
import 'package:pdf_reader/domain/entities/pdf_file.dart';

abstract class PdfRepository {
  Future<PdfFile?> pickPdfFile();
  Future<void> saveLastPage(String filaPath, int pageNumber);
  Future<int?> getLastPage(String filePath);

  Future<void> addBookmark(String filePath, Bookmark bookmark);
  Future<List<Bookmark>> getBookmarks(String filePath);

  Future<void> saveLastOpenedFile(String filePath);
  Future<String?> getLastOpenedFile();
}
