// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '../models/article.dart';

// class WordPressService {
//   static Future<List<Article>> fetchArticles() async {
//     final response = await http.get(Uri.parse('https://www.arqueotimes.es/wp-json/wp/v2/posts?_embed'));

//     if (response.statusCode == 200) {
//       List<dynamic> articlesJson = json.decode(response.body);
//       return articlesJson.map((json) => Article.fromJson(json)).toList();
//     } else {
//       throw Exception('Failed to load articles');
//     }
//   }
// }

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class WordPressService {
  static const int _perPage = 20; // Reducir el número de artículos por página puede ayudar
  static const int _timeoutSeconds = 10; // Tiempo de espera para la solicitud

  static Future<List<Article>> fetchArticles({int page = 1}) async {
    final uri = Uri.parse('https://www.arqueotimes.es/wp-json/wp/v2/posts?_embed&per_page=$_perPage&page=$page');
    
    try {
      // Añade un timeout a la solicitud
      final response = await http.get(uri).timeout(Duration(seconds: _timeoutSeconds));

      if (response.statusCode == 200) {
        List<dynamic> articlesJson = json.decode(response.body);
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else if (response.statusCode == 400) {
        // Manejar la paginación completa, donde no hay más páginas para cargar
        return [];
      } else {
        // Maneja otros códigos de estado inesperados
        throw Exception('Failed to load articles with status code: ${response.statusCode}');
      }
    } on http.ClientException {
      // Maneja errores de cliente, como la falta de conexión a internet
      throw Exception('No internet connection or server is not reachable');
    } on Exception catch (e) {
      // Maneja cualquier otro tipo de error
      throw Exception('An error occurred: $e');
    }
  }
}











// class WordPressService {
//   static const String baseUrl = 'https://www.arqueotimes.es/wp-json/wp/v2';

//   static Future<List<Article>> fetchArticles({int page = 1}) async {
//     final response = await http.get(Uri.parse('$baseUrl/posts?page=$page'));

//     if (response.statusCode == 200) {
//       final List<dynamic> articlesJson = json.decode(response.body);
//       return articlesJson.map((json) => Article.fromJson(json)).toList();
//     } else {
//       // Manejar el caso en que la llamada al servidor falló con error
//       throw Exception('Failed to load articles');
//     }
//   }
// }