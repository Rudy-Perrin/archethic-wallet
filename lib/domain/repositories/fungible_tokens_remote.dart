import 'package:aewallet/domain/models/core/failures.dart';
import 'package:aewallet/domain/models/core/result.dart';
import 'package:aewallet/domain/models/account_token.dart';

abstract class FungibleTokensRemoteRepositoryInterface {
  Future<Result<List<AccountToken>, Failure>> getFungibleTokens({
    required String accountLastTransactionAddress,
  });
}
