import 'package:flutter/material.dart';
import 'package:recetas_app/pages/page_create_recipe.dart';
import 'package:recetas_app/pages/page_create_user.dart';
import 'package:recetas_app/pages/page_login.dart';
import 'package:recetas_app/pages/page_recipes.dart';

void main() {
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas',
      home: Login(),
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/recipes': (context) => Recipes(),
        '/create-recipe': (context) => PageCreateRecipe(),
      },
    );
  }
}
