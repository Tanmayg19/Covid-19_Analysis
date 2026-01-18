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
);

ALTER TABLE covid_19
RENAME TO Cases;
