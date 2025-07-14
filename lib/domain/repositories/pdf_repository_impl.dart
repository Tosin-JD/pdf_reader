import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/pdf_file.dart';
import '../../domain/entities/bookmark.dart';
import '../../domain/repositories/pdf_repository.dart';

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

  @override
  Future<void> saveLastPage(String filePath, int pageNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_page_$filePath', pageNumber);
  }

  @override
  Future<int?> getLastPage(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('last_page_$filePath');
  }

  @override
  Future<void> addBookmark(String filePath, Bookmark bookmark) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'bookmarks_$filePath';
    final existing = prefs.getStringList(key) ?? [];

    existing.add(jsonEncode(bookmark.toJson()));
    await prefs.setStringList(key, existing);
  }

  @override
  Future<List<Bookmark>> getBookmarks(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'bookmarks_$filePath';
    final stored = prefs.getStringList(key) ?? [];

    return stored.map((e) => Bookmark.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<void> saveLastOpenedFile(String filePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_opened_pdf', filePath);
  }

  @override
  Future<String?> getLastOpenedFile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('last_opened_pdf');
  }
}
