part of 'visibility_bloc.dart';

sealed class VisibilityEvent extends Equatable {
  const VisibilityEvent();

  @override
  List<Object> get props => [];
}

class VisibilityChanged extends VisibilityEvent {
  final bool isVisible;

  const VisibilityChanged({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}
