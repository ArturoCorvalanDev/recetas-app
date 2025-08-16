// Modelos para la API de Recetas
// Basados en los modelos de Laravel

import 'dart:convert';

// ========================================
// MODELO USER
// ========================================
class User {
  final int id;
  final String name;
  final String username;
  final String email;
  final String? avatarUrl;
  final String? bio;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double? averageRating;
  final List<Recipe>? recipes;
  final List<Recipe>? favorites;
  final List<Comment>? comments;
  final List<Rating>? ratings;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    this.avatarUrl,
    this.bio,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    this.averageRating,
    this.recipes,
    this.favorites,
    this.comments,
    this.ratings,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
      avatarUrl: json['avatar_url'],
      bio: json['bio'],
      emailVerifiedAt: json['email_verified_at'] != null ? DateTime.parse(json['email_verified_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      averageRating: json['average_rating']?.toDouble(),
      recipes: json['recipes'] != null ? List<Recipe>.from(json['recipes'].map((x) => Recipe.fromJson(x))) : null,
      favorites: json['favorites'] != null ? List<Recipe>.from(json['favorites'].map((x) => Recipe.fromJson(x))) : null,
      comments: json['comments'] != null ? List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))) : null,
      ratings: json['ratings'] != null ? List<Rating>.from(json['ratings'].map((x) => Rating.fromJson(x))) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,
      'avatar_url': avatarUrl,
      'bio': bio,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'average_rating': averageRating,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? avatarUrl,
    String? bio,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? averageRating,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}

// ========================================
// MODELO RECIPE
// ========================================
class Recipe {
  final int id;
  final int userId;
  final String title;
  final String slug;
  final String? description;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? servings;
  final String difficulty;
  final bool isPublic;
  final int? calories;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final List<RecipeStep>? steps;
  final List<Ingredient>? ingredients;
  final List<Category>? categories;
  final List<Photo>? photos;
  final List<Comment>? comments;
  final List<Rating>? ratings;
  final int? totalTime;
  final double? averageRating;
  final int? ratingsCount;
  final int? favoritesCount;
  final String? difficultyText;
  final String? url;

