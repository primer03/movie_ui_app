part of 'novel_cate_bloc.dart';

sealed class NovelCateState extends Equatable {
  List<Searchnovel> allsearch;

  NovelCateState(this.allsearch);

  @override
  List<Object> get props => [allsearch];
}

final class NovelCateInitial extends NovelCateState {
  NovelCateInitial() : super([]);
}

final class NovelCateLoading extends NovelCateState {
  NovelCateLoading(List<Searchnovel> allsearch) : super(allsearch);
}

final class NovelCateLoaded extends NovelCateState {
  NovelCateLoaded(List<Searchnovel> allsearch) : super(allsearch);
}

final class NovelCateError extends NovelCateState {
  final String message;

  NovelCateError(this.message) : super([]);
}

final class NovelCateEmpty extends NovelCateState {
  NovelCateEmpty() : super([]);
}
