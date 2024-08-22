part of 'novel_detail_bloc.dart';

sealed class NovelDetailState extends Equatable {
  const NovelDetailState();

  @override
  List<Object> get props => [];
}

final class NovelDetailInitial extends NovelDetailState {}

final class NovelDetailLoading extends NovelDetailState {}

final class NovelDetailLoaded extends NovelDetailState {
  final DataNovel dataNovel;

  const NovelDetailLoaded(this.dataNovel);

  @override
  List<Object> get props => [dataNovel];
}

final class NovelDetailError extends NovelDetailState {
  final String message;

  const NovelDetailError(this.message);

  @override
  List<Object> get props => [message];
}
