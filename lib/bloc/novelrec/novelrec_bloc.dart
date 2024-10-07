import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'novelrec_event.dart';
part 'novelrec_state.dart';

class NovelrecBloc extends Bloc<NovelrecEvent, NovelrecState> {
  NovelrecBloc() : super(NovelrecInitial()) {
    on<NovelrecLoad>(_onFetchNovelrec);
  }

  NovelRepository _novelRepository = NovelRepository();

  void _onFetchNovelrec(NovelrecLoad event, Emitter<NovelrecState> emit) async {
    print('Fetching novel rec...');
    emit(NovelrecLoading());
    try {
      final dataNovel = await _novelRepository.recNovels(event.name);
      if (dataNovel.isEmpty) {
        emit(const NovelrecEmpty('ไม่พบข้อมูล'));
      } else {
        emit(NovelrecLoaded(dataNovel));
      }
    } catch (e) {
      emit(const NovelrecError('เกิดข้อผิดพลาด'));
    }
  }
}
