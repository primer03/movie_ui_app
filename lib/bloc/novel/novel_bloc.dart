import 'package:bloc/bloc.dart';
import 'package:bloctest/models/novel_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';

part 'novel_event.dart';
part 'novel_state.dart';

class NovelBloc extends Bloc<NovelEvent, NovelState> {
  final NovelRepository _novelRepository = NovelRepository();
  NovelBloc() : super(NovelInitial()) {
    on<FetchNovels>(_onFetchNovels);
    on<ResetNovels>(_onResetNovels);
  }

  void _onFetchNovels(FetchNovels event, Emitter<NovelState> emit) async {
    print('Fetching novels...');
    emit(NovelLoading());
    try {
      final novels = await _novelRepository.getNovels();
      emit(NovelLoaded(novels));
    } catch (e) {
      emit(NovelError('เกิดข้อผิดพลาด'));
    }
  }

  void _onResetNovels(ResetNovels event, Emitter<NovelState> emit) {
    emit(NovelInitial()); // Reset to initial state
    add(FetchNovels()); // Fetch new data
  }
}
