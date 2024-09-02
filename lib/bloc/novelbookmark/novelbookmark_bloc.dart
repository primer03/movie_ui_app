import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';
part 'novelbookmark_event.dart';
part 'novelbookmark_state.dart';

class NovelbookmarkBloc extends Bloc<NovelbookmarkEvent, NovelbookmarkState> {
  NovelbookmarkBloc() : super(NovelbookmarkInitial()) {
    on<FetchBookmark>(_onFetchBookmark);
    on<AddBookmarkEvent>(_onAddBookmark);
    on<RemoveBookmarkEvent>(_onRemoveBookmark);
    on<BoolmarkSearchEvent>(_onsearchBookmark);
  }

  NovelRepository novelRepository = NovelRepository();

  void _onFetchBookmark(
      FetchBookmark event, Emitter<NovelbookmarkState> emit) async {
    emit(BookmarkLoading());
    try {
      final bookmarkList = await novelRepository.getBookmark();
      bookmarkList.isEmpty
          ? emit(BookmarkEmpty())
          : emit(BookmarkLoaded(bookmarkList));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  void _onAddBookmark(
      AddBookmarkEvent event, Emitter<NovelbookmarkState> emit) async {
    try {
      final bookmarkList = await novelRepository.getBookmark();
      bookmarkList.isEmpty
          ? emit(BookmarkEmpty())
          : emit(BookmarkLoaded(bookmarkList));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  void _onRemoveBookmark(
      RemoveBookmarkEvent event, Emitter<NovelbookmarkState> emit) async {
    try {
      final bookmarkList = await novelRepository.getBookmark();
      bookmarkList.isEmpty
          ? emit(BookmarkEmpty())
          : emit(BookmarkLoaded(bookmarkList));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }

  void _onsearchBookmark(
      BoolmarkSearchEvent event, Emitter<NovelbookmarkState> emit) async {
    emit(BookmarlSearching(event.bookmarkList));
    try {
      final bookmarkList =
          await novelRepository.searchBookmark(event.cateId, event.search);
      bookmarkList.isEmpty
          ? emit(BookmarkEmpty())
          : emit(BookmarkLoaded(bookmarkList));
    } catch (e) {
      emit(BookmarkError(e.toString()));
    }
  }
}
