-- Create Tables

CREATE TABLE USER_ACCOUNT (
    User_ID NUMBER(10) PRIMARY KEY,
    First_Name VARCHAR2(50) NOT NULL,
    Last_Name VARCHAR2(50) NOT NULL,
    Email VARCHAR2(100) UNIQUE NOT NULL,
    Password VARCHAR2(100) NOT NULL,
    Phone VARCHAR2(20)
);

CREATE TABLE MEAL_TYPE (
    MealType_ID NUMBER(10) PRIMARY KEY,
    MealType_Name VARCHAR2(50) NOT NULL
);

CREATE TABLE INGREDIENT (
    Ingredient_ID NUMBER(10) PRIMARY KEY,
    Ingredient_Name VARCHAR2(100) NOT NULL
);

CREATE TABLE COOKING_TAG (
    Tag_ID NUMBER(10) PRIMARY KEY,
    Tag_Name VARCHAR2(50) NOT NULL
);

CREATE TABLE RECIPE (
    Recipe_ID NUMBER(10) PRIMARY KEY,
    Recipe_Name VARCHAR2(100) NOT NULL,
    Cooking_Time NUMBER(5) CHECK (Cooking_Time > 0),
    Difficulty_Level VARCHAR2(20)
        CHECK (Difficulty_Level IN ('Easy','Medium','Hard')),
    Serving_Size NUMBER(3) CHECK (Serving_Size > 0),
    User_ID NUMBER(10) NOT NULL,
    MealType_ID NUMBER(10) NOT NULL,

    CONSTRAINT fk_recipe_user
        FOREIGN KEY (User_ID)
        REFERENCES USER_ACCOUNT(User_ID)
        ON DELETE CASCADE,

    CONSTRAINT fk_recipe_mealtype
        FOREIGN KEY (MealType_ID)
        REFERENCES MEAL_TYPE(MealType_ID)
);

CREATE TABLE RECIPE_STEP (
    Recipe_ID NUMBER(10),
    Step_Number NUMBER(3),
    Step_Description VARCHAR2(500) NOT NULL,

    PRIMARY KEY (Recipe_ID, Step_Number),

    CONSTRAINT fk_step_recipe
        FOREIGN KEY (Recipe_ID)
        REFERENCES RECIPE(Recipe_ID)
        ON DELETE CASCADE
);

CREATE TABLE RECIPE_INGREDIENT (
    Recipe_ID NUMBER(10),
    Ingredient_ID NUMBER(10),
    Quantity VARCHAR2(50) NOT NULL,

    PRIMARY KEY (Recipe_ID, Ingredient_ID),

    CONSTRAINT fk_ri_recipe
        FOREIGN KEY (Recipe_ID)
        REFERENCES RECIPE(Recipe_ID)
        ON DELETE CASCADE,

    CONSTRAINT fk_ri_ingredient
        FOREIGN KEY (Ingredient_ID)
        REFERENCES INGREDIENT(Ingredient_ID)
);

CREATE TABLE RECIPE_TAG (
    Recipe_ID NUMBER(10),
    Tag_ID NUMBER(10),

    PRIMARY KEY (Recipe_ID, Tag_ID),

    CONSTRAINT fk_rt_recipe
        FOREIGN KEY (Recipe_ID)
        REFERENCES RECIPE(Recipe_ID)
        ON DELETE CASCADE,

    CONSTRAINT fk_rt_tag
        FOREIGN KEY (Tag_ID)
        REFERENCES COOKING_TAG(Tag_ID)
        ON DELETE CASCADE
);


-- Insert Data

INSERT INTO USER_ACCOUNT VALUES
(1, 'Noura', 'Alqahtani', 'noura.q@hellofresh-test.com', 'Pass#101', '0501112233');

INSERT INTO USER_ACCOUNT VALUES
(2, 'Reem', 'Alharbi', 'reem.h@hellofresh-test.com', 'Pass#102', '0502223344');

INSERT INTO USER_ACCOUNT VALUES
(3, 'Dana', 'Almutairi', 'dana.m@hellofresh-test.com', 'Pass#103', '0503334455');

INSERT INTO USER_ACCOUNT VALUES
(4, 'Lama', 'Aldossary', 'lama.d@hellofresh-test.com', 'Pass#104', '0504445566');

INSERT INTO USER_ACCOUNT VALUES
(5, 'Sara', 'Alotaibi', 'sara.o@hellofresh-test.com', 'Pass#105', '0505556677');


INSERT INTO MEAL_TYPE VALUES (1, 'Breakfast');
INSERT INTO MEAL_TYPE VALUES (2, 'Lunch');
INSERT INTO MEAL_TYPE VALUES (3, 'Dinner');
INSERT INTO MEAL_TYPE VALUES (4, 'Snack');
INSERT INTO MEAL_TYPE VALUES (5, 'Dessert');


