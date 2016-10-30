part of just_google_jwt_verifier.verifiers;

DateTime certsExpires;
List<Map> certs;

TokenVerifier createSignatureVerifier(String certificatesUrl) {
  LruMap<String, TokenVerifier> tokenVerifiers = new LruMap(maximumSize: 15);

  findCertificate(String kid) {
    var cert = certs?.firstWhere((cert) => cert['kid'] == kid);
    return cert ?? (throw new Exception('Invalid kid'));
  }

  create(String kid) async {
    var cert;
    try {
      cert = findCertificate(kid);
    } on Exception {
      var now = new DateTime.now();
      if (certsExpires == null || now.millisecondsSinceEpoch >= certsExpires.millisecondsSinceEpoch) {
        certs = await _fetchCertificates(certificatesUrl);
      }

      cert = findCertificate(kid);
    }

    return _toRS256TokenVerifier(cert);
  }

  return (ToVerify toVerify) async {
    var kid = toVerify.jwt.header['kid'];
    var tokenVerifier = tokenVerifiers[kid] ??= await create(kid);

    return tokenVerifier(toVerify);
  };
}

Future<List<Map>> _fetchCertificates(String url) async {
  print('fetching...');
  var response = await http.get(url);
  certsExpires = parseHttpDate(response.headers['expires']);
  return JSON.decode(response.body)['keys'];
}

TokenVerifier _toRS256TokenVerifier(Map cert) {
  var modulus = _normalizeBASE64(cert['n']);
  var exponent = _normalizeBASE64(cert['e']);
  var verifier = createJwaRS256Verifier(modulus, exponent);

  return toTokenVerifier(verifier);
}

String _normalizeBASE64(String encoded) {
  var reminder = encoded.length % 4;
  var normalizedLength = encoded.length + (reminder == 0 ? 0 : 4 - reminder);

  return encoded.padRight(normalizedLength, '=');
}
