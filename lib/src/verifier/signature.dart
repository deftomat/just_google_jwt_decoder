part of just_google_jwt_decoder.verifier;

/// Returns verifier which verifies JWT's signature.
TokenVerifier signatureVerifier({String certificatesUrl: 'https://www.googleapis.com/oauth2/v3/certs'}) {
  LruMap<String, TokenVerifier> tokenVerifiers = new LruMap(maximumSize: 10);
  _Certificates certificates;

  Future<TokenVerifier> createTokenVerifier(String kid) async {
    if (certificates == null || certificates.expired) {
      certificates = await _fetchCertificates(certificatesUrl);
    }

    var cert = certificates.certificate(kid);
    return _toRS256TokenVerifier(cert);
  }

  return (ToVerify toVerify) async {
    var kid = toVerify.jwt.header['kid'];
    var tokenVerifier = tokenVerifiers[kid] ??= await createTokenVerifier(kid);

    return tokenVerifier(toVerify);
  };
}

Future<_Certificates> _fetchCertificates(String url) async {
  print('fetching...');
  var response = await http.get(url);

  var certificates = JSON.decode(response.body)['keys'];
  var expires = parseHttpDate(response.headers['expires']);

  return new _Certificates(certificates, expires);
}

class _Certificates {
  final List<Map> _certificates;
  final DateTime expires;

  _Certificates(this._certificates, this.expires);

  bool get expired {
    var now = new DateTime.now();
    return now.millisecondsSinceEpoch >= expires.millisecondsSinceEpoch;
  }

  Map certificate(String kid) {
    return _certificates.firstWhere(
        (cert) => cert['kid'] == kid,
        orElse: () => throw new Exception('KID not found!'));
  }
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
