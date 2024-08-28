import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_bookmark_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';
part 'novelbookmark_event.dart';
part 'novelbookmark_state.dart';

class NovelbookmarkBloc extends Bloc<NovelbookmarkEvent, NovelbookmarkState> {
  NovelbookmarkBloc() : super(NovelbookmarkInitial()) {
    on<FetchBookmark>(_onFetchBookmark);
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
}
