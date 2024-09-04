import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_read_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'readnovel_event.dart';
part 'readnovel_state.dart';

class ReadnovelBloc extends Bloc<ReadnovelEvent, ReadnovelState> {
  ReadnovelBloc() : super(ReadnovelInitial()) {
    on<FetchReadnovel>(_onFetchNoveReadl);
  }

  NovelRepository novelRepository = NovelRepository();

  void _onFetchNoveReadl(
      FetchReadnovel event, Emitter<ReadnovelState> emit) async {
    emit(ReadnovelLoading());
    try {
      BookfetNovelRead bookfetNovelRead =
          await novelRepository.getReadNovel(event.bookId, event.epId);
      if (bookfetNovelRead.readnovel.novelBook.id == 0) {
        emit(ReadnovelNoData());
      } else {
        emit(ReadnovelLoaded(bookfetNovelRead: bookfetNovelRead));
      }
    } catch (e) {
      emit(ReadnovelError(message: e.toString()));
    }
  }
}
