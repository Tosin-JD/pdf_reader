// lib/widgets/pdf_view_widget.dart

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';

class PdfViewerWidget extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback toggleAppBar;
  final PdfViewerController viewerController;
  final void Function(int) onPageChanged;

  const PdfViewerWidget({
    super.key,
    required this.showAppBar,
    required this.toggleAppBar,
    required this.viewerController,
    required this.onPageChanged,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  int _tapCount = 0;
  Timer? _tapTimer;
  bool _hasNavigatedToInitialPage = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdfCubit, PdfState>(
      builder: (context, state) {
        if (state.pdf != null && File(state.pdf!.path).existsSync()) {
          return Stack(
            children: [
              PdfViewer.file(
                state.pdf!.path,
                controller: widget.viewerController,
                params: PdfViewerParams(
                  onDocumentChanged: (document) {
                    // Navigate to the last saved page when document loads
                    if (!_hasNavigatedToInitialPage && document != null) {
                      final initialPage = (state.lastPage ?? 0) + 1;
                      if (initialPage > 1) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          widget.viewerController.goToPage(pageNumber: initialPage);
                        });
                      }
                      _hasNavigatedToInitialPage = true;
                    }
                  },
                  onPageChanged: (pageNumber) {
                    if (pageNumber != null) {
                      final page = pageNumber - 1;
                      context.read<PdfCubit>().savePage(page);
                      widget.onPageChanged(page);
                    }
                  },
                ),
              ),

              // Transparent GestureDetector for toggling app bar
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (_) {
                    _tapCount++;
                    _tapTimer?.cancel();
                    _tapTimer = Timer(const Duration(milliseconds: 250), () {
                      if (_tapCount == 1) {
                        widget.toggleAppBar();
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
    );
  }

  @override
  void dispose() {
    _tapTimer?.cancel();
    super.dispose();
  }
}