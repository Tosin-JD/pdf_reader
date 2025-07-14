import '../repositories/pdf_repository.dart';

class SaveLastPage {
  final PdfRepository repository;

  SaveLastPage(this.repository);

  Future<void> call(String filePath, int pageNumber) {
    return repository.saveLastPage(filePath, pageNumber);
  }
}
