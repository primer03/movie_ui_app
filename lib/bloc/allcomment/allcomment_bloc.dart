import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_coment_all_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'allcomment_event.dart';
part 'allcomment_state.dart';

class AllcommentBloc extends Bloc<AllcommentEvent, AllcommentState> {
  AllcommentBloc() : super(AllcommentInitial()) {
    on<AllcommentFetch>(_onFetchAllcomment);
  }
  NovelRepository novelRepository = NovelRepository();

  void _onFetchAllcomment(
      AllcommentFetch event, Emitter<AllcommentState> emit) async {
    emit(AllcommentLoading());
    try {
      final comments = await novelRepository.getAllComent(event.bookID);
      if (comments.comment == null) {
        emit(AllcommentEmpty());
      } else if (comments.comment!.isEmpty) {
        emit(AllcommentEmpty());
      } else {
        emit(AllcommentLoaded(comments: comments));
      }
    } catch (e) {
      emit(AllcommentError(message: e.toString()));
    }
  }
}
