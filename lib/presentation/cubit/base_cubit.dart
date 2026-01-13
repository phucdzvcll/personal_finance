import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/failures.dart';

/// Base cubit class with common functionality
abstract class BaseCubit<T> extends Cubit<T> {
  BaseCubit(super.initialState);

  /// Handle failure and emit appropriate state
  void handleFailure(Failure failure) {
    // Override in child classes to handle failures
    // Example: emit(state.copyWith(error: failure.message));
  }
}
