part of 'novelspecial_bloc.dart';

sealed class NovelspecialState extends Equatable {
  const NovelspecialState();

  @override
  List<Object> get props => [];
}

final class NovelspecialInitial extends NovelspecialState {}

final class NovelspecialLoading extends NovelspecialState {}

final class NovelspecialSuccess extends NovelspecialState {
  final SpecialPage specialPage;

  NovelspecialSuccess({required this.specialPage});

  @override
  List<Object> get props => [specialPage];
}

final class NovelspecialFailure extends NovelspecialState {
  final String error;

  NovelspecialFailure({required this.error});

  @override
  List<Object> get props => [error];
}

final class NovelspecialEmpty extends NovelspecialState {}
