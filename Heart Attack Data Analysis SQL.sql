CREATE DATABASE heart_attack_data_analysis;

USE heart_attack_data_analysis;


CREATE TABLE heart_attack_data (
	Age INT,
    Gender VARCHAR(50),
    Region VARCHAR(50),
    `Urban/Rural` VARCHAR(50),
    SES VARCHAR(50),
    Smoking_Status VARCHAR(50),
    Alcohol_Consumption VARCHAR(50),
    Diet_Type VARCHAR(50),    #-----
    Physical_Activity_Level VARCHAR(50),
    `Screen_Time(hrs/day)` INT,
    `Sleep_Duration(hrs/day)` INT,
    Family_History VARCHAR(50),
    Diabetes VARCHAR(50),
    Hypertension VARCHAR(50),
    `Cholesterol_Levels(mg/dl)` INT,
    `BMI(kg/mÂ²)` FLOAT,
	Stress_Level VARCHAR(50),
    `Blood Pressure(systolic mmHg)` FLOAT,
    `Blood Pressure(diastolic mmHg)` FLOAT,
    `Resting Heart Rate(bpm)` INT,
    ECG_Results VARCHAR(50),
    Chest_Pain_Type VARCHAR(50),
    Maximum_Heart_Rate_Achieved INT,
    Exercise_Induced_Angina VARCHAR(50),
    `Blood_Oxygen_Levels(SpO2%)` FLOAT,
    `Triglyceride_Levels(mg/dL)` INT,
    Heart_Attack_Likelihood VARCHAR(50)
);

-- ALTER TABLE heart_attack_data 
-- CHANGE COLUMN SES `SES(Socioeconomic Status)` VARCHAR(50);

SELECT * FROM heart_attack_data;

-- C:\\Users\\rohit\\Downloads\\INNOMATICS\\Projectsss\\Heart Attacks Data Analysis Project\\heart_attack_youngsters_india.csv

-- USE heart_attack_data_analysis;

-- LOAD DATA LOCAL INFILE 'C:\\Users\\rohit\\Downloads\\INNOMATICS\\Projectsss\\Heart Attacks Data Analysis Project\\heart_attack_youngsters_india.csv'
-- INTO TABLE heart_attack_data
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n' IGNORE 1 rows;

SELECT * FROM heart_attack_data;

SELECT COUNT(*) FROM heart_attack_data;


-- 1. Count the number of individuals in each gender category.
SELECT Gender,
	   COUNT(*) AS no_of_individuals
FROM heart_attack_data
GROUP BY Gender;

-- 2. Find how many individuals belong to each region (Urban/Rural).
SELECT Region,
	   COUNT(*) AS count_of_individuals
FROM heart_attack_data
GROUP BY Region
ORDER BY count_of_individuals DESC;

-- 3. Retrieve the number of people with a family history of heart disease.
      
SELECT Family_History,
	   COUNT(*) AS People_Count
FROM heart_attack_data
WHERE Family_History = "Yes";

-- 4. Count the number of individuals with hypertension in each SES category.

SELECT `SES(Socioeconomic Status)`,
	   COUNT(*) AS no_of_individuals_with_hypertension
FROM heart_attack_data
WHERE Hypertension = "Yes"
GROUP BY `SES(Socioeconomic Status)`;

-- 5. Retrieve records where individuals never smoke but consume alcohol regularly.

SELECT *
FROM heart_attack_data
WHERE Smoking_Status = "Never" AND Alcohol_Consumption = "Regularly";

-- 6. Find the number of people in each diet type (Vegan, Vegetarian, Non-Vegetarian).

SELECT Diet_Type,
	   COUNT(*) AS count_of_individuals
FROM heart_attack_data
GROUP BY Diet_Type
ORDER BY count_of_individuals DESC;

-- 7. Count how many individuals have exercise-induced angina.

SELECT Exercise_Induced_Angina,
	   COUNT(*) AS count_of_individuals
FROM heart_attack_data
WHERE Exercise_Induced_Angina = "Yes";

-- 8. Determine the average BMI for each physical activity level.

SELECT Physical_Activity_Level,
	   ROUND(AVG(`BMI(kg/mÂ²)`),3) AS `Avg_BodyMassIndex (kg/mÂ²)`
FROM heart_attack_data
GROUP BY Physical_Activity_Level;

-- 9. Find the average cholesterol level for individuals in each smoking status category.

SELECT Smoking_Status,
	   ROUND(AVG(`Cholesterol_Levels(mg/dl)`),2) AS `Avg_Cholesterol (mg/dl)`
FROM heart_attack_data
GROUP BY Smoking_Status;

-- 10. Calculate the average sleep duration for individuals with high stress levels.

SELECT Stress_Level,
	   AVG(`Sleep_Duration(hrs/day)`) AS `Avg_Sleep_Duration (hrs/day)`
