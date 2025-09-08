import 'package:bloc/bloc.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';

enum LoginStatus { initial, loading, success, failure }

class LoginState {
  final LoginStatus status;
  final String? errorMessage;

  const LoginState({this.status = LoginStatus.initial, this.errorMessage});

  LoginState copyWith({LoginStatus? status, String? errorMessage}) =>
      LoginState(
        status: status ?? this.status,
        errorMessage: errorMessage,
      );
}

class LoginCubit extends Cubit<LoginState> {
  final ServerApi api;
  final AppSettings settings;

  LoginCubit({
    required this.api,
    required this.settings,
  }) : super(const LoginState());

  Future<void> submit(String email, String password) async {
    emit(state.copyWith(status: LoginStatus.loading, errorMessage: null));
    try {
      final res = await api.login(login: email, password: password);

      if (res.isSuccess) {
        await settings.saveToken(res.token);
        await settings.saveUserEmail(res.userEmail);
        await settings.saveUserName(res.userDisplayName);

        emit(state.copyWith(status: LoginStatus.success));
      } else {
        emit(state.copyWith(
          status: LoginStatus.failure,
          errorMessage: res.message.isEmpty ? 'Login failed' : res.message,
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Login error: $e',
      ));
    }
  }

  void reset() => emit(const LoginState());
}
