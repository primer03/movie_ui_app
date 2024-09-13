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
  final List<dynamic>? hisRead;

  const NovelDetailLoaded(this.dataNovel, this.hisRead);

  @override
  List<Object> get props => [dataNovel, hisRead ?? []];
}

final class NovelDetailError extends NovelDetailState {
  final String message;

  const NovelDetailError(this.message);

  @override
  List<Object> get props => [message];
}
