import 'package:flutter/material.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PdfCubit>();

    return Scaffold(
      appBar: AppBar(title: Text("Pdf Reader")),
      body: BlocBuilder<PdfCubit, PdfState>(
        builder: (context, state) {
          if (state.pdf != null) {
            return PDFView(
              filePath: state.pdf!.path,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
            );
          } else {
            return Center(child: Text("No PDF Selected"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.loadPdf(),
        child: Icon(Icons.file_open),
      ),
    );
  }
}
