import 'dart:convert';
import 'package:http/http.dart' as http;

final url = Uri.https('chatgptflutterandpython.herokuapp.com', '/');
Future<String?> say() async {
  try {
    final response = await http.get(
      url,
      // headers: {'Content-Type': 'application/json'},
      // body: jsonEncode({'name': name}),
    );

    if (response.statusCode == 200) {
      Map resp = json.decode(utf8.decode(response.bodyBytes));
      print(resp['resposta'][0]);
      return resp['resposta'][0];
    } else {
      throw Exception('Failed to say response: ${response.statusCode}');
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}

Future<String?> saypost(String pergunta) async {
  final myJson = {'pergunta': pergunta};
  try {
    final response = await http.post(
      Uri.parse('https://chatgptflutterandpython.herokuapp.com/prompt/'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(myJson),
    );

    if (response.statusCode == 200) {
      Map resp = json.decode(utf8.decode(response.bodyBytes));
      return resp['resposta'][0];
    } else {
      throw Exception('Failed to say response: ${response.statusCode}');
    }
  } catch (e) {
    print(e.toString());
  }
  return null;
}
