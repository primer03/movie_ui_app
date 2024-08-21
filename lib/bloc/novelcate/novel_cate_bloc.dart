import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'novel_cate_event.dart';
part 'novel_cate_state.dart';

class NovelCateBloc extends Bloc<NovelCateEvent, NovelCateState> {
  NovelCateBloc() : super(NovelCateInitial()) {
    on<FetchNovelCate>(_onFetchNovelCate);
  }

  NovelRepository novelRepository = NovelRepository();

  void _onFetchNovelCate(
      FetchNovelCate event, Emitter<NovelCateState> emit) async {
    emit(NovelCateLoading(state.allsearch));
    try {
      final List<Searchnovel> search =
          await novelRepository.searchNovels(event.cateID);
      search.isEmpty ? emit(NovelCateEmpty()) : emit(NovelCateLoaded(search));
    } catch (e) {
      emit(NovelCateError(e.toString()));
    }
  }
}
