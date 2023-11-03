import 'package:flutter/material.dart';
import 'articles_list_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 189, 143, 58),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Ajusta el tamaño del logo aquí
            Image.asset(
              'assets/images/logo.png',
              width: 150, // Establece el ancho deseado para el logo
              height: 150, // Establece la altura deseada para el logo
            ),
            SizedBox(height: 24), // Espacio entre el logo y el texto
            ElevatedButton(
              child: Text('Artículos'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArticlesListScreen()),
                );
              },
            ),
            // Aquí puedes agregar más widgets si es necesario
          ],
        ),
      ),
    );
  }
}
