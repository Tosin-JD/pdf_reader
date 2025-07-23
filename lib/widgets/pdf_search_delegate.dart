import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfSearchDelegate extends SearchDelegate {
  final PdfViewerController controller;
  late PdfTextSearchResult _searchResult;

  PdfSearchDelegate(this.controller) {
    _searchResult = PdfTextSearchResult();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (_searchResult.hasResult)
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_up),
          onPressed: () {
            _searchResult.previousInstance();
          },
        ),
      if (_searchResult.hasResult)
        IconButton(
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () {
            _searchResult.nextInstance();
          },
        ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          controller.clearSelection();
          _searchResult.clear();
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          controller.clearSelection();
          _searchResult.clear();
          close(context, null);
        },
      );

  @override
  Widget buildResults(BuildContext context) {
    controller.clearSelection();

    // Perform the search and listen for changes
    _searchResult = controller.searchText(
      query,
      searchOption: PdfTextSearchOption.caseSensitive,
    );

    // Handle result feedback
    if (!kIsWeb) {
      _searchResult.addListener(() {
        if (_searchResult.hasResult) {
          _searchResult.nextInstance();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No results found")),
          );
        }
      });
    } else {
      // Web platform workaround
      Future.delayed(const Duration(milliseconds: 300), () {
        if (_searchResult.hasResult) {
          _searchResult.nextInstance();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("No results found")),
          );
        }
      });
    }

    return Center(
      child: Text(
        'Searching for "$query"...',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        query.isEmpty ? 'Enter text to search' : 'Tap search to find "$query"',
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
