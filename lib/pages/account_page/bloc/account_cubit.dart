import 'package:bloc/bloc.dart';
import 'package:first_app/api/server_api.dart';
import 'package:first_app/utils/app_settings.dart';


enum AccountStatus { idle, uploading, error }

class AccountState {
  final String name;
  final String email;
  final String avatarUrl;
  final String? localAvatar;
  final AccountStatus status;
  final String? error;

  const AccountState({
    this.name = '',
    this.email = '',
    this.avatarUrl = '',
    this.localAvatar,
    this.status = AccountStatus.idle,
    this.error,
  });

  AccountState copyWith({
    String? name, String? email, String? avatarUrl,
    String? localAvatar, AccountStatus? status, String? error,
  }) => AccountState(
    name: name ?? this.name,
    email: email ?? this.email,
    avatarUrl: avatarUrl ?? this.avatarUrl,
    localAvatar: localAvatar,
    status: status ?? this.status,
    error: error,
  );
}


class AccountCubit extends Cubit<AccountState> {
  final ServerApi api;
  final AppSettings settings;

  AccountCubit({required this.api, required this.settings})
      : super(const AccountState()) {
    _loadFromSettings();
  }

  void _loadFromSettings() {
    emit(state.copyWith(
      name: settings.getUserName(),
      email: settings.getUserEmail(),
      avatarUrl: settings.getUserAvatar(),
    ));
  }

  Future<void> uploadAvatar(String path) async {
    emit(state.copyWith(localAvatar: path, status: AccountStatus.uploading, error: null));
    try {
      final String? url = await api.uploadAvatar(path);

      if (url == null || url.isEmpty) {
        throw Exception('Empty URL');
      }

      final bust = 't=${DateTime.now().millisecondsSinceEpoch}';
      final String finalUrl = url.contains('?') ? '$url&$bust' : '$url?$bust';

      await settings.setUserAvatar(finalUrl);

      emit(state.copyWith(
        avatarUrl: finalUrl,
        localAvatar: null,
        status: AccountStatus.idle,
      ));
    } catch (e) {
      emit(state.copyWith(status: AccountStatus.error, error: 'Failed to upload avatar'));
      emit(state.copyWith(status: AccountStatus.idle));
    }
  }


  Future<void> logout() async {
    await settings.logout();
  }
}
