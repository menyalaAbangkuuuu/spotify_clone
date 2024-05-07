import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials {
  static String? clientId = dotenv.env["CLIENT_ID"];
  static String? clientSecret = dotenv.env["CLIENT_SECRET"];
  static String? token =
      "AQAsAFbPcU0Ahb3h-xxLKFMkatYCApX_zIsenPZ1OYFRW9cUAZuTg5RrzCjje3cgETR0H1VqiZBnz8Mrk1c5AI7mGmc7HXoaVdpInc4q9DSoqIxg3UUAPHlXCTgTWyw4ZFJgbLKOflIO9OVVcIc0fnwEo_sDI6-0347evAX1ekKGnbv0qgzRoOCo8rNlGXG0MvG_BxOv1tolNMsMlUIuFlpoO6xD";
}
