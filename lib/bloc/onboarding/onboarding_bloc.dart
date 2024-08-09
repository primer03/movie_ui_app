import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(OnboardingInitial(pageIndex: 0)) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingCompleted>(_onboardingCompleted);
  }

  void _onPageChanged(
      OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(OnboardingPageChange(pageIndex: event.pageIndex));
  }

  void _onboardingCompleted(
      OnboardingCompleted event, Emitter<OnboardingState> emit) {
    emit(OnboardingComplete(
        isCompleted: event.isCompleted, pageIndex: state.pageIndex));
  }
}
