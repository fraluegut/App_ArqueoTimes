// class Article {
//   final String title;
//   final String imageUrl;
//   final String author;
//   final String content;

//   Article({required this.title, required this.imageUrl, required this.author, required this.content});

//   factory Article.fromJson(Map<String, dynamic> json) {
//     return Article(
//       title: json['title']['rendered'],
//       imageUrl: json['_embedded']['wp:featuredmedia'][0]['source_url'],
//       author: json['_embedded']['author'][0]['name'],
//       content: json['content']['rendered'],
//     );
//   }
// }

class Article {
  final String title;
  final String imageUrl;
  final String authorName;  // Podría ser el nombre de usuario o el ID del autor.
  final String content;
  final String displayName; // El nombre para mostrar del coautor.

  Article({
    required this.title,
    required this.imageUrl,
    required this.authorName,
    required this.content,
    required this.displayName,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // Extrae el título.
    final title = json['title']?['rendered'] ?? 'Sin título';

    // Intenta extraer la URL de la imagen.
    final imageList = json['_embedded']?['wp:featuredmedia'] as List?;
    final imageUrl = imageList != null && imageList.isNotEmpty
        ? imageList[0]['source_url'] ?? 'URL predeterminada'
        : 'URL predeterminada';

    // Intenta extraer el nombre de usuario o ID del autor.
    final authorList = json['_embedded']?['author'] as List?;
    final authorName = authorList != null && authorList.isNotEmpty
        ? authorList[0]['name'] ?? 'Autor desconocido'
        : 'Autor desconocido';

    // Intenta extraer el nombre para mostrar del coautor.
    final coauthorsList = json['coauthors'] as List?;
    final displayName = coauthorsList != null && coauthorsList.isNotEmpty
        ? coauthorsList[0]['display_name'] ?? 'Coautor desconocido'
        : 'Coautor desconocido';

    // Extrae el contenido.
    final content = json['content']?['rendered'] ?? 'Sin contenido';

    return Article(
      title: title,
      imageUrl: imageUrl,
      authorName: authorName,
      content: content,
      displayName: displayName,
    );
  }
}
