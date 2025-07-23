import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../presentation/bloc/orientation_cubit.dart';
import '../../../presentation/bloc/pdf_bloc.dart';

class FabButtons extends StatelessWidget {
  const FabButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrientationCubit, OrientationState>(
      builder: (context, state) {
        final orientationCubit = context.read<OrientationCubit>();
        final isPortrait = state.orientation == ScreenOrientation.portrait;

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!state.isLocked) ...[
              FloatingActionButton(
                heroTag: 'rotate',
                onPressed: () => orientationCubit.rotate(),
                child: Icon(isPortrait
                    ? Icons.screen_lock_landscape
                    : Icons.screen_lock_portrait),
              ),
              const SizedBox(height: 12),
            ],
            FloatingActionButton(
              heroTag: 'lock',
              onPressed: () => orientationCubit.toggleLock(),
              child:
                  Icon(state.isLocked ? Icons.lock : Icons.lock_open),
            ),
            const SizedBox(height: 12),
            FloatingActionButton(
              heroTag: 'pick',
              onPressed: () => context.read<PdfCubit>().loadPdf(),
              child: const Icon(Icons.file_open),
            ),
          ],
        );
      },
    );
  }
}
