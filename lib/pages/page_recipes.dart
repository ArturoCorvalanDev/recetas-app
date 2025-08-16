import 'package:flutter/material.dart';
import 'package:recetas_app/models/flutter_models.dart';
import 'package:recetas_app/services/services.dart';

class Recipes extends StatefulWidget {
  const Recipes({super.key});

  @override
  State<Recipes> createState() => _RecipesState();
}

class _RecipesState extends State<Recipes> {
  List<Recipe> recipes = [];
  bool _loading = true;
  int _selectedIndex = 0;
  @override
  void initState() {
    super.initState();
    getRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas'), backgroundColor: Colors.orange[600], foregroundColor: Colors.white),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero, // para que no tenga padding superior
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.orange),
              child: Text('Menú', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(          
              leading: Icon(Icons.create),
              title: Text('agregar Receta'),
              onTap: () {
                Navigator.pushNamed(context, '/create-recipe');// cierra el drawer
                // aquí puedes navegar a otra pantalla
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favoritos'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _cuerpo(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex, // índice del botón seleccionado
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favoritos'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _cuerpo() {
    if (_loading) return Center(child: CircularProgressIndicator());
    if (recipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No hay recetas disponibles', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columnas
        crossAxisSpacing: 16, // Espacio horizontal entre cards
        mainAxisSpacing: 16, // Espacio vertical entre cards
        childAspectRatio: 0.6, // Proporción alto/ancho de cada card
      ),
      itemCount: recipes.length,
      itemBuilder: (context, index) {
        final recipe = recipes[index];
        return _buildRecipeCard(recipe);
      },
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          // Navegar al detalle de la receta
          print('Tocaste: ${recipe.totalTime}');
        },
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la receta
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  color: Colors.grey[200],
                ),
                child: (recipe.photos?.isNotEmpty ?? false)
                    ? ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          recipe.photos!.first.path,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.restaurant, size: 40, color: Colors.grey[600]),
                            );
                          },
                        ),
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.restaurant, size: 40, color: Colors.grey[600]),
                      ),
              ),
            ),

            // Contenido de la card
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título
                    Text(
                      recipe.title,

                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Dentro de _buildRecipeCard, después del título
                    const SizedBox(height: 4),

                    if (recipe.categories?.isNotEmpty ?? false)
                      Wrap(
                        children: recipe.categories!.take(2).map((category) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.orange[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(category.name, style: TextStyle(fontSize: 10, color: Colors.orange[800])),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 4),
                    // Usuario
                    Text(
                      'Por ${recipe.user?.name ?? 'Anónimo'}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const Spacer(),

                    // Información adicional
                    Row(
                      children: [
                        // Tiempo
                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text('${recipe.totalTime} min', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        const Spacer(),
                        //calorias
                        if (recipe.calories != null) ...[
                          Icon(Icons.local_fire_department, size: 14, color: Colors.red[600]),
                          const SizedBox(width: 4),
                          Text('${recipe.calories} cal', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],

                        const Spacer(),
                        // Favoritos
                        if (recipe.favoritesCount != null) ...[
                          Icon(Icons.favorite, size: 14, color: Colors.red[600]),
                          const SizedBox(width: 2),
                          Text(
                            (recipe.favoritesCount ?? 0).toString(),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],

                        // Dificultad
                        const Spacer(),

                        // Rating
                        /*if ((recipe.averageRating ?? 0) > 0) ...[
                          Icon(Icons.star, size: 14, color: Colors.amber[600]),
                          const SizedBox(width: 2),
                          Text(
                            (recipe.averageRating ?? 0).toStringAsFixed(1),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],*/
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getRecipes() async {
    setState(() => _loading = true);

    // print('🔗 Intentando conectar a la API...');

    try {
      final response = await ApiService.getRecipes();
      //  print('�� Respuesta recibida: ${response.success}');
      // print('📄 Mensaje: ${response.message}');

      if (response.success) {
        setState(() {
          recipes = response.data!;
          _loading = false;
        });
        // print('✅ Recetas cargadas: ${recipes.length}');
      } else {
        setState(() => _loading = false);
        //print('❌ Error: ${response.message}');
      }
    } catch (e) {
      setState(() => _loading = false);
      //  print('�� Excepción: $e');
    }
  }
}
