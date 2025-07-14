// lib/presentation/bloc/pdf_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/entities/bookmark.dart';
import 'package:pdf_reader/domain/entities/pdf_file.dart';
import 'package:pdf_reader/domain/repositories/get_last_page.dart';
import 'package:pdf_reader/domain/repositories/save_last_page.dart';
import 'package:pdf_reader/domain/usecases/add_bookmark.dart';
import 'package:pdf_reader/domain/usecases/get_bookmarks.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';


class PdfState {
  final PdfFile? pdf;
  final int? lastPage;
  final List<Bookmark> bookmarks;

  PdfState({this.pdf, this.lastPage, this.bookmarks = const []});

  PdfState copyWith({PdfFile? pdf, int? lastPage, List<Bookmark>? bookmarks}) {
    return PdfState(
      pdf: pdf ?? this.pdf,
      lastPage: lastPage ?? this.lastPage,
      bookmarks: bookmarks ?? this.bookmarks,
    );
  }
}

class PdfCubit extends Cubit<PdfState> {
  final PickPdfFile pickPdfFile;
  final SaveLastPage saveLastPage;
  final GetLastPage getLastPage;
  final AddBookmark addBookmark;
  final GetBookmarks getBookmarks;

  PdfCubit(
    this.pickPdfFile,
    this.saveLastPage,
    this.getLastPage,
    this.addBookmark,
    this.getBookmarks,
  ) : super(PdfState());

  Future<void> loadPdf() async {
    final pdf = await pickPdfFile();
    if (pdf != null) {
      final lastPage = await getLastPage(pdf.path);
      final bookmarks = await getBookmarks(pdf.path);
      emit(PdfState(pdf: pdf, lastPage: lastPage, bookmarks: bookmarks));
    }
  }

  Future<void> savePage(int page) async {
    if (state.pdf != null) {
      await saveLastPage(state.pdf!.path, page);
    }
  }

  Future<void> addNewBookmark(int page, String label) async {
    if (state.pdf != null) {
      final bookmark = Bookmark(page: page, label: label);
      await addBookmark(state.pdf!.path, bookmark);
      final updatedBookmarks = await getBookmarks(state.pdf!.path);
      emit(state.copyWith(bookmarks: updatedBookmarks));
    }
  }
}
