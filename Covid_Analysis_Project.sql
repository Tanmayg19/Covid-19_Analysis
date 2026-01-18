CREATE TABLE cases (
    sno INT PRIMARY KEY,
    report_date DATE,
    report_time TIME,
    state_union_territory VARCHAR(100),
    confirmed_indian_national INT,
    confirmed_foreign_national INT,
    cured INT,
    deaths INT,
    confirmed INT
);

select * from cases limit 10

SELECT
    COUNT(*) FILTER (WHERE sno IS NULL) AS sno_nulls,
    COUNT(*) FILTER (WHERE report_date IS NULL) AS report_date_nulls,
    COUNT(*) FILTER (WHERE report_time IS NULL) AS report_time_nulls,
    COUNT(*) FILTER (WHERE state_union_territory IS NULL) AS state_nulls,
    COUNT(*) FILTER (WHERE confirmed_indian_national IS NULL) AS confirmed_indian_nulls,
    COUNT(*) FILTER (WHERE confirmed_foreign_national IS NULL) AS confirmed_foreign_nulls,
    COUNT(*) FILTER (WHERE cured IS NULL) AS cured_nulls,
    COUNT(*) FILTER (WHERE deaths IS NULL) AS deaths_nulls,
    COUNT(*) FILTER (WHERE confirmed IS NULL) AS confirmed_nulls
FROM cases;

UPDATE cases
SET
    confirmed_indian_national = COALESCE(confirmed_indian_national, 0),
    confirmed_foreign_national = COALESCE(confirmed_foreign_national, 0),
    cured = COALESCE(cured, 0),
    deaths = COALESCE(deaths, 0),
    confirmed = COALESCE(confirmed, 0);

select * from 

SELECT
    COUNT(*) FILTER (WHERE sno IS NULL) AS sno_nulls,
    COUNT(*) FILTER (WHERE report_date IS NULL) AS report_date_nulls,
    COUNT(*) FILTER (WHERE report_time IS NULL) AS report_time_nulls,
    COUNT(*) FILTER (WHERE state_union_territory IS NULL) AS state_nulls,
    COUNT(*) FILTER (WHERE confirmed_indian_national IS NULL) AS confirmed_indian_nulls,
    COUNT(*) FILTER (WHERE confirmed_foreign_national IS NULL) AS confirmed_foreign_nulls,
    COUNT(*) FILTER (WHERE cured IS NULL) AS cured_nulls,
    COUNT(*) FILTER (WHERE deaths IS NULL) AS deaths_nulls,
    COUNT(*) FILTER (WHERE confirmed IS NULL) AS confirmed_nulls
FROM cases;


ALTER TABLE cases
DROP CONSTRAINT cases_pkey1;

ALTER TABLE cases
ADD PRIMARY KEY (report_date, state_union_territory);

CREATE TABLE testings (
    report_date DATE NOT NULL,
    state_union_territory VARCHAR(100) NOT NULL,
    total_samples BIGINT,
    negative BIGINT,
    positive BIGINT,
    PRIMARY KEY (report_date, state_union_territory)
);

select total_samples from testings limit 10

SELECT
    COUNT(*) FILTER (WHERE report_date IS NULL) AS report_date_nulls,
    COUNT(*) FILTER (WHERE state_union_territory IS NULL) AS state_nulls,
    COUNT(*) FILTER (WHERE total_samples IS NULL) AS total_samples_nulls,
    COUNT(*) FILTER (WHERE negative IS NULL) AS negative_nulls,
    COUNT(*) FILTER (WHERE positive IS NULL) AS positive_nulls
FROM testings;

UPDATE testings
	set 
		negative = coalesce(negative, 0),
		positive = coalesce(positive, 0);
select * from testings limit 10

SELECT DISTINCT state_union_territory
FROM cases
ORDER BY state_union_territory;

SELECT
    state_union_territory,
    COUNT(*)
FROM cases
GROUP BY state_union_territory
ORDER BY state_union_territory;

UPDATE cases
SET state_union_territory = 'Dadra and Nagar Haveli and Daman and Diu' WHERE state_union_territory IN (
    'Dadra and Nagar Haveli',
    'Daman & Diu');

SELECT
    report_date,
    state_union_territory,
    COUNT(*)
FROM cases
GROUP BY report_date, state_union_territory
HAVING COUNT(*) > 1;

SELECT
    report_date,
    state_union_territory FROM cases
	where report_date = '2020-06-11' and state_union_territory = 'Daman & Diu'

DELETE FROM cases WHERE report_date = '2020-06-11' and state_union_territory = 'Daman & Diu'

UPDATE cases
SET state_union_territory = 'Bihar' WHERE state_union_territory = 'Bihar****';

UPDATE cases
	SET 
	state_union_territory = 'Himachal Pradesh' WHERE state_union_territory = 'Himanchal Pradesh' 

