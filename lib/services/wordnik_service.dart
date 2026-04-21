import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class WordnikService {
  static String get _apiKey => dotenv.env['WORDNIK_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.wordnik.com/v4/words.json/randomWord';
  static const String _definitionBaseUrl = 'https://api.wordnik.com/v4/word.json';

  /// Fetches a random word from Wordnik within the specified length range.
  static Future<String?> getRandomWord({
    required int minLength,
    required int maxLength,
  }) async {
    final url = Uri.parse(
      "https://api.wordnik.com/v4/words.json/randomWord?hasDictionaryDef=true&minLength=$minLength&maxLength=$maxLength&api_key=$_apiKey",
    );

    final response = await http.get(url);

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["word"];
    } else {
      return null;
    }
  }

  /// Fetches the definition of a given word from Wordnik.
  /// Returns the first available definition, or null if not found.
  static Future<String?> getDefinition(String word) async {
    try {
      final uri = Uri.parse(
        '$_definitionBaseUrl/${word.toLowerCase()}/definitions'
            '?limit=1&includeRelated=false&useCanonical=false&includeTags=false&api_key=$_apiKey',
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty && data[0]['text'] != null) {
          // Strip any HTML tags that Wordnik sometimes includes
          String definition = data[0]['text'].toString();
          definition = definition.replaceAll(RegExp(r'<[^>]*>'), '');
          return definition;
        }
        return null;
      } else {
        print('Wordnik Definition Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception fetching definition: $e');
      return null;
    }
  }
}