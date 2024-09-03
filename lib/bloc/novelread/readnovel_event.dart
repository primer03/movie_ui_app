part of 'readnovel_bloc.dart';

sealed class ReadnovelEvent extends Equatable {
  const ReadnovelEvent();

  @override
  List<Object> get props => [];
}

final class FetchReadnovel extends ReadnovelEvent {
  final String bookId;
  final String epId;

  const FetchReadnovel({
    required this.bookId,
    required this.epId,
  });

  @override
  List<Object> get props => [bookId, epId];
}
