CREATE DATABASE RecipesExample; 

USE RecipesExample;

CREATE TABLE Ingredient_Classes (
    IngredientClassID smallint NOT NULL,
    IngredientClassDescription varchar(255) NULL,
    PRIMARY KEY (IngredientClassID)
);

CREATE TABLE Ingredients (
    IngredientID int NOT NULL,
    IngredientName varchar(255) NULL,
    IngredientClassID smallint NULL,
    MeasureAmountID smallint NULL,
    PRIMARY KEY (IngredientID),
    FOREIGN KEY (IngredientClassID) REFERENCES Ingredient_Classes(IngredientClassID),
    FOREIGN KEY (MeasureAmountID) REFERENCES Measurements(MeasureAmountID)
);

CREATE TABLE Measurements (
    MeasureAmountID smallint NOT NULL,
    MeasurementDescription varchar(255) NULL,
    PRIMARY KEY (MeasureAmountID)
);

CREATE TABLE Recipe_Classes (
    RecipeClassID smallint NOT NULL,
    RecipeClassDescription varchar(255) NULL,
    PRIMARY KEY (RecipeClassID)
);

CREATE TABLE Recipe_Ingredients (
    RecipeID int NOT NULL,
    RecipeSeqNo smallint NOT NULL,
    IngredientID int NULL,
    MeasureAmountID smallint NULL,
    Amount real NULL,
    PRIMARY KEY (RecipeID, RecipeSeqNo),
    FOREIGN KEY (RecipeID) REFERENCES Recipes(RecipeID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredients(IngredientID),
    FOREIGN KEY (MeasureAmountID) REFERENCES Measurements(MeasureAmountID)
);

CREATE TABLE Recipes (
    RecipeID int NOT NULL,
    RecipeTitle varchar(255) NULL,
    RecipeClassID smallint NULL,
    Preparation varchar(max) NULL,
    Notes varchar(max) NULL,
    PRIMARY KEY (RecipeID),
    FOREIGN KEY (RecipeClassID) REFERENCES Recipe_Classes(RecipeClassID)
);

CREATE INDEX Ingredient_ClassesIngredients ON Ingredients(IngredientClassID);
CREATE INDEX MeasurementsIngredients ON Ingredients(MeasureAmountID);
CREATE INDEX IngredientID ON Recipe_Ingredients(IngredientID);
CREATE INDEX MeasureAmountID ON Recipe_Ingredients(MeasureAmountID);
CREATE INDEX RecipeID ON Recipe_Ingredients(RecipeID);
CREATE INDEX Recipe_ClassesRecipes ON Recipes(RecipeClassID);
