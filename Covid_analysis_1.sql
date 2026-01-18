select * from cases limit 10

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
WHERE daily_new_cases IS NULL;











