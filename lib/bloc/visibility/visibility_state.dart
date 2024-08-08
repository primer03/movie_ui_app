part of 'visibility_bloc.dart';

sealed class VisibilityState extends Equatable {
  const VisibilityState();

  @override
  List<Object> get props => [];
}

final class VisibilityInitial extends VisibilityState {}

class VisibilityStatusChanged extends VisibilityState {
  final bool isVisible;

  const VisibilityStatusChanged({required this.isVisible});

  @override
  List<Object> get props => [isVisible];
}
