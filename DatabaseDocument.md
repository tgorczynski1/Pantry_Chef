``` JSON
[
    {
        "User": {
            "UserId" : "0", 
            "UserName" : "JohnDoe777", 
            "IsAdmin" : "false",
            "Email" : "JohnDoe@gmail.com", 
            "Password" : "1234", 
            "Age" : "19", 
            "Weight" : "200 kg", 
            "GoalWeight" : "250 kg", 
            "Height" : "5'7", 
            "ProfilePicture" : "https://www.example.com", 
            "SubscriptionActive" : "true", 
            "Labels" : { 
                "Vegan" : "false", 
                "Vegetarian" : "false", 
                "Diary-free" : "true" 
            },
            "Favorites" : [ 
                1,
                2,
                3
            ] ,
            "FoodInformation" : {  
                "Ingredients" : {
                    "IngredientId" : "1", 
                    "Name" : "salt", 
                    "UOM" : "kg", 
                    "Quantity" : "4" 
                },
                "Waste" : {
                    "IngredientId" : "1", 
                    "Name" : "apple", 
                    "UOM" : "ld", 
                    "Quantity" : "4" 
                },
                "GroceryList" : {
                    "IngredientId" : "1", 
                    "Name" : "orange", 
                    "UOM" : "each", 
                    "Quantity" : "4" 
                }
            } 
        }
    },
    {
        "Recipe": {
            "RecipeId" : "0", 
            "IsPublic" : "true",
            "AuthorId" : "1", 
            "Title" : "This is the Title", 
            "Description" : "This is the Description",
            "Calories" : "2000", 
            "DurationMin" : "25", 
            "ImageURL" : "https://www.example.com", 
            "Likes" : "55",  
            "Servings" : "5 Adults", 
            "Labels" : { 
                "Dairy-free" : "false", 
                "Heart-healthy" : "false", 
                "Vegan" : "false", 
                "Vegetarian" : "true"
            }, 
            "Instructions" : [ 
                "Step 1 - do this",
                "Step 2 - do that",
                "Step 3 - do this again",
                "Step 4 - then do that"
            ],
            "Category" : { 
                "Meat" : "false",
                "Side-dish" : "false",
                "Kosher" : "false",
                "Fruit" : "true"
            },
            "Ratings" : { 
                "Ratings" : {
                    "RatingId" : "1",
                    "Comment" : "comments",
                    "UserId" : "1",
                    "UserName" : "TheRealJohnDoe",
                    "DateCommented" : "1/18/2020 12:05:00 PM" 
                }
            }
        }
    }
]

```