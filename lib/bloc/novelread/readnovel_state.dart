part of 'readnovel_bloc.dart';

sealed class ReadnovelState extends Equatable {
  const ReadnovelState();

  @override
  List<Object> get props => [];
}

final class ReadnovelInitial extends ReadnovelState {}

final class ReadnovelLoading extends ReadnovelState {}

final class ReadnovelLoaded extends ReadnovelState {
  final BookfetNovelRead bookfetNovelRead;

  const ReadnovelLoaded({required this.bookfetNovelRead});

  @override
  List<Object> get props => [bookfetNovelRead];
}

final class ReadnovelError extends ReadnovelState {
  final String message;

  const ReadnovelError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ReadnovelNoData extends ReadnovelState {}
