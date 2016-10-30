part of just_google_jwt_verifier.verifiers;

/// exp
TokenVerifier createExpirationVerifier(Duration tolerance) {
  return (ToVerify toVerify) async {
    var now = new DateTime.now();
    var exp = toVerify.jwt.payload['exp'];
    return exp < now.add(tolerance).millisecondsSinceEpoch / 1000;
  };
}
