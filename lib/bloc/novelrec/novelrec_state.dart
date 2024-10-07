part of 'novelrec_bloc.dart';

sealed class NovelrecState extends Equatable {
  const NovelrecState();

  @override
  List<Object> get props => [];
}

final class NovelrecInitial extends NovelrecState {}

final class NovelrecLoading extends NovelrecState {}

final class NovelrecLoaded extends NovelrecState {
  final List<Searchnovel> dataNovel;

  const NovelrecLoaded(this.dataNovel);

  @override
  List<Object> get props => [dataNovel];
}

final class NovelrecError extends NovelrecState {
  final String message;

  const NovelrecError(this.message);

  @override
  List<Object> get props => [message];
}

final class NovelrecEmpty extends NovelrecState {
  final String message;

  const NovelrecEmpty(this.message);

  @override
  List<Object> get props => [message];
}
