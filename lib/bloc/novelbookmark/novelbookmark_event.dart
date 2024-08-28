part of 'novelbookmark_bloc.dart';

sealed class NovelbookmarkEvent extends Equatable {
  const NovelbookmarkEvent();

  @override
  List<Object> get props => [];
}

final class FetchBookmark extends NovelbookmarkEvent {
  const FetchBookmark();

  @override
  List<Object> get props => [];
}
