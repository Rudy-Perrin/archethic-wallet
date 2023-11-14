import 'package:aewallet/domain/models/global_app.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

@immutable
abstract class Session {
  const factory Session.loggedIn({
    required GlobalApp globalApp,
  }) = LoggedInSession;

  const factory Session.loggedOut() = LoggedOutSession;

  bool get isLoggedIn;
  LoggedInSession? get loggedIn;
  bool get isLoggedOut;
  LoggedOutSession? get loggedOut;
}

class LoggedInSession implements Session {
  const LoggedInSession({
    required this.globalApp,
  });

  final GlobalApp globalApp;

  @override
  LoggedInSession? get loggedIn => this;

  @override
  LoggedOutSession? get loggedOut => null;

  @override
  bool get isLoggedIn => true;

  @override
  bool get isLoggedOut => false;
}

class LoggedOutSession implements Session {
  const LoggedOutSession();

  @override
  LoggedInSession? get loggedIn => null;

  @override
  LoggedOutSession? get loggedOut => this;

  @override
  bool get isLoggedIn => false;

  @override
  bool get isLoggedOut => true;
}
