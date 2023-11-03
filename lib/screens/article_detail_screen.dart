import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import '../models/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({super.key, required this.article});

  List<Widget> _buildContentWidgets(String htmlContent) {
    final document = parse(htmlContent);
    final List<Widget> contentWidgets = [];

    void parseNode(dom.Node node) {
      if (node is dom.Element) {
        if (node.localName == 'p') {
          // Añade un Text widget para cada párrafo
          contentWidgets.add(Text(
            node.text,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16.0, height: 1.5), // Ajusta la altura de línea aquí
          ));
          // Añade un SizedBox para controlar el espaciado entre párrafos
          contentWidgets.add(const SizedBox(height: 8.0)); // Ajusta el espacio entre párrafos aquí
        } else if (node.localName == 'img') {
          final imageSrc = node.attributes['src'];
          if (imageSrc != null) {
            contentWidgets.add(Image.network(imageSrc));
          }
        } else {
          node.nodes.forEach(parseNode);
        }
      }
    }

    parseNode(document.body!);

    return contentWidgets;
  }

  @override
  Widget build(BuildContext context) {
    final contentWidgets = _buildContentWidgets(article.content);

    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(article.imageUrl),
              ...contentWidgets,
            ],
          ),
        ),
      ),
    );
  }
}
