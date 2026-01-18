CREATE TABLE covid_testing_statewise (
    state_union_territory VARCHAR(100) NOT NULL,
    report_date DATE NOT NULL,

    total_samples BIGINT,
    negative BIGINT,
    positive BIGINT,

    CONSTRAINT pk_testing_state_date
        PRIMARY KEY (state_union_territory, report_date)
);

ALTER TABLE covid_testing_statewise
RENAME TO testings;

select distinct(state_union_territory) from testings
order by state_union_territory

