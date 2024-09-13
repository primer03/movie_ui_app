part of 'novel_bloc.dart';

sealed class NovelState extends Equatable {
  const NovelState();

  @override
  List<Object> get props => [];
}

final class NovelInitial extends NovelState {}

final class NovelLoading extends NovelState {}

final class NovelLoaded extends NovelState {
  final Welcome novels;

  const NovelLoaded(this.novels);

  @override
  List<Object> get props => [novels];
}

final class NovelNoData extends NovelState {
  final String message;

  const NovelNoData(this.message);

  @override
  List<Object> get props => [message];
}

final class NovelError extends NovelState {
  final String message;

  const NovelError(this.message);

  @override
  List<Object> get props => [message];
}
