part of just_google_jwt_verifier.verifiers;

/// iss
TokenVerifier createIssuerVerifier() {
  return (ToVerify toVerify) async {
    var iss = toVerify.jwt.payload['iss'];
    return iss == 'accounts.google.com' || iss == 'https://accounts.google.com';
  };
}