FROM heart_attack_data
WHERE Stress_Level = "High";


-- 11. Compare the average triglyceride levels between those with and without hypertension.

SELECT Hypertension,
	   AVG(`Triglyceride_Levels(mg/dL)`) AS `Avg_Triglyceride_Levels(mg/dL)`
FROM heart_attack_data
GROUP BY Hypertension;

-- 12. Count the number of individuals with high cholesterol (above 200 mg/dL) who also have ECG abnormalities.

SELECT COUNT(*) individuals_with_high_cholesterol
FROM heart_attack_data
WHERE ECG_Results = "Abnormal" 
AND `Cholesterol_Levels(mg/dl)` > 200;

-- 13. Find the most common chest pain type in individuals with high heart attack likelihood.
SELECT Chest_Pain_Type AS most_common_chest_pain_type
FROM heart_attack_data
WHERE Heart_Attack_Likelihood = "Yes"
GROUP BY Chest_Pain_Type
ORDER BY COUNT(*) DESC
LIMIT 1;

SELECT Chest_Pain_Type, COUNT(Chest_Pain_Type)
FROM heart_attack_data
WHERE Heart_Attack_Likelihood = "Yes"
GROUP BY Chest_Pain_Type;             -- This query is just to cross check the answer given by above query

-- 14. Find the average maximum heart rate achieved for each gender.

SELECT Gender,
	   AVG(Maximum_Heart_Rate_Achieved) AS Max_Heart_Rate_Achieved
FROM heart_attack_data
GROUP BY Gender;

-- 15. Identify the average blood pressure levels for different stress levels.

SELECT Stress_Level,
	   ROUND(AVG(`Blood Pressure(systolic mmHg)`),2) AS `AVG_Blood_Pressure(systolic mmHg)`,
       ROUND(AVG(`Blood Pressure(diastolic mmHg)`),2) AS `AVG_Blood_Pressure(diastolic mmHg)`
FROM heart_attack_data
GROUP BY Stress_Level;

-- 16. Find the percentage of individuals with heart attack likelihood in each SES group.

SELECT `SES(Socioeconomic Status)`,
		COUNT(CASE WHEN Heart_Attack_Likelihood = "Yes" THEN 1 END)*100 / COUNT(*) 
        AS Heart_Attack_Likelihood_Percentage
FROM heart_attack_data
GROUP BY `SES(Socioeconomic Status)`;


-- 17. Rank individuals by BMI within each diet type (ORDER BY BMI DESC).

SELECT DENSE_RANK() OVER (PARTITION BY Diet_Type ORDER BY `BMI(kg/mÂ²)` DESC) AS BMI_Rank,
	   Diet_Type,
	   `BMI(kg/mÂ²)`
FROM heart_attack_data;

-- 18. Find the top 5 factors (columns with Yes/No values) most commonly associated with heart attacks.
SELECT "Family_History" AS Risk_Factors, COUNT(*) AS Possible_HeartAttack_Cases
FROM heart_attack_data
WHERE Family_History = "Yes" AND Heart_Attack_Likelihood = "Yes"
UNION ALL
SELECT "Diabetes" AS Risk_Factor, COUNT(*)
FROM heart_attack_data
WHERE Diabetes = "Yes" AND Heart_Attack_Likelihood = "Yes"
UNION ALL
SELECT "Hypertension" AS Risk_Factor, COUNT(*)
FROM heart_attack_data
WHERE Hypertension = "Yes" AND Heart_Attack_Likelihood = "Yes"
UNION ALL
SELECT "High Stress Level" AS Risk_Factor, COUNT(*)
FROM heart_attack_data
WHERE Stress_Level = "High" AND Heart_Attack_Likelihood = "Yes"
UNION ALL 
SELECT "ECG Abnormal" AS Risk_Factor, COUNT(*)
FROM heart_attack_data
WHERE ECG_Results = "Abnormal" AND Heart_Attack_Likelihood = "Yes"
ORDER BY Possible_HeartAttack_Cases DESC;


-- 19.	Determine if there is a correlation between high screen time (above 6 hours) and heart attack likelihood.

SELECT Heart_Attack_Likelihood,
	   COUNT(*) AS Count_of_individuals,
	   COUNT(CASE WHEN `Screen_Time(hrs/day)` > 6 THEN 1 END) AS High_Screen_Time_Individuals,
       ROUND( (COUNT(CASE WHEN `Screen_Time(hrs/day)` > 6 THEN 1 END) / COUNT(*)) * 100, 2) AS Percentage_High_Screen_Time
FROM heart_attack_data
GROUP BY Heart_Attack_Likelihood;


-- 20. Categorize blood pressure levels into "Normal," "Prehypertension," "Hypertension Stage 1," and "Hypertension Stage 2."

