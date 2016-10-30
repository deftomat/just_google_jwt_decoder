part of just_google_jwt_verifier.verifiers;

/// email_verified
TokenVerifier createEmailVerifiedVerifier() {
  return (ToVerify toVerify) async {
    return toVerify.jwt.payload['email_verified'] == true;
  };
}
