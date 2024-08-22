part of 'novel_detail_bloc.dart';

sealed class NovelDetailEvent extends Equatable {
  const NovelDetailEvent();

  @override
  List<Object> get props => [];
}

final class FetchNovelDetail extends NovelDetailEvent {
  final int novelId;

  const FetchNovelDetail(this.novelId);

  @override
  List<Object> get props => [novelId];
}
