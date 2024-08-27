part of 'novelsearch_bloc.dart';

sealed class NovelsearchEvent extends Equatable {
  const NovelsearchEvent();

  @override
  List<Object> get props => [];
}

final class SearchNovelByName extends NovelsearchEvent {
  final String query;
  const SearchNovelByName(this.query);

  @override
  List<Object> get props => [query];
}

final class FilterNovelByGenre extends NovelsearchEvent {
  final String category;
  final List<Searchnovel> searchnovel;
  final String? query;
  const FilterNovelByGenre(this.category, this.searchnovel, {this.query});

  @override
  List<Object> get props => [category, searchnovel, query ?? ''];
}

final class SortNovel extends NovelsearchEvent {
  final String sort;
  final List<Searchnovel> searchnovel;
  const SortNovel({required this.sort, required this.searchnovel});

  @override
  List<Object> get props => [sort, searchnovel];
}
