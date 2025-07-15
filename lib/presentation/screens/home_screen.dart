import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/widgets/appbar_menu.dart';
import 'package:pdf_reader/widgets/pdf_search_delegate.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import '../../domain/entities/bookmark.dart';
import 'package:pdf_reader/widgets/pdf_view_widget.dart';
import 'package:pdf_reader/widgets/fab_buttons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  final PdfViewerController _viewerController = PdfViewerController();

  bool _showAppBar = true;
  int _currentPage = 0;

  void toggleAppBar() {
    setState(() => _showAppBar = !_showAppBar);
  }

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
            _viewerController.jumpToPage(bookmarks[i].page + 1);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: AppBarMenu(
                currentPage: _currentPage,
                onAddBookmark: _showAddBookmarkDialog,
                onShowBookmarks: _showBookmarks,
                onSearch: () {
                  showSearch(
                    context: context,
                    delegate: PdfSearchDelegate(_viewerController),
                  );
                },
              ),
            )
          : null,
      body: PdfViewerWidget(
        showAppBar: _showAppBar,
        toggleAppBar: toggleAppBar,
        viewerController: _viewerController,
        pdfViewerKey: _pdfViewerKey,
        onPageChanged: (newPage) {
          setState(() => _currentPage = newPage);
        },
      ),
      floatingActionButton: _showAppBar ? const FabButtons() : null,
    );
  }
}
