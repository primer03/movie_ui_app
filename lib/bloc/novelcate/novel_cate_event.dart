part of 'novel_cate_bloc.dart';

sealed class NovelCateEvent extends Equatable {
  const NovelCateEvent();

  @override
  List<Object> get props => [];
}

class FetchNovelCate extends NovelCateEvent {
  final int cateID;
  FetchNovelCate({required this.cateID});
}
