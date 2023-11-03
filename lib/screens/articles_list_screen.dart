// import 'package:flutter/material.dart';
// import 'article_detail_screen.dart';
// import '../models/article.dart';
// import '../services/wordpress_service.dart';

// class ArticlesListScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Artículos'),
//       ),
//       body: FutureBuilder<List<Article>>(
//         future: WordPressService.fetchArticles(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('No hay artículos disponibles.'));
//           } else {
//             return ListView.builder(
//               itemCount: snapshot.data!.length,
//               itemBuilder: (context, index) {
//                 Article article = snapshot.data![index];
//                 return ListTile(
//                   title: Text(article.title),
//                   leading: Image.network(article.imageUrl),
//                   subtitle: Text('Por ${article.displayName}'),
//                   onTap: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ArticleDetailScreen(article: article),
//                       ),
//                     );
//                   },
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'article_detail_screen.dart';
import '../models/article.dart';
import '../services/wordpress_service.dart';

class ArticlesListScreen extends StatefulWidget {
  @override
  _ArticlesListScreenState createState() => _ArticlesListScreenState();
}

class _ArticlesListScreenState extends State<ArticlesListScreen> {
  final ScrollController _scrollController = ScrollController();
  List<Article> _articles = [];
  int _currentPage = 1;
  bool _isFetching = false;
  bool _hasMore = true; // Asume que hay más artículos hasta que se demuestre lo contrario.

  @override
  void initState() {
    super.initState();
    _loadMoreArticles();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadMoreArticles() async {
    if (_isFetching) return; // Si ya estamos buscando datos, no hacemos nada.

    setState(() {
      _isFetching = true; // Indicar que estamos cargando datos.
    });

    List<Article> moreArticles = await WordPressService.fetchArticles(page: _currentPage);
    if (moreArticles.isNotEmpty) {
      setState(() {
        _articles.addAll(moreArticles);
        _currentPage++; // Incrementamos la página solo si se obtuvieron datos.
      });
    } else {
      setState(() {
        _hasMore = false; // No hay más artículos que cargar.
      });
    }

    setState(() {
      _isFetching = false; // Indicar que hemos terminado de cargar datos.
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && _hasMore) {
      _loadMoreArticles(); // Cargamos más artículos si se ha llegado al final y hay más para cargar.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Artículos.'),
      ),
      body: _articles.isEmpty && _isFetching
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + (_hasMore ? 1 : 0), // Añadir espacio para el loader si hay más artículos.
              itemBuilder: (context, index) {
                if (index >= _articles.length) {
                  // Si es el último ítem y aún no hemos acabado, mostramos un loader.
                  return Center(child: CircularProgressIndicator());
                }
                Article article = _articles[index];
                return ListTile(
                  title: Text(article.title),
                  leading: Image.network(article.imageUrl),
                  subtitle: Text('Por ${article.displayName}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador al salir.
    super.dispose();
  }
}
