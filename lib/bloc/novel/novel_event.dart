part of 'novel_bloc.dart';

sealed class NovelEvent extends Equatable {
  const NovelEvent();

  @override
  List<Object> get props => [];
}

final class FetchNovels extends NovelEvent {}

final class RefreshNovels extends NovelEvent {}

final class ResetNovels extends NovelEvent {}

final class FetchNovelDetail extends NovelEvent {
  final String novelId;

  const FetchNovelDetail(this.novelId);

  @override
  List<Object> get props => [novelId];
}
