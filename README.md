# Just Google JWT decoder

A simple Google JWT decoder library for Dart with all necessary verifiers.

## Usage

```dart
import 'package:just_google_jwt_decoder/just_google_jwt_decoder.dart';

main() async {
  var clientId = '<CLIENT_ID>';
  var decoder = new GoogleJwtDecoder(clientId, expirationTolerance: const Duration(seconds: 30));
  
  var encodedJwt = new EncodedJwt('<HEADER.PAYLOAD.SIGNATURE>');
  var jwt = await decoder.convert(encodedJwt);
  
  print(jwt.payload);
}
```

## Verification

Library verifies following data:
 - If issuer is Google Accounts server
 - If user's email is verified
 - If JWT not expires
 - If audience is equal to Client ID
 - If signature is valid (automatically downloads certificates from Google servers and keep them in memory until they expires).
 
## Get Google JWT

You can obtain a Google JWT (a.k.a. *idToken*) with [just_google_signin](https://github.com/deftomat/just_google_signin) library.
