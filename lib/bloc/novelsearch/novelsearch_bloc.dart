import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_allsearch_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'novelsearch_event.dart';
part 'novelsearch_state.dart';

class NovelsearchBloc extends Bloc<NovelsearchEvent, NovelsearchState> {
  NovelsearchBloc() : super(NovelsearchInitial()) {
    on<SearchNovelByName>(_onSearchNovelByName);
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
}
