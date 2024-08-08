import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'page_event.dart';
part 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(PageInitial(tabIndex: 0)) {
    on<PageChanged>(_onPageChanged);
    on<PageScroll>(_onPageScroll);
  }

  void _onPageChanged(PageChanged event, Emitter<PageState> emit) {
    print('PageChanged: ${event.tabIndex}');
    emit(PageInitial(tabIndex: event.tabIndex));
  }

  void _onPageScroll(PageScroll event, Emitter<PageState> emit) {
    print('PageScroll: ${event.isScrolling}');
    bool showAppBar = event.isScrolling;
    emit(ScrollPage(
      tabIndex: state.tabIndex,
      isScrolling: event.isScrolling,
      showAppBar: showAppBar,
    ));
  }
}
