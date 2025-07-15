import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_reader/main.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';
import '../../../../domain/entities/bookmark.dart';

class AppBarMenu extends StatelessWidget {
  final int currentPage;
  final void Function(BuildContext, int) onAddBookmark;
  final void Function(BuildContext, List<Bookmark>) onShowBookmarks;
  final void Function(String) onSearch;

  const AppBarMenu({
    super.key,
    required this.currentPage,
    required this.onAddBookmark,
    required this.onShowBookmarks,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.read<PdfCubit>().state.bookmarks;

    return AppBar(
      title: const Text("PDF Reader"),
      actions: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => onSearch(context as String),
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: () => onAddBookmark(context, currentPage),
        ),
        IconButton(
          icon: const Icon(Icons.list),
          onPressed: () => onShowBookmarks(context, bookmarks),
        ),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'settings':
                navigationService.navigateTo('/settings');
                break;
              case 'about':
                navigationService.navigateTo('/about');
                break;
              case 'exit':
                exit(0);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'settings',
              child: Text('Settings'),
            ),
            PopupMenuItem(
              value: 'about',
              child: Text('About'),
            ),
            PopupMenuItem(
              value: 'exit',
              child: Text('Exit'),
            ),
          ],
        ),
      ],
    );
  }
}
