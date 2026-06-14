import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/quote.dart';

class QuoteApiService {
  static const _apiUrl = 'https://meigen.doodlenote.net/api/json.php';
  final http.Client _client;

  QuoteApiService([http.Client? client]) : _client = client ?? http.Client();

  Future<Quote> fetchRandomQuote() async {
    return await _fetchQuoteFromUri(Uri.parse(_apiUrl));
  }

  Future<Quote> _fetchQuoteFromUri(Uri uri) async {
    final response = await _client.get(
      uri,
      headers: {
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('名言の取得に失敗しました (${response.statusCode})');
    }

    final body = jsonDecode(response.body);
    if (body is! List || body.isEmpty) {
      throw Exception('APIレスポンスの形式が正しくありません。');
    }

    return Quote.fromJson(body.first as Map<String, dynamic>);
  }
}
