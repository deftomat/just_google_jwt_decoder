library just_google_jwt_decoder.verifier;

import 'dart:async';
import 'dart:convert';

import 'package:just_jwt/just_jwt.dart';
import 'package:quiver/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show parseHttpDate;

part 'verifier/audience.dart';
part 'verifier/email_verified.dart';
part 'verifier/expiration.dart';
part 'verifier/issuer.dart';
part 'verifier/signature.dart';

/// Returns verifier which verifies the Google JWT.
TokenVerifier googleJwtVerifier(String clientId, {Duration expirationTolerance}) {
  return combineTokenVerifiers([
    issuerVerifier(),
    emailVerifiedVerifier(),
    expirationVerifier(expirationTolerance),
    audienceVerifier(clientId),
    signatureVerifier(),
  ]);
}
