class Recipe {
  final String recipeId;
  final String authorId;
  final int calories;
  final String title;
  final List<String> category;
  final String description;
  final int durationInMin;
  final String imageUrl;
  var ingredients;
  final List<String> instructions;
  final bool isRecipe;
  final List<String> labels;
  final int likes;
  final int servingSize;

  Recipe(
      {this.recipeId,
      this.authorId,
      this.calories,
      this.title,
      this.category,
      this.description,
      this.durationInMin,
      this.imageUrl,
      this.ingredients,
      this.instructions,
      this.isRecipe,
      this.labels,
      this.likes,
      this.servingSize});
}

class RecipeCount {

  int count;

  RecipeCount({
    this.count
  });
  
}