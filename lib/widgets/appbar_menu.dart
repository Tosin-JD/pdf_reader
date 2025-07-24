import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/main.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import 'package:pdf_reader/widgets/pdf_search_field.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../domain/entities/bookmark.dart';

class AppBarMenu extends StatefulWidget {
  final int currentPage;
  final void Function(BuildContext, int) onAddBookmark;
  final void Function(BuildContext, List<Bookmark>) onShowBookmarks;
  final PdfViewerController viewerController;

  const AppBarMenu({
    super.key,
    required this.currentPage,
    required this.onAddBookmark,
    required this.onShowBookmarks,
    required this.viewerController,
  });

  @override
  State<AppBarMenu> createState() => _AppBarMenuState();
}

class _AppBarMenuState extends State<AppBarMenu> {
  bool _showSearchField = false;
  late PdfViewerController _pdfViewerController;

  @override
  void initState() {
    super.initState();
    _pdfViewerController = widget.viewerController;
  }

  void _showPdfInfoDialog(BuildContext context) async {
    final pdf = context.read<PdfCubit>().state.pdf;
    if (pdf == null) return;

    final file = File(pdf.path);
    final fileStat = await file.stat();

    final fileName = pdf.name;
    final filePath = pdf.path;
    final fileSize = _formatBytes(fileStat.size);
    final lastModified = fileStat.modified;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('PDF Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📄 Name: $fileName'),
            const SizedBox(height: 6),
            Text('📁 Path: $filePath'),
            const SizedBox(height: 6),
            Text('📏 Size: $fileSize'),
            const SizedBox(height: 6),
            Text('🕒 Modified: $lastModified'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  String _formatBytes(int bytes, [int decimals = 2]) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB"];
    final i = (log(bytes) / log(1024)).floor();
    final size = (bytes / pow(1024, i)).toStringAsFixed(decimals);
    return "$size ${suffixes[i]}";
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the PdfCubit's state. This will cause the widget to rebuild
    // whenever the state changes (e.g., a new PDF is loaded).
    final pdfState = context.watch<PdfCubit>().state;
    final bookmarks = pdfState.bookmarks;
    final pdf = pdfState.pdf;

    final titleWidget = _showSearchField
        ? PdfSearchField(
            controller: _pdfViewerController,
            onAction: (action) {
              if (action == 'cancelSearch') {
                setState(() => _showSearchField = false);
              }
            },
          )
        : Text(pdf?.name ?? 'PDF Reader', overflow: TextOverflow.ellipsis);

    return AppBar(
      title: titleWidget,
      actions: [
        IconButton(
          icon: Icon(_showSearchField ? Icons.close : Icons.search),
          onPressed: () {
            setState(() {
              // if (_showSearchField) {
              //   _searchController.clear();
              // }
              _showSearchField = !_showSearchField;
            });
          },
        ),
        if (!_showSearchField)
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Add Bookmark',
            // Disable the button if no PDF is loaded
            onPressed: pdf == null
                ? null
                : () => widget.onAddBookmark(context, widget.currentPage),
          ),
        if (!_showSearchField)
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'show-bookmarks':
                  widget.onShowBookmarks(context, bookmarks);
                  break;
                case 'share':
                  context.read<PdfCubit>().shareCurrentPdf();
                  break;
                case 'print':
                  context.read<PdfCubit>().printCurrentPdf();
                  break;
                case 'info':
                  _showPdfInfoDialog(context);
                  break;
                case 'donate':
                  _launchUrl('https://buymeacoffee.com/tosin789');
                  break;
                case 'settings':
                  navigationService.navigateTo('/settings');
                  break;
                case 'about-app':
                  navigationService.navigateTo('/about');
                  break;
                case 'about-developer':
                  navigationService.navigateTo('/about-developer');
                  break;
                case 'exit':
                  exit(0);
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                  value: 'show-bookmarks', child: Text('Show Bookmarks')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'share', child: Text('Share PDF')),
              PopupMenuItem(value: 'print', child: Text('Print PDF')),
              PopupMenuItem(value: 'info', child: Text('File Info')),
              PopupMenuDivider(),
              PopupMenuItem(value: 'settings', child: Text('Settings')),
              PopupMenuItem(value: 'donate', child: Text('❤️ Donate')),
              PopupMenuItem(value: 'about-app', child: Text('About the App')),
              PopupMenuItem(
                value: 'about-developer',
                child: Text('About the Developer'),
              ),
              PopupMenuDivider(),
              PopupMenuItem(value: 'exit', child: Text('Exit')),
            ],
          ),
      ],
    );
  }
}
