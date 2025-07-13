import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository.dart';
import 'package:pdf_reader/domain/repositories/pdf_repository_impl.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import 'package:pdf_reader/screens/home_screen.dart';

void main() {
  final pdfRepo = PdfRepositoryImpl();
  final pickPdf = PickPdfFile(pdfRepo as PdfRepository);
  
  runApp(MyApp(pdfCubit: PdfCubit(pickPdf)));
}

class MyApp extends StatelessWidget {
  final PdfCubit pdfCubit;
  const MyApp({required this.pdfCubit});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Reader',
      theme: ThemeData.dark(),
      home: BlocProvider(create: (_) => pdfCubit, child: HomeScreen()),
    );
  }
}
