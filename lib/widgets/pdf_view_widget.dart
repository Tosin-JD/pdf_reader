import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:pdf_reader/presentation/bloc/pdf_bloc.dart';

class PdfViewerWidget extends StatefulWidget {
  final bool showAppBar;
  final VoidCallback toggleAppBar;
  final PdfViewerController viewerController;
  final GlobalKey<SfPdfViewerState> pdfViewerKey;
  final void Function(int) onPageChanged;

  const PdfViewerWidget({
    super.key,
    required this.showAppBar,
    required this.toggleAppBar,
    required this.viewerController,
    required this.pdfViewerKey,
    required this.onPageChanged,
  });

  @override
  State<PdfViewerWidget> createState() => _PdfViewerWidgetState();
}

class _PdfViewerWidgetState extends State<PdfViewerWidget> {
  int _tapCount = 0;
  Timer? _tapTimer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PdfCubit, PdfState>(
      builder: (context, state) {
        if (state.pdf != null && File(state.pdf!.path).existsSync()) {
          return Stack(
            children: [
              SfPdfViewer.file(
                File(state.pdf!.path),
                key: widget.pdfViewerKey,
                controller: widget.viewerController,
                initialScrollOffset: Offset.zero,
                initialZoomLevel: 1.0001,
                canShowScrollStatus: false,
                enableDoubleTapZooming: true,
                enableTextSelection: true,
                interactionMode: PdfInteractionMode.selection,
                onPageChanged: (details) {
                  final page = details.newPageNumber - 1;
                  context.read<PdfCubit>().savePage(page);
                  widget.onPageChanged(page);
                },
                initialPageNumber: (state.lastPage ?? 0) + 1,
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
}
