part of just_google_jwt_decoder.verifier;

/// Returns verifier which verifies if user's email is verified.
TokenVerifier emailVerifiedVerifier() {
  return (ToVerify toVerify) async {
    return toVerify.jwt.payload['email_verified'] == true;
  };
}
