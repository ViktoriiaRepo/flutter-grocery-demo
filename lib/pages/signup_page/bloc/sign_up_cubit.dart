import 'package:bloc/bloc.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';

enum SignUpStatus { initial, loading, success, failure }

class SignUpState {
  final SignUpStatus status;
  final String? errorMessage;

  const SignUpState({this.status = SignUpStatus.initial, this.errorMessage});

  SignUpState copyWith({SignUpStatus? status, String? errorMessage}) =>
      SignUpState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

class SignUpCubit extends Cubit<SignUpState> {
  final ServerApi api;
  final AppSettings settings;

  SignUpCubit({
    required this.api,
    required this.settings,
  }) : super(const SignUpState());

  Future<void> submit(String username, String email, String password) async {
    emit(state.copyWith(status: SignUpStatus.loading, errorMessage: null));
    try {
      final res = await api.register(
        username: username,
        email: email,
        password: password,
      );

      if (res.isSuccess) {
        await settings.saveToken(res.token);
        await settings.saveUserEmail(res.userEmail);
        await settings.saveUserName(res.userDisplayName);

        emit(state.copyWith(status: SignUpStatus.success));
      } else {
        emit(state.copyWith(
          status: SignUpStatus.failure,
          errorMessage: res.message.isEmpty ? 'Registration failed' : res.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: SignUpStatus.failure,
        errorMessage: 'Registration error: $e',
      ));
    }
  }

  void reset() => emit(const SignUpState());
}
