``` JSON
[
    {
        "User": {
            "UserId" : "0", // Number
            "UserName" : "JohnDoe777", // String
            "IsAdmin" : "false", // Boolean
            "Email" : "JohnDoe@gmail.com", // String
            "Password" : "1234", // String
            "Age" : "19", // Number
            "Weight" : "200 kg", // String
            "GoalWeight" : "250 kg", // String
            "Height" : "5'7", // String
            "ProfilePicture" : "https://www.example.com", // String
            "SubscriptionActive" : "true", // Boolean
            "Labels" : { // Map of Booleans
                "Vegan" : "false", 
                "Vegetarian" : "false", 
                "Diary-free" : "true" 
            },
            "Favorites" : [ // Array of Numbers
                1,
                2,
                3
            ] ,
            "FoodInformation" : {  // Nested Sub-Collection
                "Ingredients" : {
                    "IngredientId" : "1", // Number
                    "Name" : "salt", // String
                    "UOM" : "kg", // String
                    "Quantity" : "4" // Number
                },
                "Waste" : {
                    "IngredientId" : "1", // Number
                    "Name" : "apple", // String
                    "UOM" : "ld", // String
                    "Quantity" : "4" // Number
                },
                "GroceryList" : {
                    "IngredientId" : "1", // Number
                    "Name" : "orange", // String
                    "UOM" : "each", // String
                    "Quantity" : "4" // Number
                }
            } 
        }
    },
    {
        "Recipe": {
            "RecipeId" : "0", // Number
            "IsPublic" : "true", // Boolean
            "AuthorId" : "1", // Number
            "Title" : "This is the Title", // String
            "Description" : "This is the Description", // String
            "Calories" : "2000", // Number 
            "DurationMin" : "25", // Number 
            "ImageURL" : "https://www.example.com", // String 
            "Likes" : "55", // Number 
            "Servings" : "5 Adults", // String 
            "Labels" : { // Map of Booleans
                "Dairy-free" : "false", 
                "Heart-healthy" : "false", 
                "Vegan" : "false", 
                "Vegetarian" : "true"
            }, 
            "Instructions" : [ // Array of Strings
                "Step 1 - do this",
                "Step 2 - do that",
                "Step 3 - do this again",
                "Step 4 - then do that"
            ],
            "Category" : { // Map of Booleans
                "Meat" : "false",
                "Side-dish" : "false",
                "Kosher" : "false",
                "Fruit" : "true"
            },
            "Ratings" : { // Nested Sub-Collection
                "Ratings" : {
                    "RatingId" : "1", // Number
                    "Comment" : "comments", // String
                    "UserId" : "1", // Number
                    "UserName" : "TheRealJohnDoe", // String
                    "DateCommented" : "1/18/2020 12:05:00 PM" // Timestamp
                }
            }
        }
    }
]

```