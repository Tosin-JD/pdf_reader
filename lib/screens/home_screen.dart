import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import '../../domain/entities/bookmark.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PDFViewController _pdfViewController;
  int _currentPage = 0;

  void _showAddBookmarkDialog(BuildContext context, int page) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add Bookmark'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: "Bookmark label"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text("Save"),
            onPressed: () {
              context.read<PdfCubit>().addNewBookmark(page, controller.text);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showBookmarks(BuildContext context, List<Bookmark> bookmarks) {
    showModalBottomSheet(
      context: context,
      builder: (_) => ListView.builder(
        itemCount: bookmarks.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(bookmarks[i].label),
          subtitle: Text("Page ${bookmarks[i].page + 1}"),
          onTap: () {
            Navigator.pop(context);
            _pdfViewController.setPage(bookmarks[i].page);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PdfCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF Reader"),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => _showAddBookmarkDialog(context, _currentPage),
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () =>
                _showBookmarks(context, context.read<PdfCubit>().state.bookmarks),
          ),
        ],
      ),
      body: BlocBuilder<PdfCubit, PdfState>(
        builder: (context, state) {
          if (state.pdf != null) {
            return PDFView(
              filePath: state.pdf!.path,
              defaultPage: state.lastPage ?? 0,
              enableSwipe: true,
              swipeHorizontal: false,
              autoSpacing: true,
              pageFling: true,
              onPageChanged: (page, total) {
                setState(() {
                  _currentPage = page!;
                });
                bloc.savePage(_currentPage);
              },
              onViewCreated: (controller) {
                _pdfViewController = controller;
              },
            );
          } else {
            return const Center(child: Text("No PDF Selected"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => bloc.loadPdf(),
        child: const Icon(Icons.file_open),
      ),
    );
  }
}
