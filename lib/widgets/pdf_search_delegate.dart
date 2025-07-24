import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfSearchDelegate extends SearchDelegate {
  final PdfViewerController controller;
  final PdfTextSearchResult searchResult;

  PdfSearchDelegate(this.controller, this.searchResult);

  @override
  List<Widget>? buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
            showSuggestions(context);
          },
        ),
      ];

  @override
  Widget? buildLeading(BuildContext context) => const BackButton();

  @override
  Widget buildResults(BuildContext context) {
    controller.clearSelection();
    searchResult.removeListener(() => _onSearchComplete(context));

    // Start the search
    final result = controller.searchText(
      query,
      searchOption: TextSearchOption.caseSensitive,
    );

    // Attach listener
    result.addListener(() => _onSearchComplete(context));

    return const Center(child: CircularProgressIndicator());
  }

  void _onSearchComplete(BuildContext context) {
    if (!context.mounted) return;

    if (searchResult.isSearchCompleted) {
      if (searchResult.hasResult) {
        searchResult.nextInstance();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No results found")),
        );
      }

      searchResult.removeListener(() => _onSearchComplete(context));
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox();
}
