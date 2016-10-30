part of just_google_jwt_verifier.verifiers;

/// aud
TokenVerifier createAudienceVerifier(String clientId) {
  return (ToVerify toVerify) async {
    return toVerify.jwt.payload['aud'] == clientId;
  };
}
