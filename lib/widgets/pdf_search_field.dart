import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

typedef PdfSearchCallback = void Function(String action);

class PdfSearchField extends StatefulWidget {
  final PdfViewerController controller;
  final PdfSearchCallback onAction;

  const PdfSearchField({
    super.key,
    required this.controller,
    required this.onAction,
  });

  @override
  State<PdfSearchField> createState() => _PdfSearchFieldState();
}

class _PdfSearchFieldState extends State<PdfSearchField> {
  final TextEditingController _editingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late PdfTextSearchResult _searchResult;
  bool _isSearchInitiated = false;
  bool _showToast = false;

  @override
  void initState() {
    super.initState();
    _searchResult = PdfTextSearchResult();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchResult.removeListener(() {});
    super.dispose();
  }

  void _startSearch(String text) {
    if (text.trim().isEmpty) return;
    _isSearchInitiated = true;
    _searchResult = widget.controller.searchText(text);
    _searchResult.addListener(() {
      if (!mounted) return;
      setState(() {});
      if (!_searchResult.hasResult && _searchResult.isSearchCompleted) {
        setState(() {
          _showToast = true;
        });
        widget.onAction("noResultFound");

        Future.delayed(const Duration(seconds: 1)).then((_) {
          if (mounted) {
            setState(() => _showToast = false);
          }
        });
      }
    });
  }

  void _clearSearch() {
    _editingController.clear();
    _searchResult.clear();
    widget.controller.clearSelection();
    _isSearchInitiated = false;
    _focusNode.requestFocus();
  }

  void _showEndDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Result'),
        content: const Text(
            'No more occurrences found. Would you like to continue from the beginning?'),
        actions: [
          TextButton(
            onPressed: () {
              _searchResult.nextInstance();
              Navigator.of(context).pop();
            },
            child: const Text('YES'),
          ),
          TextButton(
            onPressed: () {
              _clearSearch();
              Navigator.of(context).pop();
            },
            child: const Text('NO'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.onAction("cancelSearch");
            _clearSearch();
          },
        ),
        Expanded(
          child: TextFormField(
            controller: _editingController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Search PDF...',
              border: InputBorder.none,
            ),
            onFieldSubmitted: _startSearch,
            onChanged: (_) => setState(() {}),
          ),
        ),
        if (_editingController.text.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearSearch,
            tooltip: 'Clear',
          ),
        if (!_searchResult.isSearchCompleted && _isSearchInitiated)
          const Padding(
            padding: EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        if (_searchResult.hasResult)
          Row(
            children: [
              Text(
                '${_searchResult.currentInstanceIndex} of ${_searchResult.totalInstanceCount}',
                style: const TextStyle(fontSize: 16),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_before),
                onPressed: _searchResult.previousInstance,
                tooltip: 'Previous',
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next),
                onPressed: () {
                  if (_searchResult.currentInstanceIndex ==
                          _searchResult.totalInstanceCount &&
                      _searchResult.totalInstanceCount != 0) {
                    _showEndDialog();
                  } else {
                    widget.controller.clearSelection();
                    _searchResult.nextInstance();
                  }
                },
                tooltip: 'Next',
              ),
            ],
          ),
        if (_showToast)
          const Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              "No result",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
      ],
    );
  }
}
