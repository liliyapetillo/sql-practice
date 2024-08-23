
--Easy level--
--Find first name, last name, and gender of patients whose gender is 'M'--
SELECT first_name, last_name, gender FROM patients
WHERE gender = 'M'

--Show first name and last name of patients who does not have allergies.--
SELECT first_name, last_name FROM patients
WHERE allergies IS NULL 

--Show first name of patients that start with the letter 'C'--
SELECT first_name FROM patients
WHERE first_name LIKE 'C%'

--Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)--
SELECT first_name, last_name FROM patients
WHERE weight BETWEEN 100 AND 120

--Update the patients table for the allergies column. If the patient's allergies is null then replace it with 'NKA'--
UPDATE patients 
SET allergies = 'NKA'
WHERE allergies IS NULL

--Show first name and last name concatinated into one column to show their full name.--
SELECT concat (first_name," ", last_name)
FROM patients

--Show first name, last name, and the full province name of each patient.--
SELECT first_name, last_name, province_name FROM patients
JOIN province_names ON patients.province_id = province_names.province_id

--Show how many patients have a birth_date with 2010 as the birth year.--
SELECT COUNT(patient_id) AS total_patients FROM patients
WHERE YEAR(birth_date) = 2010

--Show the first_name, last_name, and height of the patient with the greatest height.--
SELECT first_name, last_name, MAX(height) FROM patients

--Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000--
SELECT * FROM patients
WHERE patient_id IN (1,45,534,879,1000)

--Show the total number of admissions--
SELECT COUNT(admission_date) FROM admissions

--Show all the columns from admissions where the patient was admitted and discharged on the same day.--
SELECT * FROM admissions
WHERE admission_date = discharge_date

--Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?--
SELECT city from patients
WHERE province_id = 'NS'
GROUP BY city

--Write a query to find the first_name, last name and birth date of patients who has height greater than 160 and weight greater than 70--
SELECT first_name, last_name, birth_date FROM patients
WHERE height > 160 AND weight> 70

--Write a query to find list of patients first_name, last_name, and allergies where allergies are not null and are from the city of 'Hamilton'--
SELECT first_name, last_name, allergies FROM patients
WHERE allergies IS NOT NULL AND city = 'Hamilton'

--Medium level--
--Show unique birth years from patients and order them by ascending.--
SELECT DISTINCT(YEAR(birth_date)) AS YEAR FROM patients
ORDER BY YEAR ASC

--Show unique first names from the patients table which only occurs once in the list.--
--For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.--
SELECT first_name FROM patients
GROUP BY first_name HAVING COUNT(*) <2

--Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.--
SELECT patient_id , first_name FROM patients
WHERE first_name LIKE 'S%____%s'

--Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.--
SELECT a.patient_id, first_name, last_name 
FROM patients p
JOIN admissions a ON a.patient_id = p.patient_id
WHERE diagnosis = 'Dementia'

--Display every patient's first_name. Order the list by the length of each name and then by alphabetically.--
SELECT first_name FROM patients
ORDER BY LEN(first_name) , first_name ASC

--Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.--
SELECT DISTINCT
    (SELECT COUNT(*) FROM patients WHERE gender = 'M') AS male_count,
	(SELECT COUNT(*) FROM patients WHERE gender = 'F') AS female_count
	
--Show first and last name, allergies from patients which have allergies to either 'Penicillin' or 'Morphine'. Show results ordered ascending by allergies then by first_name then by last_name.--
SELECT first_name, last_name, allergies FROM patients
WHERE allergies IN ('Penicillin', 'Morphine')
ORDER BY allergies, first_name ASC, last_name ASC

--Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.--
SELECT patient_id, diagnosis FROM admissions
GROUP BY patient_id, diagnosis
HAVING COUNT(diagnosis) > 1

--Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.--
SELECT city, COUNT(patient_id) AS patient_count FROM patients
GROUP BY city
ORDER BY patient_count DESC, city ASC

--Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"--
SELECT first_name, last_name, 'Patient' AS role FROM patients 
UNION ALL
select first_name, last_name, 'Doctor' AS role FROM doctors

--Show all allergies ordered by popularity. Remove NULL values from query.--
SELECT allergies, COUNT(allergies) AS total_diagnosis FROM patients
WHERE allergies IS NOT NULL
GROUP BY allergies
ORDER BY total_diagnosis DESC

--Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.--
SELECT first_name, last_name, birth_date FROM patients
WHERE birth_date >= '1970-01-01' AND birth_date <= '1979-12-31'
ORDER BY birth_date ASC

--We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order EX: SMITH,jane--
SELECT CONCAT(UPPER(last_name), ",",LOWER(first_name)) FROM patients
ORDER BY first_name DESC

--Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.--
SELECT province_id, SUM(CEIL(height)) FROM patients
GROUP BY province_id 
HAVING SUM(CEIL(height)) > 7000

--Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'--
SELECT (MAX(weight)-MIN(weight)) AS weight_delta FROM patients
WHERE last_name = 'Maroni'

--Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.--
SELECT dayDAY(admission_date) AS day_number, COUNT(*) AS number_of_admission FROM admissions
GROUP BY DAY(admission_date) 
ORDER BY COUNT(*) DESC

--Show all columns for patient_id 542's most recent admission_date.--
SELECT * FROM admissions
WHERE patient_id = 542 
GROUP BY patient_id
HAVING admission_date = MAX(admission_date)