SELECT `Blood Pressure(systolic mmHg)` AS `Blood Pressure(systolic mmHg)`,
	   `Blood Pressure(diastolic mmHg)` AS `Blood Pressure(diastolic mmHg)`,
       CASE 
			WHEN `Blood Pressure(systolic mmHg)` <= 120 AND `Blood Pressure(diastolic mmHg)` <=80 
				THEN "Normal" 
            WHEN `Blood Pressure(systolic mmHg)` BETWEEN 121 AND 139 OR `Blood Pressure(diastolic mmHg)` BETWEEN 81 AND 89
				THEN "Prehypertension"
	        WHEN `Blood Pressure(systolic mmHg)` BETWEEN 140 AND 159 OR `Blood Pressure(diastolic mmHg)` BETWEEN 90 AND 99 
				THEN "Hypertension Stage 1"
	        WHEN `Blood Pressure(systolic mmHg)` > 160 OR `Blood Pressure(diastolic mmHg)` > 100 
				THEN "Hypertension Stage 2"
			ELSE "Unknown"
		END AS blood_pressure_level
FROM heart_attack_data;

-- 21. Compare the heart attack likelihood rate between urban and rural regions.

SELECT `Urban/Rural`,
	   (COUNT(CASE WHEN Heart_Attack_Likelihood = "Yes" THEN 1 END) * 100 / COUNT(*)) AS Heart_Attack_Likelihood_Percentage
FROM heart_attack_data
GROUP BY `Urban/Rural`;


-- 22. Identify individuals with high resting heart rates (>90 bpm) and low blood oxygen levels (<95%).

SELECT *
FROM heart_attack_data
WHERE `Resting Heart Rate(bpm)` > 90 AND `Blood_Oxygen_Levels(SpO2%)` < 95;

-- 23. Analyse how physical activity level impacts cholesterol levels.

SELECT Physical_Activity_Level,
	   ROUND(AVG(`Cholesterol_Levels(mg/dl)`),2) AS `Avg_Cholesterol_Levels(mg/dl)`
FROM heart_attack_data
GROUP BY Physical_Activity_Level;

-- 24. Find the distribution of exercise-induced angina across different chest pain types.

SELECT Chest_Pain_Type,
	   COUNT(CASE WHEN Exercise_Induced_Angina = "Yes" THEN 1 END) AS Angina_Count
FROM heart_attack_data
GROUP BY Chest_Pain_Type;

-- 25. Compare the average cholesterol levels of individuals who consume alcohol occasionally vs. regularly.

SELECT Alcohol_Consumption,
	   ROUND(AVG(`Cholesterol_Levels(mg/dl)`),2) AS Avg_Cholesterol
FROM heart_attack_data
WHERE Alcohol_Consumption IN ("Regularly","Occasionally")
GROUP BY Alcohol_Consumption;

-- 26. What is the average age of individuals with a high heart attack likelihood?

SELECT Heart_Attack_Likelihood,
	   AVG(Age) AS avg_age
FROM heart_attack_data
WHERE Heart_Attack_Likelihood = "Yes"
GROUP BY Heart_Attack_Likelihood;          -- This helps determine if age plays a role in heart attack likelihood.

-- 27. Analyze the combined impact of diabetes and hypertension on cholesterol levels. 
-- Do individuals with both conditions have significantly higher cholesterol?

SELECT Risk_Combination ,
	   AVG(`Cholesterol_Levels(mg/dl)`) AS Avg_Cholesterol_Levels
FROM(
	SELECT CASE 
			   WHEN Diabetes = "Yes" AND Hypertension = "Yes" THEN "Diabetes + Hypertension"
			   WHEN Diabetes = "Yes" AND Hypertension = "No" THEN "Diabetes_Only"
			   WHEN Diabetes = "No" AND Hypertension = "Yes" THEN "Hypertension only"
			   WHEN Diabetes = "No" AND Hypertension = "No" THEN "Neither"
			END AS Risk_Combination ,
            `Cholesterol_Levels(mg/dl)`
	FROM heart_attack_data
	) AS subquery
	GROUP BY Risk_Combination 
	ORDER BY Avg_Cholesterol_Levels DESC;


-- 28. Perform a trend analysis: Does heart attack likelihood increase with age?
SELECT * FROM heart_attack_data;

WITH agecategorized AS (
	SELECT *,
		CASE
			WHEN Age BETWEEN 18 AND 21 THEN '18-21'
			WHEN Age BETWEEN 22 AND 25 THEN '22-25'
			WHEN Age BETWEEN 26 AND 29 THEN '26-29'
			WHEN Age BETWEEN 30 AND 35 THEN '30-35'
        END AS range_of_age
	FROM heart_attack_data
)
SELECT range_of_age,
	   ROUND(COUNT(CASE WHEN Heart_Attack_Likelihood = "Yes" THEN 1 END) * 100.0 / COUNT(*),2) AS heart_attack_likelihood_percentage
FROM agecategorized
GROUP BY range_of_age
ORDER BY range_of_age;
