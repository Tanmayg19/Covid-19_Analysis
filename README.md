# Covid-19_Analysis
Covid_19_Testing &amp; Vaccination Analysis
Project Title:
COVID‑19 Dynamics in India: Insights from an Excel Dashboard

Level : - Intermediate
Made by - Tanmay Gautam

Dataset Name:
●covid_19_india.csv

●covid_vaccine_statewise.csv

●StatewiseTestingDetails.csv

Tools & Technologies: SQL (PostgreSQL), Microsoft Excel, ETL for COVID‑19 Data Analytics



Section 1: Project Overview & Objectives

Project Overview
The COVID-19 pandemic significantly impacted India, presenting complex challenges across healthcare, governance, and public awareness. Large volumes of data were generated daily, including confirmed cases, recoveries, deaths, testing figures, and vaccination progress across states and union territories.
This project focuses on transforming raw COVID-19 datasets into meaningful insights using SQL for data processing and Excel for analysis and dashboard visualization. The aim is to provide a clear understanding of pandemic trends and state-wise impacts through interactive analytics.
Project Objectives
●To clean and transform raw COVID-19 data using SQL (ETL process)
●To analyze case trends, testing efficiency, and vaccination progress using Excel
●To build an interactive Excel dashboard for visual storytelling
●To identify key insights and actionable recommendations based on data

### 1. Database Setup


