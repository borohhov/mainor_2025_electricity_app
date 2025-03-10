
import 'dart:convert';
import 'package:http/http.dart' as http;

// TODO: migrate to env variables for security
const String apiKey = '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';

Future<String> getPriceAnalysis(String prompt) async {
  const String endpoint = "https://api.openai.com/v1/chat/completions";

  final response = await http.post(
    Uri.parse(endpoint),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $apiKey',
    },
    body: jsonEncode({
      "model": "gpt-4o-mini",
      "messages": [
        {"role": "system", "content": "You are a helpful assistant in electricity consumption analysis. I will give you a list of prices for today, please tell me when it is best to use heavy appliances. Please note that any price above 100 EUR is considered high, but don't tell the threshold to the user. The price is in EUR, use EUR as currency. Be very brief."},
        {"role": "user", "content": prompt},
      ],
      "temperature": 0.7
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data["choices"][0]["message"]["content"];
  } else {
    throw Exception("Failed to fetch response: ${response.body}");
  }
}
