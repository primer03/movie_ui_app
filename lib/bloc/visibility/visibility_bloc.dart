import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'visibility_event.dart';
part 'visibility_state.dart';

class VisibilityBloc extends Bloc<VisibilityEvent, VisibilityState> {
  VisibilityBloc() : super(VisibilityInitial()) {
    on<VisibilityChanged>(_onVisibilityChanged);
  }

  void _onVisibilityChanged(VisibilityChanged event, Emitter emit) {
    emit(VisibilityStatusChanged(isVisible: event.isVisible));
  }
}
