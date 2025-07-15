// lib/presentation/bloc/pdf_bloc.dart
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/entities/bookmark.dart';
import 'package:pdf_reader/domain/entities/pdf_file.dart';
import 'package:pdf_reader/domain/repositories/get_last_page.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';
import 'package:pdf_reader/domain/repositories/save_last_page.dart';
import 'package:pdf_reader/domain/usecases/add_bookmark.dart';
import 'package:pdf_reader/domain/usecases/get_bookmarks.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';
import 'package:pdf_reader/domain/usecases/share_pdf_file.dart';
import 'package:printing/printing.dart';

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
  final PdfRepository repository;
  final PickPdfFile pickPdfFile;
  final SaveLastPage saveLastPage;
  final GetLastPage getLastPage;
  final AddBookmark addBookmark;
  final GetBookmarks getBookmarks;
  final SharePdfFile sharePdfFile;

  PdfCubit(
    this.repository,
    this.pickPdfFile,
    this.saveLastPage,
    this.getLastPage,
    this.addBookmark,
    this.getBookmarks,
    this.sharePdfFile,
  ) : super(PdfState());

  Future<void> loadPdf() async {
    final pdf = await pickPdfFile();
    if (pdf == null) return;
    await repository.saveLastOpenedFile(pdf.path);

    final lastPage = await getLastPage(pdf.path);
    final bookmarks = await getBookmarks(pdf.path);

    emit(PdfState(pdf: pdf, lastPage: lastPage, bookmarks: bookmarks));
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

  Future<void> loadLastOpenedFile() async {
    final path = await repository.getLastOpenedFile();
    if (path != null && File(path).existsSync()) {
      final pdf = PdfFile(name: path.split('/').last, path: path);
      final lastPage = await repository.getLastPage(path);
      final bookmarks = await repository.getBookmarks(path);

      emit(PdfState(pdf: pdf, lastPage: lastPage, bookmarks: bookmarks));
    }
  }

  Future<void> shareCurrentPdf() async {
    final path = state.pdf?.path;
    if (path != null) {
      await sharePdfFile(path);
    }
  }

  Future<void> printCurrentPdf() async {
    final file = state.pdf;
    if (file == null) return;

    await Printing.layoutPdf(onLayout: (_) => File(file.path).readAsBytes());
  }
}
