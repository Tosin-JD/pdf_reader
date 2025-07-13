import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/domain/entities/pdf_file.dart';
import 'package:pdf_reader/domain/usecases/pick_pdf_file.dart';

class PdfState {
  final PdfFile? pdf;
  PdfState(this.pdf);
}


class PdfCubit extends Cubit<PdfState> {
  final PickPdfFile pickPdfFile;

  PdfCubit(this.pickPdfFile) : super(PdfState(null));

  Future<void> loadPdf() async {
    final pdf = await pickPdfFile();
    emit(PdfState(pdf));
  }
}