UPDATE cases set state_union_territory = 'Karnataka' WHERE state_union_territory = 'Karanataka'
UPDATE cases set state_union_territory = 'Madhya Pradesh' WHERE state_union_territory = 'Madhya Pradesh***'
UPDATE cases set state_union_territory = 'Maharashtra' WHERE state_union_territory = 'Maharashtra***'
UPDATE cases set state_union_territory = 'Telangana' WHERE state_union_territory = 'Telengana'

DELETE from cases where state_union_territory = 'Unassigned'
DELETE from cases where state_union_territory = 'Cases being reassigned to states'

SELECT
    state_union_territory,
    COUNT(*)
FROM testings
GROUP BY state_union_territory
ORDER BY state_union_territory;

CREATE TABLE vaccinations (
    report_date DATE NOT NULL,
    state_union_territory VARCHAR(100) NOT NULL,

    total_doses_administered BIGINT,
    sessions BIGINT,
    sites BIGINT,

    first_dose_administered BIGINT,
    second_dose_administered BIGINT,

    male_doses_administered BIGINT,
    female_doses_administered BIGINT,
    transgender_doses_administered BIGINT,

    covaxin_doses_administered BIGINT,
    covishield_doses_administered BIGINT,
    sputnik_v_doses_administered BIGINT,

    aefi BIGINT,

    doses_18_44 BIGINT,
    doses_45_60 BIGINT,
    doses_60_plus BIGINT,

    individuals_18_44 BIGINT,
    individuals_45_60 BIGINT,
    individuals_60_plus BIGINT,

    male_individuals_vaccinated BIGINT,
    female_individuals_vaccinated BIGINT,
    transgender_individuals_vaccinated BIGINT,

    total_individuals_vaccinated BIGINT,

    PRIMARY KEY (report_date, state_union_territory)
);

select * from vaccinations limit 10

SELECT
    state_union_territory,
    COUNT(*)
FROM vaccinations
GROUP BY state_union_territory
ORDER BY state_union_territory;

ALTER TABLE cases
ADD COLUMN daily_new_cases INT;

UPDATE cases c
SET daily_new_cases = sub.daily_new_cases
FROM (
    SELECT
        report_date,
        state_union_territory,
        confirmed
        - LAG(confirmed) OVER (
            PARTITION BY state_union_territory
            ORDER BY report_date
        ) AS daily_new_cases
    FROM cases
) sub
WHERE c.report_date = sub.report_date
  AND c.state_union_territory = sub.state_union_territory;

ALTER TABLE cases
ADD COLUMN total_confirmed INT;

UPDATE cases
SET total_confirmed =
    COALESCE(confirmed_indian_national, 0)
  + COALESCE(confirmed_foreign_national, 0);

select confirmed_indian_national, confirmed_foreign_national, total_confirmed from cases order by total_confirmed desc limit 20

ALTER TABLE cases
ADD COLUMN case_fatality_rate NUMERIC(6,2);

UPDATE cases
SET case_fatality_rate =
    ROUND(
        (COALESCE(deaths, 0) * 100.0)
        / NULLIF(COALESCE(confirmed, 0), 0),
        2
    );
	
SELECT
    state_union_territory,
    report_date,
    confirmed,
    deaths,
    case_fatality_rate
FROM cases
ORDER BY case_fatality_rate desc;

CREATE TABLE covid_final_summary AS
SELECT
    c.report_date,
    c.state_union_territory,

    -- All columns from cases except duplicate keys
    c.confirmed_indian_national,
    c.confirmed_foreign_national,
    c.confirmed,
    c.total_confirmed,
    c.cured,
    c.deaths,
    c.daily_new_cases,
    c.case_fatality_rate,

    -- All columns from testing except duplicate keys
    t.total_samples,
    t.positive,
    t.negative,

    -- All columns from vaccinations except duplicate keys
    v.total_doses_administered,
    v.sessions,
    v.sites,
    v.first_dose_administered,
    v.second_dose_administered,
    v.male_doses_administered,
    v.female_doses_administered,
    v.transgender_doses_administered,
    v.covaxin_doses_administered,
    v.covishield_doses_administered,
    v.sputnik_v_doses_administered,
    v.aefi,
    v.doses_18_44,
    v.doses_45_60,
    v.doses_60_plus,
    v.individuals_18_44,
    v.individuals_45_60,
    v.individuals_60_plus,
    v.male_individuals_vaccinated,
    v.female_individuals_vaccinated,
    v.transgender_individuals_vaccinated,
    v.total_individuals_vaccinated

FROM cases c
LEFT JOIN testings t
    ON c.report_date = t.report_date
   AND c.state_union_territory = t.state_union_territory
LEFT JOIN vaccinations v
    ON c.report_date = v.report_date
   AND c.state_union_territory = v.state_union_territory
ORDER BY c.state_union_territory, c.report_date;

SELECT COUNT(*) FROM cases;
SELECT COUNT(*) FROM covid_final_summary;

select * from state_population
