import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import '../../domain/entities/bookmark.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _viewerController = PdfViewerController();

  int _currentPage = 0;
  bool _showAppBar = true;
  int _tapCount = 0;
  Timer? _tapTimer;

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
            _viewerController.jumpToPage(
              bookmarks[i].page + 1,
            ); // SfPdfViewer is 1-indexed
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PdfCubit>();

    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
              title: const Text("PDF Reader"),
              actions: [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: PdfSearchDelegate(_viewerController),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.bookmark),
                  onPressed: () =>
                      _showAddBookmarkDialog(context, _currentPage),
                ),
                IconButton(
                  icon: const Icon(Icons.list),
                  onPressed: () => _showBookmarks(
                    context,
                    context.read<PdfCubit>().state.bookmarks,
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'settings':
                        Navigator.pushNamed(context, '/settings');
                        break;
                      case 'about':
                        showAboutDialog(
                          context: context,
                          applicationName: 'PDF Reader',
                          applicationVersion: '1.0.0',
                          applicationLegalese: '© Oluwatosin Durodola',
                        );
                        break;
                      case 'exit':
                        exit(0);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'settings',
                      child: Text('Settings'),
                    ),
                    const PopupMenuItem(value: 'about', child: Text('About')),
                    const PopupMenuItem(value: 'exit', child: Text('Exit')),
                  ],
                ),
              ],
            )
          : null,
      body: BlocBuilder<PdfCubit, PdfState>(
        builder: (context, state) {
          if (state.pdf != null && File(state.pdf!.path).existsSync()) {
            return Stack(
              children: [
                SfPdfViewer.file(
                  File(state.pdf!.path),
                  key: _pdfViewerKey,
                  controller: _viewerController,
                  initialScrollOffset: Offset.zero,
                  initialZoomLevel: 1.0,
                  canShowScrollStatus: false,
                  onPageChanged: (details) {
                    setState(() {
                      _currentPage = details.newPageNumber - 1;
                    });
                    bloc.savePage(_currentPage);
                  },
                  initialPageNumber:
                      (state.lastPage ?? 0) + 1, // SfPdfViewer is 1-indexed
                ),
                // Tap overlay for toggling AppBar
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTapDown: (_) {
                      _tapCount++;
                      _tapTimer?.cancel();
                      _tapTimer = Timer(const Duration(milliseconds: 250), () {
                        if (_tapCount == 1) {
                          setState(() {
                            _showAppBar = !_showAppBar;
                          });
                        }
                        _tapCount = 0;
                      });
                    },
                  ),
                ),
              ],
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

class PdfSearchDelegate extends SearchDelegate {
  final PdfViewerController controller;

  PdfSearchDelegate(this.controller);

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
  ];

  @override
  Widget? buildLeading(BuildContext context) => BackButton();

  @override
  Widget buildResults(BuildContext context) {
    controller.clearSelection();

    final searchResult = controller.searchText(query);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (searchResult.hasResult) {
        searchResult.nextInstance();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("No results found")));
      }
    });

    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) => const SizedBox();
}
