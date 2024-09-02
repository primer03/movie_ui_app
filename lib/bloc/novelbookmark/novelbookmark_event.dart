part of 'novelbookmark_bloc.dart';

sealed class NovelbookmarkEvent extends Equatable {
  const NovelbookmarkEvent();

  @override
  List<Object> get props => [];
}

final class FetchBookmark extends NovelbookmarkEvent {
  const FetchBookmark();

  @override
  List<Object> get props => [];
}

final class AddBookmarkEvent extends NovelbookmarkEvent {
  const AddBookmarkEvent();

  @override
  List<Object> get props => [];
}

final class RemoveBookmarkEvent extends NovelbookmarkEvent {
  const RemoveBookmarkEvent();

  @override
  List<Object> get props => [];
}

final class BoolmarkSearchEvent extends NovelbookmarkEvent {
  final String? search;
  final String? cateId;
  final List<Bookmark> bookmarkList;

  const BoolmarkSearchEvent(
      {this.search, this.cateId, required this.bookmarkList});

  @override
  List<Object> get props => [search ?? '', cateId ?? '', bookmarkList];
}

final class BookmarkSortEvent extends NovelbookmarkEvent {
  final List<Bookmark> bookmarkList;
  final String sort;

  const BookmarkSortEvent({required this.bookmarkList, required this.sort});

  @override
  List<Object> get props => [bookmarkList, sort];
}
