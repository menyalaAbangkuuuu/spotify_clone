import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials {
  static String? clientId = dotenv.env["CLIENT_ID"];
  static String? clientSecret = dotenv.env["CLIENT_SECRET"];
}
