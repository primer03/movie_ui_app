import 'package:bloc/bloc.dart';
import 'package:bloctest/repositories/user_repository.dart';
import 'package:equatable/equatable.dart';

part 'changeemail_event.dart';
part 'changeemail_state.dart';

class ChangeemailBloc extends Bloc<ChangeemailEvent, ChangeemailState> {
  ChangeemailBloc() : super(ChangeemailInitial()) {
    on<ChangeEmail>(_onChangeEmail);
  }
  UserRepository userRepository = UserRepository();

  void _onChangeEmail(ChangeEmail event, Emitter<ChangeemailState> emit) async {
    emit(ChangeemailLoading());
    try {
      final response = await userRepository.changeEmail(
        newEmail: event.newEmail,
        oldEmail: event.oldEmail,
      );
      emit(ChangeemailSuccess(message: response));
    } catch (e) {
      emit(ChangeemailFailure(error: e.toString()));
    }
  }
}
