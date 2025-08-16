import 'package:flutter/material.dart';
import 'package:recetas_app/models/flutter_models.dart';
import 'package:recetas_app/services/services.dart';

class PageCreateRecipe extends StatefulWidget {
  const PageCreateRecipe({super.key});

  @override
  State<PageCreateRecipe> createState() => _PageCreateRecipeState();
}

class _PageCreateRecipeState extends State<PageCreateRecipe> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey dropdownKey = GlobalKey();
  final GlobalKey dropdownKeyIngregients = GlobalKey();
  int _selectedIndex = 0;
  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController prepMinutes = TextEditingController();
  TextEditingController cookMinutes = TextEditingController();
  TextEditingController servings = TextEditingController();
  TextEditingController difficulty = TextEditingController();
  TextEditingController isPublic = TextEditingController();
  TextEditingController calories = TextEditingController();

  Map<int, TextEditingController> quantityControllers = {};
  Map<int, TextEditingController> unitControllers = {};
  Map<int, TextEditingController> noteControllers = {};

  Map<int, TextEditingController> stepControllers = {};
  // lista de ingredientes seleccionados en la lista de ingredientes>
  List<RecipeStep> recipeSteps = [];

  List<Category> categories = [];
  List<int> selectedCategories = [];
  Map<int, String> categoryMap = {};

  List<Ingredient> ingredients = [];
  List<int> selectedIngredients = [];
  List<RecipeIngredient> recipeIngredients = [];
  Map<int, String> ingredientMap = {};

  List<int> steps = [];

  int stepCounter = 1;
  int? ingredientValue;

  int? categoryValue;

  @override
  void dispose() {
    title.dispose();
    description.dispose();
    prepMinutes.dispose();
    cookMinutes.dispose();
    servings.dispose();
    difficulty.dispose();
    isPublic.dispose();
    calories.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _getIngredients();
    _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Recetas'),
        backgroundColor: Colors.orange[600],
        foregroundColor: Colors.white,
      ),
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
                Navigator.pushNamed(context, '/create-recipe'); // cierra el drawer
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
            if (_selectedIndex == 0) {
              Navigator.popAndPushNamed(context, '/recipes');
            }
            print(_selectedIndex);
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
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _textField(title, 'Titulo', Icons.title),
            _textField(description, 'Descripcion', Icons.description),
            _textField(prepMinutes, 'Tiempo de preparacion', Icons.timer),
            _textField(cookMinutes, 'Tiempo de coccion', Icons.timer),
            _textField(servings, 'Porciones', Icons.person),
            _difficultyDropdown(),
            _categoriesDropdown(),
            _ingredientsDropdown(),
            _setps(),
          ],
        ),
      ),
    );
  }

  // Widget helper para no repetir código
  Widget _textField(TextEditingController controller, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon),
          labelText: label,
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Este campo es obligatorio";
          }
          return null;
        },
      ),
    );
  }

  Widget _difficultyDropdown() {
    final Map<String, String> dificultadMap = {'Fácil': 'easy', 'Medio': 'medium', 'Difícil': 'hard'};

    String? selectedValue; // No tiene valor al inicio

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          icon: Icon(Icons.star),
          labelText: 'Dificultad',
          fillColor: Colors.white,
          filled: true,
        ),
        hint: Text('Seleccione dificultad'),
        items: dificultadMap.keys.map((spanish) => DropdownMenuItem(value: spanish, child: Text(spanish))).toList(),
        onChanged: (spanish) {
          if (spanish == null) return;
          setState(() {
            selectedValue = spanish;
            difficulty.text = dificultadMap[spanish]!; // Guardamos el valor real
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Este campo es obligatorio";
          }
          return null;
        },
      ),
    );
  }

  Widget _categoriesDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.category),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: categoryValue,
                  key: dropdownKey,

                  hint: Row(children: [Text('Seleccione una categoría')]),
                  items: categories
                      .map((category) => DropdownMenuItem<int>(value: category.id, child: Text(category.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      categoryValue = value;
                    });
                  },
                ),
              ),
              IconButton(
                tooltip: 'Agregar categoría',
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  // Repetimos la acción del dropdown
                  if (categoryValue != null && !selectedCategories.contains(categoryValue)) {
                    setState(() {
                      selectedCategories.add(categoryValue!);
                      final selectedCategory = categories.firstWhere((cat) => cat.id == categoryValue);
                      categoryMap[selectedCategory.id] = selectedCategory.name;
                    });
                  } else {
                    if (categoryValue != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Error'),
                          content: Text('La categoría ya ha sido seleccionada'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Aceptar'))],
                        ),
                      );
                    }
                  }
                  categoryValue = null;
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Mostrar la lista de categorías seleccionadas
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedCategories.map((id) {
              final name = categoryMap[id] ?? '';
              return Chip(
                label: Text(name),
                backgroundColor: Colors.orange[100],
                deleteIcon: Icon(Icons.close, size: 16),
                onDeleted: () {
                  setState(() {
                    selectedCategories.remove(id);
                    categoryMap.remove(id);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _ingredientsDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<int>(
                  value: ingredientValue,
                  key: dropdownKeyIngregients,
                  hint: Text(
                    ingredientValue != null
                        ? ingredients.firstWhere((ing) => ing.id == ingredientValue).name
                        : 'Seleccione un ingrediente',
                  ),
                  items: ingredients
                      .map((ingredient) => DropdownMenuItem<int>(value: ingredient.id, child: Text(ingredient.name)))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      ingredientValue = value;
                    });
                  },
                ),
              ),
              IconButton(
                tooltip: 'Agregar ingrediente',
                icon: Icon(Icons.add_circle_outline, color: Colors.green),
                onPressed: () {
                  if (ingredientValue != null && !selectedIngredients.contains(ingredientValue)) {
                    setState(() {
                      selectedIngredients.add(ingredientValue!);
                      final selectedIngredient = ingredients.firstWhere((ing) => ing.id == ingredientValue);
                      ingredientMap[selectedIngredient.id] = selectedIngredient.name;
                      quantityControllers[selectedIngredient.id] = TextEditingController();
                      unitControllers[selectedIngredient.id] = TextEditingController();
                      noteControllers[selectedIngredient.id] = TextEditingController();
                      ingredientValue = null;
                    });
                  } else {
                    if (ingredientValue != null) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          icon: Icon(Icons.info,size: 40,),
                          content: Text('El ingrediente ya ha sido seleccionado'),
                          actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('Aceptar'))],
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Mostrar ingredientes seleccionados
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: selectedIngredients.map((id) {
              final name = ingredientMap[id] ?? '';

              return Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: Colors.orange[100]),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(name),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 50,
                      height: 30,
                      child: TextField(
                        controller: quantityControllers[id],
                        decoration: InputDecoration(
                          hintText: 'Cant',
                          border: OutlineInputBorder(),

                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          //cant.text = value;
                          //     print('Ingrediente $id → cantidad: ${cant.text}');
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: TextField(
                        controller: unitControllers[id],
                        decoration: InputDecoration(
                          hintText: 'Unidad',
                          border: OutlineInputBorder(),

                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 80,
                      height: 30,
                      child: TextField(
                        controller: noteControllers[id],
                        decoration: InputDecoration(
                          hintText: 'nota',
                          border: OutlineInputBorder(),

                          contentPadding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.close, size: 16),
                      onPressed: () {
                        setState(() {
                          selectedIngredients.remove(id);
                          ingredientMap.remove(id);
                        });
                      },
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _setps() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón para agregar nuevo paso
        ElevatedButton.icon(
          onPressed: () {
            setState(() {
              steps.add(stepCounter);
              stepControllers[stepCounter] = TextEditingController();
              stepCounter++;
            });
          },
          icon: Icon(Icons.add),
          label: Text("Agregar paso"),
        ),
        const SizedBox(height: 12),

        // Lista de pasos
        Column(
          children: steps.map((id) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Número del paso
                  Text("$id. ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  // TextField del paso
                  Expanded(
                    child: TextField(
                      controller: stepControllers[id],
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Escriba lo que se hará en este paso",
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      ),
                    ),
                  ),
                  // Botón eliminar
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        steps.remove(id);
                        stepControllers[id]?.dispose();
                        stepControllers.remove(id);
                         stepCounter--;
                      });
                      
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Botón para imprimir pasos (ejemplo de uso)
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              recipeSteps = [];
              for (var id in steps) {
                final text = stepControllers[id]?.text.trim() ?? '';
                if (text.isNotEmpty) {
                  recipeSteps.add(
                    RecipeStep(
                      stepNumber: steps.indexOf(id) + 1,
                      instruction: text,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                }
              }
              recipeIngredients.clear();

              for (var id in selectedIngredients) {
                recipeIngredients.add(
                  RecipeIngredient(
                    ingredientId: id,
                    quantity: int.tryParse(quantityControllers[id]?.text ?? '0') ?? 0,
                    unit: unitControllers[id]?.text ?? '',
                    note: noteControllers[id]?.text ?? '',
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                );
              }
              //   print(selectedCategories);
              _createRecipe(context);
            }
            //print("Ingredientes de la receta: ${recipeIngredients[0].ingredientId} ");
            //print("Pasos de la receta: $recipeSteps");
          },
          child: Text("Guardar / Ver pasos en consola"),
        ),
      ],
    );
  }

  //Conexion de apis

  Future<void> _getCategories() async {
    final response = await ApiService.getCategories();
    if (response.success) {
      setState(() => categories = response.data!);
      /* print('✅ Categorías obtenidas: ${response.data!.length}');

      for (final category in response.data!) {
        print('🏷️ ${category.name} (${category.slug})');
      }*/
    } else {
      print('❌ Error: ${response.message}');
    }
  }

  Future<void> _getIngredients() async {
    // Buscar ingredientes
    final response = await ApiService.getIngredients();

    if (response.success) {
      setState(() => ingredients = response.data!);
    } else {
      print('❌ Error: ${response.message}');
    }
  }

  Future<void> _createRecipe(context) async {
    final recipeData = {
      'title': title.text,
      'description': description.text,
      'prep_minutes': int.tryParse(prepMinutes.text) ?? 0,
      'cook_minutes': int.tryParse(cookMinutes.text) ?? 0,
      'servings': int.tryParse(servings.text) ?? 1,
      'difficulty': difficulty.text,
      'calories': 100, // <- agregado
      'is_public': true,
      'categories': selectedCategories,
      'ingredients': recipeIngredients.map((e) => e.toJson()).toList(),
      'steps': recipeSteps.map((e) => e.toJson()).toList(),
    };

    final response = await ApiService.createRecipe(recipeData);

    if (response.success) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Receta creada exitosamente!'),
          actions: [
            TextButton(onPressed: () => Navigator.popAndPushNamed(context, '/recipes'), child: Text('Aceptar')),
          ],
        ),
      );
    } else {
      print('❌ Error: ${response.message}');
      if (response.errors != null) {
        print('📝 Errores: ${response.errors}');
      }
    }
  }
}
