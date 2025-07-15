import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfSearchDelegate extends SearchDelegate {
  final PdfViewerController controller;

  PdfSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => query = '',
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) {
    controller.clearSelection();

    final searchResult = controller.searchText(query);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (searchResult.hasResult) {
        searchResult.nextInstance();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No results found")),
        );
      }
    });

    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox();
}
