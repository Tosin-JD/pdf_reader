import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class WakelockCubit extends Cubit<bool> {
  WakelockCubit() : super(false);

  void toggle() {
    final newValue = !state;
    if (newValue) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
    emit(newValue);
  }

  void set(bool keepAwake) {
    if (keepAwake) {
      WakelockPlus.enable();
    } else {
      WakelockPlus.disable();
    }
    emit(keepAwake);
  }
}
