import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloctest/main.dart';
import 'package:bloctest/models/novel_special_model.dart';
import 'package:bloctest/repositories/novel_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/logger.dart';

part 'novelspecial_event.dart';
part 'novelspecial_state.dart';

class NovelspecialBloc extends Bloc<NovelspecialEvent, NovelspecialState> {
  NovelspecialBloc() : super(NovelspecialInitial()) {
    on<FetchNovelSpecial>(_onFetchNovelSpecial);
  }

  NovelRepository _novelRepository = NovelRepository();

  void _onFetchNovelSpecial(
      FetchNovelSpecial event, Emitter<NovelspecialState> emit) async {
    var specialData = await novelBox.get('specialData');
    if (specialData != null) {
      Logger().i('specialData: ${json.decode(specialData)}');
      emit(NovelspecialSuccess(
          specialPage: SpecialPage.fromJson(json.decode(specialData))));
      return;
    }
    emit(NovelspecialLoading());
    try {
      final specialPage = await _novelRepository.getNovelSpecial();
      if (specialPage.specialBanner!.isEmpty &&
          specialPage.specialCharacter!.isEmpty) {
        emit(NovelspecialEmpty());
      } else {
        emit(NovelspecialSuccess(specialPage: specialPage));
      }
    } catch (e) {
      emit(NovelspecialFailure(error: e.toString()));
    }
  }
}
