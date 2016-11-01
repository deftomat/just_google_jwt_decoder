part of just_google_jwt_decoder.verifier;

/// Returns verifier which verifies
/// if JWT was generated for a client with [clientId].
TokenVerifier audienceVerifier(String clientId) {
  return (ToVerify toVerify) async {
    return toVerify.jwt.payload['aud'] == clientId;
  };
}
