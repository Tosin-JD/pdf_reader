import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfSearchField extends StatelessWidget {
  final PdfViewerController viewerController;
  final VoidCallback onClose;

  const PdfSearchField({
    super.key,
    required this.viewerController,
    required this.onClose,
  });

  void _performSearch(BuildContext context, String query) async {
    viewerController.clearSelection();
    final searchResult = viewerController.searchText(query);
    await Future.delayed(const Duration(milliseconds: 300));

    if (context.mounted) {
      searchResult.addListener(() {
        final message = searchResult.hasResult
            ? "Search results found."
            : "No results were found.";

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();

    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: "Search PDF...",
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (query) => _performSearch(context, query),
    );
  }
}
