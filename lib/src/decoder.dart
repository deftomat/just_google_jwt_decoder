library just_google_jwt_decoder.decoder;

import 'package:just_jwt/just_jwt.dart';

import 'verifier.dart';

/// Converter capable of decode the encoded Google JWT.
///
/// Decoding process involves all necessary verifications.
class GoogleJwtDecoder extends Decoder {
  GoogleJwtDecoder(String clientId, {Duration expirationTolerance})
      : super(composeTokenVerifiers(
          {'RS256': googleJwtVerifier(clientId, expirationTolerance: expirationTolerance)}));
}
