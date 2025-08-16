// Servicio HTTP para consumir la API de Recetas
// Basado en la API de Laravel

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:recetas_app/models/flutter_models.dart';

class ApiService {
  // Configuración - URLs para diferentes entornos
  static String get baseUrl {
    // Para Android Emulator
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api/v1';
    }
    // Para iOS Simulator o Web
    else if (Platform.isIOS) {
      return 'http://localhost:8000/api/v1';
    }
    // Para dispositivos físicos (cambiar por tu IP local)
    else {
      return 'http://192.168.1.100:8000/api/v1'; // Cambiar por tu IP real
    }
  }

  static String? authToken;

  // Headers comunes
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (authToken != null) 'Authorization': 'Bearer $authToken',
  };

  // ========================================
  // AUTENTICACIÓN
  // ========================================

  /// Registro de usuario
  static Future<ApiResponse<AuthResponse>> register(RegisterRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final authResponse = AuthResponse.fromJson(data['data']);
        authToken = authResponse.token;
        return ApiResponse<AuthResponse>(success: true, message: data['message'], data: authResponse);
      } else {
        return ApiResponse<AuthResponse>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<AuthResponse>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Login de usuario
  static Future<ApiResponse<AuthResponse>> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: _headers,
        body: jsonEncode(request.toJson()),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(data['data']);
        authToken = authResponse.token;
        return ApiResponse<AuthResponse>(success: true, message: data['message'], data: authResponse);
      } else {
        return ApiResponse<AuthResponse>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<AuthResponse>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Logout de usuario
  static Future<ApiResponse<void>> logout() async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/logout'), headers: _headers);

      if (response.statusCode == 200) {
        authToken = null;
        return ApiResponse<void>(success: true, message: 'Logout exitoso');
      } else {
        final data = jsonDecode(response.body);
        return ApiResponse<void>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<void>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Obtener usuario autenticado
  static Future<ApiResponse<User>> getMe() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/me'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final user = User.fromJson(data['data']['user']);
        return ApiResponse<User>(success: true, message: data['message'], data: user);
      } else {
        return ApiResponse<User>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<User>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // RECETAS
  // ========================================

  /// Obtener lista de recetas
  static Future<ApiResponse<List<Recipe>>> getRecipes({
    String? search,
    String? difficulty,
    int? categoryId,
    String? sort = 'latest',
    int page = 1,
    int perPage = 10,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'per_page': perPage.toString(),
        if (search != null) 'search': search,
        if (difficulty != null) 'difficulty': difficulty,
        if (categoryId != null) 'category_id': categoryId.toString(),
        if (sort != null) 'sort': sort,
      };

      final response = await http.get(
        Uri.parse('$baseUrl/recipes').replace(queryParameters: queryParams),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // ✅ CORRECCIÓN: Los datos están en data['data']['data'] debido a la paginación
        final List<dynamic> recipesData = data['data']['data'];
        final recipes = recipesData.map((x) => Recipe.fromJson(x)).toList();

        return ApiResponse<List<Recipe>>(success: true, message: 'Recetas obtenidas exitosamente', data: recipes);
      } else {
        return ApiResponse<List<Recipe>>(success: false, message: data['message'] ?? 'Error desconocido');
      }
    } catch (e) {
      return ApiResponse<List<Recipe>>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Obtener receta por slug
  static Future<ApiResponse<Recipe>> getRecipe(String slug) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes/$slug'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final recipe = Recipe.fromJson(data['data']);
        return ApiResponse<Recipe>(success: true, message: data['message'], data: recipe);
      } else {
        return ApiResponse<Recipe>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<Recipe>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Crear nueva receta
  static Future<ApiResponse<Recipe>> createRecipe(Map<String, dynamic> recipeData) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/create-recipe'),
        headers: _headers,
        body: jsonEncode(recipeData),
      );
      print('Headers: $_headers');
      print('Response Status Code: ${response.statusCode}');
      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final recipe = Recipe.fromJson(data['data']['recipe']);
        return ApiResponse<Recipe>(success: true, message: data['message'], data: recipe);
      } else {
        return ApiResponse<Recipe>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Recipe>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Actualizar receta
  static Future<ApiResponse<Recipe>> updateRecipe(String slug, Map<String, dynamic> recipeData) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/recipes/$slug'),
        headers: _headers,
        body: jsonEncode(recipeData),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final recipe = Recipe.fromJson(data['data']);
        return ApiResponse<Recipe>(success: true, message: data['message'], data: recipe);
      } else {
        return ApiResponse<Recipe>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Recipe>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Eliminar receta
  static Future<ApiResponse<void>> deleteRecipe(String slug) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/recipes/$slug'), headers: _headers);

      if (response.statusCode == 200) {
        return ApiResponse<void>(success: true, message: 'Receta eliminada exitosamente');
      } else {
        final data = jsonDecode(response.body);
        return ApiResponse<void>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<void>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Obtener recetas del usuario autenticado
  static Future<ApiResponse<List<Recipe>>> getMyRecipes({int page = 1, int perPage = 10}) async {
    try {
      final queryParams = <String, String>{'page': page.toString(), 'per_page': perPage.toString()};

      final response = await http.get(
        Uri.parse('$baseUrl/recipes/my').replace(queryParameters: queryParams),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final recipes = List<Recipe>.from(data['data'].map((x) => Recipe.fromJson(x)));
        return ApiResponse<List<Recipe>>(success: true, message: data['message'], data: recipes);
      } else {
        return ApiResponse<List<Recipe>>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<List<Recipe>>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // FAVORITOS
  // ========================================

  /// Obtener recetas favoritas
  static Future<ApiResponse<List<Recipe>>> getFavorites({int page = 1, int perPage = 10}) async {
    try {
      final queryParams = <String, String>{'page': page.toString(), 'per_page': perPage.toString()};

      final response = await http.get(
        Uri.parse('$baseUrl/recipes/favorites').replace(queryParameters: queryParams),
        headers: _headers,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final recipes = List<Recipe>.from(data['data'].map((x) => Recipe.fromJson(x)));
        return ApiResponse<List<Recipe>>(success: true, message: data['message'], data: recipes);
      } else {
        return ApiResponse<List<Recipe>>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<List<Recipe>>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Toggle favorito
  static Future<ApiResponse<void>> toggleFavorite(String slug) async {
    try {
      final response = await http.post(Uri.parse('$baseUrl/recipes/$slug/favorite'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse<void>(success: true, message: data['message']);
      } else {
        return ApiResponse<void>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<void>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // COMENTARIOS
  // ========================================

  /// Obtener comentarios de una receta
  static Future<ApiResponse<List<Comment>>> getComments(String slug) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes/$slug/comments'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final comments = List<Comment>.from(data['data'].map((x) => Comment.fromJson(x)));
        return ApiResponse<List<Comment>>(success: true, message: data['message'], data: comments);
      } else {
        return ApiResponse<List<Comment>>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<List<Comment>>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Crear comentario
  static Future<ApiResponse<Comment>> createComment(String slug, String content) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipes/$slug/comments'),
        headers: _headers,
        body: jsonEncode({'content': content}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final comment = Comment.fromJson(data['data']);
        return ApiResponse<Comment>(success: true, message: data['message'], data: comment);
      } else {
        return ApiResponse<Comment>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Comment>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Actualizar comentario
  static Future<ApiResponse<Comment>> updateComment(int commentId, String content) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/comments/$commentId'),
        headers: _headers,
        body: jsonEncode({'content': content}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final comment = Comment.fromJson(data['data']);
        return ApiResponse<Comment>(success: true, message: data['message'], data: comment);
      } else {
        return ApiResponse<Comment>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Comment>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Eliminar comentario
  static Future<ApiResponse<void>> deleteComment(int commentId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/comments/$commentId'), headers: _headers);

      if (response.statusCode == 200) {
        return ApiResponse<void>(success: true, message: 'Comentario eliminado exitosamente');
      } else {
        final data = jsonDecode(response.body);
        return ApiResponse<void>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<void>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // VALORACIONES
  // ========================================

  /// Obtener valoraciones de una receta
  static Future<ApiResponse<List<Rating>>> getRatings(String slug) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/recipes/$slug/ratings'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final ratings = List<Rating>.from(data['data'].map((x) => Rating.fromJson(x)));
        return ApiResponse<List<Rating>>(success: true, message: data['message'], data: ratings);
      } else {
        return ApiResponse<List<Rating>>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<List<Rating>>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Crear valoración
  static Future<ApiResponse<Rating>> createRating(String slug, int rating) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipes/$slug/ratings'),
        headers: _headers,
        body: jsonEncode({'rating': rating}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        final ratingObj = Rating.fromJson(data['data']);
        return ApiResponse<Rating>(success: true, message: data['message'], data: ratingObj);
      } else {
        return ApiResponse<Rating>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Rating>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Actualizar valoración
  static Future<ApiResponse<Rating>> updateRating(int ratingId, int rating) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/ratings/$ratingId'),
        headers: _headers,
        body: jsonEncode({'rating': rating}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final ratingObj = Rating.fromJson(data['data']);
        return ApiResponse<Rating>(success: true, message: data['message'], data: ratingObj);
      } else {
        return ApiResponse<Rating>(success: false, message: data['message'], errors: data['errors']);
      }
    } catch (e) {
      return ApiResponse<Rating>(success: false, message: 'Error de conexión: $e');
    }
  }

  /// Eliminar valoración
  static Future<ApiResponse<void>> deleteRating(int ratingId) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/ratings/$ratingId'), headers: _headers);

      if (response.statusCode == 200) {
        return ApiResponse<void>(success: true, message: 'Valoración eliminada exitosamente');
      } else {
        final data = jsonDecode(response.body);
        return ApiResponse<void>(success: false, message: data['message']);
      }
    } catch (e) {
      return ApiResponse<void>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // CATEGORÍAS
  // ========================================

  /// Obtener categorías
  static Future<ApiResponse<List<Category>>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/categories'), headers: _headers);

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        final categories = (data['data'] as List).map((x) => Category.fromJson(x)).toList();

        return ApiResponse<List<Category>>(
          success: true,
          message: data['message'] ?? 'Categorías cargadas correctamente',
          data: categories,
        );
      } else {
        return ApiResponse<List<Category>>(success: false, message: data['message'] ?? 'Error al obtener categorías');
      }
    } catch (e) {
      return ApiResponse<List<Category>>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // INGREDIENTES
  // ========================================

  /// Obtener ingredientes
  static Future<ApiResponse<List<Ingredient>>> getIngredients({String? search}) async {
    try {
      final queryParams = <String, String>{};
      if (search != null) queryParams['search'] = search;

      final uri = Uri.parse('$baseUrl/ingredients').replace(queryParameters: queryParams);

      final response = await http.get(uri, headers: _headers);
      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['data'] != null) {
        // 👇 aquí accedemos a la lista dentro del objeto data
        final List<dynamic> list = data['data']['data'];

        final ingredients = list.map((x) => Ingredient.fromJson(x)).toList();

        return ApiResponse<List<Ingredient>>(
          success: true,
          message: data['message'] ?? 'Ingredientes cargados correctamente',
          data: ingredients,
        );
      } else {
        return ApiResponse<List<Ingredient>>(
          success: false,
          message: data['message'] ?? 'Error al obtener ingredientes',
        );
      }
    } catch (e) {
      return ApiResponse<List<Ingredient>>(success: false, message: 'Error de conexión: $e');
    }
  }

  // ========================================
  // UTILIDADES
  // ========================================

  /// Configurar token de autenticación
  static void setAuthToken(String token) {
    authToken = token;
  }

  /// Limpiar token de autenticación
  static void clearAuthToken() {
    authToken = null;
  }

  /// Verificar si hay token de autenticación
  static bool get isAuthenticated => authToken != null;
}
