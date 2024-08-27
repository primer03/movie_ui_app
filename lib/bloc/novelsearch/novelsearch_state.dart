part of 'novelsearch_bloc.dart';

sealed class NovelsearchState extends Equatable {
  const NovelsearchState();

  @override
  List<Object> get props => [];
}

final class NovelsearchInitial extends NovelsearchState {}

final class NovelsearchLoading extends NovelsearchState {}

final class NovelsearchLoaded extends NovelsearchState {
  final List<Searchnovel> searchnovel;
  const NovelsearchLoaded(this.searchnovel);

  @override
  List<Object> get props => [searchnovel];
}

final class NovelsearchError extends NovelsearchState {
  final String message;
  const NovelsearchError(this.message);

  @override
  List<Object> get props => [message];
}

final class NovelsearchEmpty extends NovelsearchState {}

final class NovelsearchFilter extends NovelsearchState {
  final List<Searchnovel> searchnovel;
  const NovelsearchFilter(this.searchnovel);

  @override
  List<Object> get props => [searchnovel];
}
