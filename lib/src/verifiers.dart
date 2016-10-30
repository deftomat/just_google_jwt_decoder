library just_google_jwt_verifier.verifiers;

import 'dart:async';
import 'dart:convert';

import 'package:just_jwt/just_jwt.dart';
import 'package:quiver/collection.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' show parseHttpDate;

part 'verifiers/audience.dart';
part 'verifiers/email_verified.dart';
part 'verifiers/expiration.dart';
part 'verifiers/issuer.dart';
part 'verifiers/signature.dart';

TokenVerifier createCombinedVerifier(String clientId,
    {String certificatesUrl: 'https://www.googleapis.com/oauth2/v3/certs',
    Duration expirationTolerance: const Duration(seconds: 30)}) {
  return combineTokenVerifiers([
    createIssuerVerifier(),
    createEmailVerifiedVerifier(),
    createExpirationVerifier(expirationTolerance),
    createAudienceVerifier(clientId),
    createSignatureVerifier(certificatesUrl),
  ]);
}
