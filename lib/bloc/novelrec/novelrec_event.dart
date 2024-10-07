part of 'novelrec_bloc.dart';

sealed class NovelrecEvent extends Equatable {
  const NovelrecEvent();

  @override
  List<Object> get props => [];
}

class NovelrecLoad extends NovelrecEvent {
  final String name;
  const NovelrecLoad(this.name);

  @override
  List<Object> get props => [name];
}
