import 'package:flutter_dotenv/flutter_dotenv.dart';

class Credentials {
  static String? clientId = dotenv.env["CLIENT_ID"];
  static String? clientSecret = dotenv.env["CLIENT_SECRET"];
  static String? token =
      "AQATJ-jxe4xlvkZ1iPcYk27OU4nZkBary9YyT7fuqLQ2TrubAjnfRU8-UhNmZl3BBvONibcNC2zQLhjT0oSNq_qoHi9LzPQrBD33v7RdHxRwqANAVs1e_NUrBKWFNYX5vohlPP4_O0iVGG7oqyH2IpHgzDwSdvQRzcjQ2hMCzzQ_uks8n_B6KF2rM58Po-K8lwC6UJauh10kYDtkj6nOdfAbJ2s";
}
