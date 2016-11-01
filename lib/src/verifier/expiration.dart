part of just_google_jwt_decoder.verifier;

/// Returns verifier which verifies if JWT not expires.
TokenVerifier expirationVerifier(Duration tolerance) {
  return (ToVerify toVerify) async {
    var now = new DateTime.now();
    var exp = toVerify.jwt.payload['exp'];

    tolerance ??= const Duration();

    return exp > now.subtract(tolerance).millisecondsSinceEpoch ~/ 1000;
  };
}
