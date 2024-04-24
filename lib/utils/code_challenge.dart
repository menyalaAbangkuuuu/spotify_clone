import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class CodeData {
  String codeVerifier;
  String codeChallenge;
  CodeData({required this.codeVerifier, required this.codeChallenge});
}

class CodeChallenge {
  // Generates a code challenge from a provided code verifier
  static String _generateCodeChallenge(String codeVerifier) {
    return base64UrlEncode(sha256.convert(utf8.encode(codeVerifier)).bytes);
  }

  // Generates a random string for use as the code verifier
  static String _generateCodeVerifier(int length) {
    var random = Random.secure();
    var values = List<int>.generate(length, (i) => random.nextInt(256));
    return base64UrlEncode(values);
  }

  static CodeData generatePKCECodes(int length) {
    String codeVerifier = _generateCodeVerifier(length);
    String codeChallenge = _generateCodeChallenge(codeVerifier);
    return CodeData(codeVerifier: codeVerifier, codeChallenge: codeChallenge);
  }
}
