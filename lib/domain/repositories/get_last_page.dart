import '../repositories/pdf_repository.dart';

class GetLastPage {
  final PdfRepository repository;

  GetLastPage(this.repository);

  Future<int?> call(String filePath) {
    return repository.getLastPage(filePath);
  }
}
