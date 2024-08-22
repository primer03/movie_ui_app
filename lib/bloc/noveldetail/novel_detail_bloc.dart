import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_detail_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';

part 'novel_detail_event.dart';
part 'novel_detail_state.dart';

class NovelDetailBloc extends Bloc<NovelDetailEvent, NovelDetailState> {
  NovelDetailBloc() : super(NovelDetailInitial()) {
    on<FetchNovelDetail>(_onFetchNovelDetail);
  }
  NovelRepository _novelRepository = NovelRepository();

  void _onFetchNovelDetail(
      FetchNovelDetail event, Emitter<NovelDetailState> emit) async {
    print('NovelID: ${event.novelId}');
    print('Fetching novel detail...');
    emit(NovelDetailLoading());
    try {
      final dataNovel = await _novelRepository.getnovelById(event.novelId);
      // Logger().i('dataNovel: ${dataNovel.novel}');
      emit(NovelDetailLoaded(dataNovel));
    } catch (e) {
      Logger().e('Error: $e');
      emit(const NovelDetailError('เกิดข้อผิดพลาด'));
    }
  }
}
