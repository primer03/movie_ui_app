import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'novelsearch_event.dart';
part 'novelsearch_state.dart';

class NovelsearchBloc extends Bloc<NovelsearchEvent, NovelsearchState> {
  NovelsearchBloc() : super(NovelsearchInitial()) {
    on<SearchNovelByName>(_onSearchNovelByName);
    on<FilterNovelByGenre>(_onFilterNovelByGenre);
    on<SortNovel>(_onSortNovel);
  }

  NovelRepository novelRepository = NovelRepository();

  void _onSearchNovelByName(
      SearchNovelByName event, Emitter<NovelsearchState> emit) async {
    emit(NovelsearchLoading());
    try {
      final search = await novelRepository.searchNovelByName(event.query);
      search.isEmpty
          ? emit(NovelsearchEmpty())
          : emit(NovelsearchLoaded(search));
    } catch (e) {
      emit(NovelsearchError('Failed to search novels: $e'));
    }
  }

  void _onFilterNovelByGenre(
      FilterNovelByGenre event, Emitter<NovelsearchState> emit) async {
    emit(NovelsearchFilter(event.searchnovel));
    try {
      final search = await novelRepository.filterNovelByGenre(event.category,
          query: event.query);
      search.isEmpty
          ? emit(NovelsearchEmpty())
          : emit(NovelsearchLoaded(search));
    } catch (e) {
      emit(NovelsearchError('Failed to filter novels: $e'));
    }
  }

  void _onSortNovel(SortNovel event, Emitter<NovelsearchState> emit) {
    emit(NovelsearchFilter(event.searchnovel));
    try {
      if (event.sort == 'ยอดการดู') {
        event.searchnovel.sort((a, b) => b.view.compareTo(a.view));
        emit(NovelsearchLoaded(event.searchnovel));
      } else if (event.sort == 'จำนวนตอน') {
        event.searchnovel.sort((a, b) => b.allep.compareTo(a.allep));
        emit(NovelsearchLoaded(event.searchnovel));
      } else if (event.sort == 'อัพเดทล่าสุด') {
        event.searchnovel.sort((a, b) => b.updateEp.compareTo(a.updateEp));
        emit(NovelsearchLoaded(event.searchnovel));
      }
    } catch (e) {
      emit(NovelsearchError('Failed to sort novels: $e'));
    }
  }
}