  Recipe({
    required this.id,
    required this.userId,
    required this.title,
    required this.slug,
    this.description,
    this.prepMinutes,
    this.cookMinutes,
    this.servings,
    required this.difficulty,
    required this.isPublic,
    this.calories,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.steps,
    this.ingredients,
    this.categories,
    this.photos,
    this.comments,
    this.ratings,
    this.totalTime,
    this.averageRating,
    this.ratingsCount,
    this.favoritesCount,
    this.difficultyText,
    this.url,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      slug: json['slug'],
      description: json['description'],
      prepMinutes: json['prep_minutes'],
      cookMinutes: json['cook_minutes'],
      servings: json['servings'],
      difficulty: json['difficulty'],
      isPublic: json['is_public'],
      calories: json['calories'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      steps: json['steps'] != null ? List<RecipeStep>.from(json['steps'].map((x) => RecipeStep.fromJson(x))) : null,
      ingredients: json['ingredients'] != null
          ? List<Ingredient>.from(json['ingredients'].map((x) => Ingredient.fromJson(x)))
          : null,
      categories: json['categories'] != null
          ? List<Category>.from(json['categories'].map((x) => Category.fromJson(x)))
          : null,
      photos: json['photos'] != null ? List<Photo>.from(json['photos'].map((x) => Photo.fromJson(x))) : null,
      comments: json['comments'] != null ? List<Comment>.from(json['comments'].map((x) => Comment.fromJson(x))) : null,
      ratings: json['ratings'] != null ? List<Rating>.from(json['ratings'].map((x) => Rating.fromJson(x))) : null,
      totalTime: json['total_time'],
      averageRating: json['average_rating']?.toDouble(),
      ratingsCount: json['ratings_count'],
      favoritesCount: json['favorites_count'],
      difficultyText: json['difficulty_text'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'slug': slug,
      'description': description,
      'prep_minutes': prepMinutes,
      'cook_minutes': cookMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'is_public': isPublic,
      'calories': calories,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO RECIPE STEP
// ========================================
class RecipeStep {
  final int? id;
  final int? recipeId;
  final int stepNumber;
  final String instruction;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecipeStep({
    this.id,
    this.recipeId,
    required this.stepNumber,
    required this.instruction,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    return RecipeStep(
      id: json['id'],
      recipeId: json['recipe_id'],
      stepNumber: json['step_number'],
      instruction: json['instruction'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'step_number': stepNumber,
      'instruction': instruction,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO RecipeIngredient
// ========================================

class RecipeIngredient {
  final int? id;
  final int? recipeId;
  final int ingredientId;
  final int quantity;
  final String? unit;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  RecipeIngredient({
    this.id,
    this.recipeId,
    required this.ingredientId,
    required this.quantity,
    this.unit,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      id: json['id'],
      recipeId: json['recipe_id'],
      ingredientId: json['ingredient_id'],
      quantity: json['quantity'],
      unit: json['unit'],
      note: json['note'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'ingredient_id': ingredientId,
      'quantity': quantity,
      'unit': unit,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO INGREDIENT
// ========================================
class Ingredient {
  final int id;
  final String name;
  final String? defaultUnit;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? pivot;

  Ingredient({
    required this.id,
    required this.name,
    this.defaultUnit,
    required this.createdAt,
    required this.updatedAt,
    this.pivot,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      defaultUnit: json['default_unit'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      pivot: json['pivot'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'default_unit': defaultUnit,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Getters para datos del pivot
  String? get quantity => pivot?['quantity']?.toString();
  String? get unit => pivot?['unit'];
  String? get note => pivot?['note'];
}

// ========================================
// MODELO CATEGORY
// ========================================
class Category {
  final int id;
  final String name;
  final String slug;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO PHOTO
// ========================================
class Photo {
  final int id;
  final int recipeId;
  final int? userId;
  final String path;
  final bool isCover;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? url;
  final String? fullUrl;

  Photo({
    required this.id,
    required this.recipeId,
    this.userId,
    required this.path,
    required this.isCover,
    required this.createdAt,
    required this.updatedAt,
    this.url,
    this.fullUrl,
  });

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      path: json['path'],
      isCover: json['is_cover'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      url: json['url'],
      fullUrl: json['full_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'user_id': userId,
      'path': path,
      'is_cover': isCover,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO COMMENT
// ========================================
class Comment {
  final int id;
  final int recipeId;
  final int userId;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Recipe? recipe;

  Comment({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.recipe,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      recipe: json['recipe'] != null ? Recipe.fromJson(json['recipe']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'user_id': userId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO RATING
// ========================================
class Rating {
  final int id;
  final int recipeId;
  final int userId;
  final int rating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User? user;
  final Recipe? recipe;
  final String? stars;

  Rating({
    required this.id,
    required this.recipeId,
    required this.userId,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    this.user,
    this.recipe,
    this.stars,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      id: json['id'],
      recipeId: json['recipe_id'],
      userId: json['user_id'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      recipe: json['recipe'] != null ? Recipe.fromJson(json['recipe']) : null,
      stars: json['stars'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipe_id': recipeId,
      'user_id': userId,
      'rating': rating,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

// ========================================
// MODELO API RESPONSE
// ========================================
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({required this.success, required this.message, this.data, this.errors});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromJson) {
    return ApiResponse<T>(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null ? fromJson(json['data']) : null,
      errors: json['errors'],
    );
  }
}

// ========================================
// MODELO LOGIN REQUEST
// ========================================
class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password};
  }
}

// ========================================
// MODELO REGISTER REQUEST
// ========================================
class RegisterRequest {
  final String name;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String? bio;

  RegisterRequest({
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'bio': bio,
    };
  }
}

// ========================================
// MODELO AUTH RESPONSE
// ========================================
class AuthResponse {
  final User user;
  final String token;
  final String tokenType;

  AuthResponse({required this.user, required this.token, required this.tokenType});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(user: User.fromJson(json['user']), token: json['token'], tokenType: json['token_type']);
  }
}

// ========================================
// MODELO CREAR RECETA
// ========================================

class RecipeRequest {
  String title;
  String description;
  int prepMinutes;
  int cookMinutes;
  int servings;
  String difficulty;
  List<int> categories;
  List<RecipeIngredient> ingredients;
  List<RecipeStep> steps;

  RecipeRequest({
    required this.title,
    required this.description,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.servings,
    required this.difficulty,
    required this.categories,
    required this.ingredients,
    required this.steps,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'prep_minutes': prepMinutes,
      'cook_minutes': cookMinutes,
      'servings': servings,
      'difficulty': difficulty,
      'categories': categories,
      'ingredients': ingredients.map((i) => i.toJson()).toList(),
      'steps': steps.map((s) => s.toJson()).toList(),
    };
  }
}