```sql

●CREATE TABLE covid_testing_statewise (
    state_union_territory VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,

    total_samples BIGINT,
    negative BIGINT,
    positive BIGINT,

    CONSTRAINT pk_testing_state_date
        PRIMARY KEY (state_union_territory, report_date)
);

ALTER TABLE covid_testing_statewise
RENAME TO testings;'''

'''sql

CREATE TABLE vaccinations (
    state_union_territory VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,

    total_doses_administered BIGINT,
    total_sessions_conducted INT,
    total_sites INT,

    first_dose_administered BIGINT,
    second_dose_administered BIGINT,

    male_doses BIGINT,
    female_doses BIGINT,
    transgender_doses BIGINT,

    covaxin_doses BIGINT,
    covishield_doses BIGINT,
    sputnikv_doses BIGINT,

    CONSTRAINT pk_vaccine_state_date
        PRIMARY KEY (state_union_territory, report_date)
);

ALTER TABLE vaccinations
ADD COLUMN age_18_44_doses BIGINT,
ADD COLUMN age_45_60_doses BIGINT,
ADD COLUMN age_60_plus_doses BIGINT,
ADD COLUMN precaution_dose_administered BIGINT,
ADD COLUMN total_individuals_vaccinated BIGINT,
ADD COLUMN total_individuals_vaccinated_dose2 BIGINT;

ALTER TABLE vaccinations
ADD COLUMN AEFI BIGINT;

ALTER TABLE vaccinations
DROP COLUMN age_18_44_doses,
DROP COLUMN age_45_60_doses,
DROP COLUMN age_60_plus_doses,
DROP COLUMN precaution_dose_administered;

ALTER TABLE vaccinations
DROP COLUMN male_doses,
DROP COLUMN female_doses,
DROP COLUMN transgender_doses,
DROP COLUMN covaxin_doses,
DROP COLUMN covishield_doses,
DROP COLUMN sputnikv_doses;

ALTER TABLE vaccinations
DROP COLUMN AEFI;
ALTER TABLE vaccinations
DROP COLUMN total_individuals_vaccinated_dose2;
select * from vaccinations

select distinct(state_union_territory) from cases
ORDER BY state_union_territory

select distinct(state_union_territory) from vaccinations
ORDER BY state_union_territory

select * from testings limit 10

SELECT
    COUNT(*) FILTER (WHERE confirmed IS NULL) AS null_confirmed,
    COUNT(*) FILTER (WHERE cured IS NULL) AS null_cured,
    COUNT(*) FILTER (WHERE deaths IS NULL) AS null_deaths
FROM cases;

select 
	count(*) filter (where negative is null) as null_negative,
	count(*) filter (where positive is null) as null_positive
from testings;

select 
	count(*) filter (where confirmed_indian_national is null) as null_indians,
	count(*) filter (where confirmed_foreign_national is null) as null_foreigners
from cases;

Update cases 
	set
		confirmed_indian_national = coalesce(confirmed_indian_national, 0),
		confirmed_foreign_national = coalesce(confirmed_foreign_national, 0);

select distinct(state_union_territory) from cases order by state_union_territory

update cases
set state_union_territory = 'Bihar'
where state_union_territory = 'Bihar****' 

UPDATE cases
SET state_union_territory = 'Dadra and Nagar Haveli and Daman and Diu'
WHERE state_union_territory = 'Dadra and Nagar Haveli And Daman And Diu'

UPDATE cases
SET state_union_territory = 'Himachal Pradesh'
WHERE state_union_territory = 'Himanchal Pradesh'

update cases
set state_union_territory = 'Karnataka'
where state_union_territory = 'Karanataka'

update cases
set state_union_territory = 'Madhya Pradesh'
where state_union_territory = 'Madhya Pradesh***'

update cases
set state_union_territory = 'Maharashtra'
where state_union_territory = 'Maharashtra***'

update cases
set state_union_territory = 'Telangana'
where state_union_territory = 'Telengana'

select distinct(state_union_territory) from cases order by state_union_territory

select * from cases limit 10
select * from testings limit 10
select * from vaccinations limit 10

select 
	count(*) filter (where total_individuals_vaccinated is null) as null_vaccinated,
	count(*) filter (where total_doses_administered is null) as null_doses,
	count(*) filter (where total_sessions_conducted is null) as null_sessions,
	count(*) filter (where first_dose_administered is null) as null_first_dose,
	count(*) filter (where second_dose_administered is null) as null_second_dose
from vaccinations;

update vaccinations
	set total_individuals_vaccinated = coalesce(total_individuals_vaccinated, 0),
		total_doses_administered = coalesce(total_doses_administered, 0),
		total_sessions_conducted = coalesce(total_sessions_conducted, 0),
		first_dose_administered = coalesce(first_dose_administered, 0),
		second_dose_administered = coalesce(second_dose_administered, 0);
		
select distinct(state_union_territory) from testings order by state_union_territory

delete from vaccinations
where state_union_territory = 'India'

delete from cases
where state_union_territory = 'Unassigned'

delete from cases
where state_union_territory = 'Cases being reassigned to states'

ALTER TABLE cases
ADD COLUMN daily_new_cases INTEGER;

WITH daily_calc AS (
    SELECT
        state_union_territory,
        report_date,
        confirmed,
        confirmed - LAG(confirmed) OVER (
            PARTITION BY state_union_territory
            ORDER BY report_date
        ) AS daily_new_cases
    FROM cases
)
UPDATE cases AS c
SET daily_new_cases = d.daily_new_cases
FROM daily_calc AS d
WHERE c.state_union_territory = d.state_union_territory
  AND c.report_date = d.report_date;


SELECT
    state_union_territory,
    report_date,
    confirmed,
    daily_new_cases
FROM cases
ORDER BY state_union_territory, report_date
LIMIT 20;

UPDATE cases
SET daily_new_cases = 0
WHERE daily_new_cases IS NULL; '''

'''sql
CREATE TABLE cases (
    sno INT PRIMARY KEY,
    report_date DATE,
    report_time VARCHAR(20),
    state_union_territory VARCHAR(100),
    confirmed_indian_national INT,
    confirmed_foreign_national INT,
    cured INT,
    deaths INT,
    confirmed INT
); '''

select distinct(state_union_territory) from testings
order by state_union_territory

'''sql
SELECT *
FROM cases
LIMIT 20;

ALTER TABLE cases
ADD COLUMN total_confirmed INTEGER;

update cases 
set total_confirmed = confirmed_indian_national + confirmed_foreign_national

select state_union_territory, confirmed_indian_national, confirmed_foreign_national, total_confirmed from cases 
order by confirmed_foreign_national desc limit 30

ALTER TABLE cases 
ADD COLUMN Case_Fatality_Rate INTEGER;

Alter table cases
alter column Case_Fatality_Rate type Numeric(6,2);

update cases
set Case_Fatality_Rate = ROUND(deaths * 100.0/NULLIF(confirmed, 0),2);

SELECT
    confirmed,
    deaths,
    case_fatality_rate
FROM cases
ORDER BY case_fatality_rate DESC
LIMIT 30;

Alter table cases
Rename to covid_cases

Alter table testings
Rename to covid_testings

select * from covid_testings limit 10

SELECT
    c.report_date,
    c.state_union_territory,

    -- Case metrics
    c.sno,
    c.deaths,
    c.cured,
    c.confirmed_indian_national,
	c.confirmed_foreign_national,
	c.confirmed,
	c.total_confirmed,
    c.daily_new_cases,
    c.case_fatality_rate,

    -- Testing metrics
    t.total_samples,
    t.positive,
    t.negative

FROM covid_cases c
LEFT JOIN covid_testings t
  ON c.state_union_territory = t.state_union_territory
 AND c.report_date = t.report_date
ORDER BY c.state_union_territory, c.report_date;

CREATE TABLE covid_summary (
    state VARCHAR(100) NOT NULL,
    date DATE NOT NULL,

    confirmed INTEGER,
    deaths INTEGER,
    cured INTEGER,
    daily_new_cases INTEGER,

    total_samples INTEGER,
    positive INTEGER,

    first_dose INTEGER,
    second_dose INTEGER,

    case_fatality_rate NUMERIC(6,2),

    PRIMARY KEY (state, date)
);

alter table vaccinations
rename to covid_vaccination

INSERT INTO covid_summary (
    state,
    date,
    confirmed,
    deaths,
    cured,
    daily_new_cases,
    total_samples,
    positive,
    first_dose,
    second_dose,
    case_fatality_rate
)
SELECT
    c.state_union_territory AS state,
    c.report_date AS date,

    c.confirmed,
    c.deaths,
    c.cured,
    c.daily_new_cases,

    SUM(t.total_samples) AS total_samples,
    SUM(t.positive) AS positive,

    MAX(v.first_dose_administered) AS first_dose,
    MAX(v.second_dose_administered) AS second_dose,

    c.case_fatality_rate

FROM covid_cases c
LEFT JOIN covid_testings t
  ON c.state_union_territory = t.state_union_territory
 AND c.report_date = t.report_date
LEFT JOIN covid_vaccination v
  ON c.state_union_territory = v.state_union_territory
 AND c.report_date = v.report_date

GROUP BY
    c.state_union_territory,
    c.report_date,
    c.confirmed,
    c.deaths,
    c.cured,
    c.daily_new_cases,
    c.case_fatality_rate;

SELECT
    state_union_territory,
    report_date,
    COUNT(*) AS cnt
FROM covid_cases
GROUP BY state_union_territory, report_date
HAVING COUNT(*) > 1;

TRUNCATE TABLE covid_summary;

INSERT INTO covid_summary (
    state,
    date,
    confirmed,
    deaths,
    cured,
    daily_new_cases,
    total_samples,
    positive,
    first_dose,
    second_dose,
    case_fatality_rate
)
SELECT
    c.state_union_territory AS state,
    c.report_date AS date,

    MAX(c.confirmed) AS confirmed,
    MAX(c.deaths) AS deaths,
    MAX(c.cured) AS cured,
    MAX(c.daily_new_cases) AS daily_new_cases,

    SUM(t.total_samples) AS total_samples,
    SUM(t.positive) AS positive,

    MAX(v.first_dose_administered) AS first_dose,
    MAX(v.second_dose_administered) AS second_dose,

    MAX(c.case_fatality_rate) AS case_fatality_rate

FROM covid_cases c
LEFT JOIN covid_testings t
  ON c.state_union_territory = t.state_union_territory
 AND c.report_date = t.report_date
LEFT JOIN covid_vaccination v
  ON c.state_union_territory = v.state_union_territory
 AND c.report_date = v.report_date

GROUP BY
    c.state_union_territory,
    c.report_date;

ALTER TABLE covid_summary
ADD COLUMN positive_test_rate NUMERIC(6,2);

UPDATE covid_summary
SET positive_test_rate =
    ROUND(positive * 100.0 / NULLIF(total_samples, 0), 2);

SELECT
    state,
    date,
    positive,
    total_samples,
    positive_test_rate
FROM covid_summary
ORDER BY positive_test_rate DESC
LIMIT 10;

CREATE TABLE state_population (
    state VARCHAR(100) PRIMARY KEY,
    population BIGINT NOT NULL
);

INSERT INTO state_population (state, population) VALUES
('Andhra Pradesh', 53903393),
('Arunachal Pradesh', 1570458),
('Assam', 35607039),
('Bihar', 124799926),
('Chhattisgarh', 29436231),
('Goa', 1542750),
('Gujarat', 63872399),
('Haryana', 28941133),
('Himachal Pradesh', 7305485),
('Jharkhand', 38593948),
('Karnataka', 67562686),
('Kerala', 35699443),
('Madhya Pradesh', 85358965),
('Maharashtra', 123144223),
('Manipur', 3091545),
('Meghalaya', 3366710),
('Mizoram', 1239244),
('Nagaland', 2249695),
('Odisha', 46356334),
('Punjab', 30141373),
('Rajasthan', 81032689),
('Sikkim', 690251),
('Tamil Nadu', 72147030),
('Telangana', 39362732),
('Tripura', 3990014),
('Uttar Pradesh', 237882725),
('Uttarakhand', 11250858),
('West Bengal', 99609303),

-- Union Territories
('Andaman and Nicobar Islands', 417036),
('Chandigarh', 1175113),
('Dadra and Nagar Haveli and Daman and Diu', 959729),
('Delhi', 19000000),
('Jammu and Kashmir', 13606320),
('Ladakh', 290492),
('Lakshadweep', 64473),
('Puducherry', 1504000);

Alter table covid_summary
add column vaccination_rate numeric(6,2); 

UPDATE covid_summary cs
SET vaccination_rate =
    ROUND(
        (COALESCE(cs.first_dose, 0) + COALESCE(cs.second_dose, 0)) * 100.0
        / NULLIF(sp.population, 0),
        2
    )
FROM state_population sp
WHERE cs.state = sp.state;

SELECT
    cs.state,
    cs.date,
    cs.first_dose,
    cs.second_dose,
    sp.population,
    cs.vaccination_rate
FROM covid_summary cs
JOIN state_population sp
  ON cs.state = sp.state
ORDER BY cs.vaccination_rate DESC
LIMIT 10;


ALTER TABLE covid_summary
ADD COLUMN vaccinations_rate NUMERIC(6,2);


UPDATE covid_summary cs
SET vaccinations_rate =
    ROUND(
        COALESCE(v.total_doses_administered, 0) * 100.0
        / NULLIF(sp.population, 0),
        2
    )
FROM covid_vaccination v
JOIN state_population sp
  ON v.state_union_territory = sp.state
WHERE cs.state = v.state_union_territory
  AND cs.date = v.report_date;

SELECT
    cs.state,
    cs.date,
    v.total_doses_administered,
    sp.population,
    cs.vaccinations_rate
FROM covid_summary cs
JOIN covid_vaccination v
  ON cs.state = v.state_union_territory
 AND cs.date = v.report_date
JOIN state_population sp
  ON cs.state = sp.state
ORDER BY cs.vaccinations_rate
LIMIT 10;

ALTER TABLE covid_summary
ADD COLUMN vaccination_rate NUMERIC(6,2);


ALTER TABLE covid_summary
ADD COLUMN risk_level VARCHAR(15);


UPDATE covid_summary
SET risk_level =
    CASE
        WHEN case_fatality_rate > 2
         AND positive_test_rate > 10
            THEN 'High Risk'

        WHEN case_fatality_rate > 2
          OR positive_test_rate > 10
            THEN 'Medium Risk'

        ELSE 'Low Risk'
    END;


SELECT
    state,
    date,
    case_fatality_rate,
    positive_test_rate,
    risk_level
FROM covid_summary
ORDER BY
    CASE risk_level
        WHEN 'High Risk' THEN 1
        WHEN 'Medium Risk' THEN 2
        ELSE 3
    END,
    case_fatality_rate DESC
LIMIT 20; '''
