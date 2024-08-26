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