--Show patient_id, attending_doctor_id, and diagnosis for admissions that match one of the two criteria: 1. patient_id is an odd number and attending_doctor_id is either 1, 5, or 19. 2. attending_doctor_id contains a 2 and the length of patient_id is 3 characters.--
SELECT patient_id, attending_doctor_id, diagnosis FROM admissions
WHERE patient_id % 2 <> 0 AND attending_doctor_id IN (1,5,19) 
OR attending_doctor_id LIKE '%2%' AND LEN(patient_id) = 3


--Show first_name, last_name, and the total number of admissions attended for each doctor.--
SELECT first_name, last_name, COUNT(*) FROM admissions
JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY doctor_id

--For each doctor, display their id, full name, and the first and last admission date they attended.--
SELECT doctor_id, CONCAT(first_name, " ", last_name) AS doctors_name, 
MIN(admission_date) AS first_admission,
MAX(admission_date) AS last_admission
FROM doctors
JOIN admissions ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY doctor_id
ORDER BY doctor_id ASC

--Display the total amount of patients for each province. Order by descending.--
SELECT COUNT(*), province_name FROM patients
JOIN province_names ON patients.province_id = province_names.province_id
GROUP BY province_name
ORDER BY COUNT(*) DESC

--For every admission, display the patient's full name, their admission diagnosis, and their doctor's full name who diagnosed their problem.--
SELECT 
	concat(p.first_name, " ", p.last_name) AS patients_name,
    diagnosis,
    concat(d.first_name, " ", d.last_name) AS doctors_name
FROM patients AS p
JOIN admissions AS a ON a.patient_id = p.patient_id
JOIN doctors AS d ON d.doctor_id = a.attending_doctor_id

--Display the first name, last name and number of duplicate patients based on their first name and last name. Ex: A patient with an identical name can be considered a duplicate.--
SELECT first_name, last_name, COUNT(*) AS number_of_duplicates FROM patients
GROUP BY first_name, last_name
HAVING COUNT(*) > 1

--Display patient's full name, height in the units feet rounded to 1 decimal, weight in the unit pounds rounded to 0 decimals, birth_date, gender non abbreviated. Convert CM to feet by dividing by 30.48. Convert KG to pounds by multiplying by 2.205.--
SELECT
  CONCAT (first_name, ' ', last_name) AS patient_name, 
  ROUND() (height/30.48, 1) AS height,
  ROUND(weight*2.205, 0) AS weight,
  birth_date,
  CASE
  WHEN gender = 'M' THEN 'MALE'
  WHEN gender = 'F' THEN 'FEMALE'
  END AS gender
FROM patients

--Show patient_id, first_name, last_name from patients whose does not have any records in the admissions table. (Their patient_id does not exist in any admissions.patient_id rows.)--
SELECT p.patient_id, first_name, last_name FROM patients AS p
LEFT JOIN admissions AS a ON p.patient_id= a.patient_id
WHERE a.patient_id IS NULL


---Hard level--
--Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.--
SELECT COUNT(patient_id) AS patients_in_group, FLOOR(weight/10) *10 AS weight_group FROM patients
GROUP BY FLOOR(weight/10) *10
ORDER BY FLOOR(weight/10) *10 DESC

--Show patient_id, weight, height, isObese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m)2) >= 30. weight is in units kg. height is in units cm.--
SELECT patient_id, weight, height, 
CASE 
WHEN weight/POWER(height*.01,2) >= 30 THEN '1'
WHEN weight/POWER(height*.01,2) <= 30 THEN '0'
END AS isObese
FROM patients

--Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.--
SELECT p.patient_id, p.first_name, p.last_name, d.specialty FROM patients p 
JOIN admissions a ON p.patient_id=a.patient_id
JOIN doctors d ON a.attending_doctor_id= d.doctor_id
WHERE diagnosis = 'Epilepsy' AND d.first_name = 'Lisa'

--All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.--
-- The password must be the following, in order: 1. patient_id 2. the numerical length of patient's last_name 3. year of patient's birth_date--
SELECT p.patient_id, 
concat(p.patient_id, len(p.last_name), YEAR(p.birth_date)) AS temp_password
FROM patients p
JOIN admissions a ON a.patient_id = p.patient_id
WHERE admission_date IS NOT NULL
GROUP BY p.patient_id

--Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.  Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.--
SELECT
CASE
WHEN patient_id % 2 = 0 THEN 'Yes' ELSE 'No'
END AS has_insurance,
CASE
WHEN patient_id % 2 = 0 THEN COUNT(admission_date)*10
WHEN patient_id % 2 != 0 THEN COUNT(admission_date)*50
END AS cost_after_insurance
FROM admissions
GROUP BY has_insurance

--Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name--
SELECT pn.province_name FROM patients p
JOIN province_names pn ON p.province_id= pn.province_id
GROUP BY pn.province_name
HAVING
	COUNT(CASE
      WHEN gender = 'M' THEN 1 END)>
	COUNT(CASE WHEN gender = 'F' THEN 1 END)
	
--We are looking for a specific patient. Pull all columns for the patient who matches the following criteria: - First_name contains an 'r' after the first two letters. - Identifies their gender as 'F'
--- Born in February, May, or December - Their weight would be between 60kg and 80kg - Their patient_id is an odd number - They are from the city 'Kingston'--
SELECT * FROM patients
WHERE 
  first_name LIKE '__r%' 
  AND gender = 'F' 
  AND MONTH(birth_date) IN (2, 5, 12) 
  AND weight BETWEEN 60 AND 80
  AND patient_id % 2 != 0 
  AND city = 'Kingston'