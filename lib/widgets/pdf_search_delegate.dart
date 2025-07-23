// lib/widgets/pdf_search_delegate.dart
import 'package:flutter/material.dart';
import 'package:pdfrx/pdfrx.dart';

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
    if (query.isEmpty) {
      return const Center(child: Text("Enter search term"));
    }

    // pdfrx doesn't have built-in search functionality like Syncfusion
    // This is a placeholder implementation
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Search for: "$query"',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          const Text(
            'Text search is not available with pdfrx.\nConsider using text selection instead.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => close(context, query),
            child: const Text('Close Search'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          'Enter text to search',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
    
    return const Center(
      child: Text(
        'Text search is not supported by pdfrx',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}