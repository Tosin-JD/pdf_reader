import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/repositories/get_last_page.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository_impl.dart';
import 'package:pdf_reader/domain/repositories/save_last_page.dart';
import 'package:pdf_reader/domain/usecases/add_bookmark.dart';
import 'package:pdf_reader/domain/usecases/get_bookmarks.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import 'package:pdf_reader/screens/home_screen.dart';



void main() {
  // 1. Create the repository instance
  final pdfRepo = PdfRepositoryImpl();

  // 2. Create use case instances
  final pickPdf = PickPdfFile(pdfRepo);
  final savePage = SaveLastPage(pdfRepo);
  final getLastPage = GetLastPage(pdfRepo);
  final addBookmark = AddBookmark(pdfRepo);
  final getBookmarks = GetBookmarks(pdfRepo);

  // 3. Inject into the Cubit
  final pdfCubit = PdfCubit(
    pickPdf,
    savePage,
    getLastPage,
    addBookmark,
    getBookmarks,
  );

  // 4. Run the app
  runApp(MyApp(pdfCubit: pdfCubit));
}

class MyApp extends StatelessWidget {
  final PdfCubit pdfCubit;

  const MyApp({super.key, required this.pdfCubit});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Reader',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (_) => pdfCubit,
        child: HomeScreen(),
      ),
    );
  }
}
