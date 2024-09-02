part of 'novelbookmark_bloc.dart';

sealed class NovelbookmarkState extends Equatable {
  const NovelbookmarkState();

  @override
  List<Object> get props => [];
}

final class NovelbookmarkInitial extends NovelbookmarkState {}

final class BookmarkLoaded extends NovelbookmarkState {
  final List<Bookmark> bookmarkList;

  const BookmarkLoaded(this.bookmarkList);

  @override
  List<Object> get props => [bookmarkList];
}

final class BookmarkError extends NovelbookmarkState {
  final String message;

  const BookmarkError(this.message);

  @override
  List<Object> get props => [message];
}

final class BookmarkEmpty extends NovelbookmarkState {}

final class BookmarkLoading extends NovelbookmarkState {}

final class BookmarlSearching extends NovelbookmarkState {
  final List<Bookmark> bookmarkList;

  const BookmarlSearching(this.bookmarkList);

  @override
  List<Object> get props => [bookmarkList];
}
