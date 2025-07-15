import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ScreenOrientation { portrait, landscape }

class OrientationState {
  final ScreenOrientation orientation;
  final bool isLocked;

  OrientationState({
    required this.orientation,
    required this.isLocked,
  });

  OrientationState copyWith({
    ScreenOrientation? orientation,
    bool? isLocked,
  }) {
    return OrientationState(
      orientation: orientation ?? this.orientation,
      isLocked: isLocked ?? this.isLocked,
    );
  }
}

class OrientationCubit extends Cubit<OrientationState> {
  OrientationCubit()
      : super(OrientationState(
          orientation: ScreenOrientation.portrait,
          isLocked: true,
        )) {
    _applyOrientation();
  }

  void toggleLock() {
    emit(state.copyWith(isLocked: !state.isLocked));
    _applyOrientation();
  }

  void rotate() {
    final newOrientation = state.orientation == ScreenOrientation.portrait
        ? ScreenOrientation.landscape
        : ScreenOrientation.portrait;

    emit(state.copyWith(orientation: newOrientation));
    _applyOrientation();
  }

  void _applyOrientation() {
    if (state.isLocked) {
      // Lock strictly to current orientation
      if (state.orientation == ScreenOrientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
      }
    } else {
      // Manual set but allow free rotation in current axis
      if (state.orientation == ScreenOrientation.portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
        ]);
      }
    }
  }
}