INSERT INTO INGREDIENT VALUES (1, 'Chicken Breast');
INSERT INTO INGREDIENT VALUES (2, 'Cherry Tomatoes');
INSERT INTO INGREDIENT VALUES (3, 'Olive Oil');
INSERT INTO INGREDIENT VALUES (4, 'Garlic Cloves');
INSERT INTO INGREDIENT VALUES (5, 'Basmati Rice');


INSERT INTO COOKING_TAG VALUES (1, 'Quick');
INSERT INTO COOKING_TAG VALUES (2, 'Healthy');
INSERT INTO COOKING_TAG VALUES (3, 'High Protein');
INSERT INTO COOKING_TAG VALUES (4, 'Mediterranean');
INSERT INTO COOKING_TAG VALUES (5, 'Family Friendly');


INSERT INTO RECIPE VALUES
(101, 'Garlic Herb Chicken Bowl', 25, 'Easy', 2, 1, 3);

INSERT INTO RECIPE VALUES
(102, 'Mediterranean Tomato Rice', 35, 'Medium', 4, 2, 2);

INSERT INTO RECIPE VALUES
(103, 'Crispy Garlic Chickpea Bites', 20, 'Easy', 2, 3, 4);

INSERT INTO RECIPE VALUES
(104, 'Lemon Olive Chicken Skillet', 30, 'Medium', 3, 1, 3);

INSERT INTO RECIPE VALUES
(105, 'Morning Herb Omelet Wrap', 15, 'Easy', 1, 4, 1);


INSERT INTO RECIPE_STEP VALUES
(101, 1, 'Season chicken breast with salt, pepper, and minced garlic.');

INSERT INTO RECIPE_STEP VALUES
(101, 2, 'Pan-sear chicken in olive oil for 6-7 minutes per side until cooked.');

INSERT INTO RECIPE_STEP VALUES
(102, 1, 'Rinse basmati rice and halve the cherry tomatoes.');

INSERT INTO RECIPE_STEP VALUES
(102, 2, 'Simmer rice with tomatoes and olive oil until tender.');

INSERT INTO RECIPE_STEP VALUES
(105, 1, 'Whisk eggs with chopped herbs and cook in a lightly oiled pan.');


INSERT INTO RECIPE_INGREDIENT VALUES (101, 1, '300g');
INSERT INTO RECIPE_INGREDIENT VALUES (101, 4, '3 cloves');
INSERT INTO RECIPE_INGREDIENT VALUES (102, 5, '2 cups');
INSERT INTO RECIPE_INGREDIENT VALUES (102, 2, '150g');
INSERT INTO RECIPE_INGREDIENT VALUES (104, 3, '2 tbsp');


INSERT INTO RECIPE_TAG VALUES (101, 1);
INSERT INTO RECIPE_TAG VALUES (101, 3);
INSERT INTO RECIPE_TAG VALUES (102, 4);
INSERT INTO RECIPE_TAG VALUES (104, 2);
INSERT INTO RECIPE_TAG VALUES (105, 5);

COMMIT;


SELECT * FROM USER_ACCOUNT;
SELECT * FROM MEAL_TYPE;
SELECT * FROM INGREDIENT;
SELECT * FROM COOKING_TAG;
SELECT * FROM RECIPE;
SELECT * FROM RECIPE_STEP;
SELECT * FROM RECIPE_INGREDIENT;
SELECT * FROM RECIPE_TAG;


-- Queries

-- Query 1
SELECT Recipe_ID,
       Recipe_Name,
       Cooking_Time,
       Difficulty_Level
FROM RECIPE
WHERE Cooking_Time <= 30
AND Difficulty_Level = 'Easy';


-- Query 2
SELECT R.Recipe_Name,
       M.MealType_Name
FROM RECIPE R
LEFT JOIN MEAL_TYPE M
ON R.MealType_ID = M.MealType_ID;


-- Query 3
SELECT M.MealType_Name,
       COUNT(R.Recipe_ID) AS Total_Recipes
FROM MEAL_TYPE M
JOIN RECIPE R
ON M.MealType_ID = R.MealType_ID
GROUP BY M.MealType_Name;


-- Query 4
SELECT M.MealType_Name,
       COUNT(R.Recipe_ID) AS Total_Recipes
FROM MEAL_TYPE M
JOIN RECIPE R
ON M.MealType_ID = R.MealType_ID
GROUP BY M.MealType_Name
HAVING COUNT(R.Recipe_ID) > 1;


-- Query 5
SELECT Recipe_Name,
       Cooking_Time
FROM RECIPE
WHERE Cooking_Time > (
    SELECT AVG(Cooking_Time)
    FROM RECIPE
);


-- Query 6
SELECT User_ID
FROM USER_ACCOUNT
MINUS
SELECT User_ID
FROM RECIPE;


-- Query 7
UPDATE RECIPE
SET Serving_Size = 2
WHERE Recipe_ID = 105;

SELECT Recipe_ID,
       Recipe_Name,
       Serving_Size
FROM RECIPE
WHERE Recipe_ID = 105;


-- Query 8
DELETE FROM COOKING_TAG
WHERE Tag_ID = 5;

SELECT *
FROM COOKING_TAG;

COMMIT;
