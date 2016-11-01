part of just_google_jwt_decoder.verifier;

/// Returns verifier which verifies if JWT was issued by Google Accounts.
TokenVerifier issuerVerifier() {
  return (ToVerify toVerify) async {
    var iss = toVerify.jwt.payload['iss'];
    return iss == 'accounts.google.com' || iss == 'https://accounts.google.com';
  };
}
