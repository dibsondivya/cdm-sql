
# Creating a database, tables and importing data
## 1: Create database
CREATE SCHEMA London_Paris_DB;

## 2: Create tables
USE London_Paris_DB; # indicate which database to create tables in
CREATE TABLE country_ids (
	country varchar(20) PRIMARY KEY,
    country_name varchar(20)
);

CREATE TABLE sample_characteristics (
	sample_id varchar(20) PRIMARY KEY,
    dob varchar(20),
    dor varchar(20),
    dod varchar(20),
    dodiag varchar(20),
    sex int, 
    cc_status int,
    smoke_status int,
    country varchar(20),
    center varchar(20),
    vit_status int,
    a_sta_smoke double,
    a_quit_smok double,
    age_recr double,
    n_cigret_lifetime double,
    FOREIGN KEY (country) REFERENCES country_ids(country)
);

CREATE TABLE sample_genotypes (
	sample_id varchar(20) PRIMARY KEY,
    SNP1 int,
    SNP2 int,
    SNP3 int,
    SNP4 int,
    SNP5 int,
    FOREIGN KEY (sample_id) REFERENCES sample_characteristics(sample_id)
);



# Exploring the data
## 5
	# count number of rows in each table via COUNT(*)
SELECT COUNT(*) FROM country_ids;
SELECT COUNT(*) FROM sample_characteristics;
SELECT COUNT(*) FROM sample_genotypes;

## 6.2: NULL values per attribute in sample_characteristics
	## loop CASE WHEN through every attribute in sample_characteristics
SELECT 
	SUM(CASE WHEN sample_id IS NULL then 1 ELSE 0 END) as sample_id,
	SUM(CASE WHEN dob IS NULL then 1 ELSE 0 END) as dob,
	SUM(CASE WHEN dor IS NULL then 1 ELSE 0 END) as dor,
	SUM(CASE WHEN dod IS NULL then 1 ELSE 0 END) as dod,
	SUM(CASE WHEN dodiag IS NULL then 1 ELSE 0 END) as dodiag,
	SUM(CASE WHEN sex IS NULL then 1 ELSE 0 END) as sex,
	SUM(CASE WHEN cc_status IS NULL then 1 ELSE 0 END) as cc_status,
	SUM(CASE WHEN smoke_status IS NULL then 1 ELSE 0 END) as smoke_status,
	SUM(CASE WHEN country IS NULL then 1 ELSE 0 END) as country,
	SUM(CASE WHEN center IS NULL then 1 ELSE 0 END) as center,
	SUM(CASE WHEN vit_status IS NULL then 1 ELSE 0 END) as vit_status,
	SUM(CASE WHEN a_sta_smoke IS NULL then 1 ELSE 0 END) as a_sta_smoke,
	SUM(CASE WHEN a_quit_smok IS NULL then 1 ELSE 0 END) as a_quit_smok,
	SUM(CASE WHEN age_recr IS NULL then 1 ELSE 0 END) as age_recr,
	SUM(CASE WHEN n_cigret_lifetime IS NULL then 1 ELSE 0 END) as n_cigret_lifetime
FROM sample_characteristics;



# Querying the data
## 7.1: Average age of recruiment per country rounded off to 2 dp
	## round via TRUNCATE
    
	# country: in country_ids
	# country_name: in country_ids
    # sample_id: in sample_characteristics
    
    # join sample_characteristics and country_ids on country as foreign key
SELECT ci.country, ci.country_name, TRUNCATE(AVG(sc.age_recr),2) AS avg_age_country
FROM country_ids ci
RIGHT JOIN sample_characteristics sc ON ci.country = sc.country
GROUP BY ci.country
ORDER BY ci.country ASC;

## 7.2: Country with largest number of samples
	# country: in country_ids
	# country_name: in country_ids
    # sample_id: in sample_characteristics
    
    # join sample_characteristics and country_ids on country as foreign key
SELECT ci.country, ci.country_name, COUNT(sc.sample_id) AS counts
FROM country_ids ci, sample_characteristics sc
WHERE ci.country = sc.country
GROUP BY ci.country
ORDER BY counts DESC;

## 7.3: Which center has least amount of samples
	# center: in sample_characteristics
    # sample_id: in sample_characteristics ## unique
SELECT center, COUNT(sample_id) as count
FROM sample_characteristics
GROUP BY center
ORDER BY count ASC
LIMIT 10; # since only first row is of interest

## 7.4: Country name of sample with youngest age of recruitment
	# country_name: in country_ids
	# sample_id: in sample_characteristics ## unique
    # age_recr: in sample_characteristics
    
    # join sample_characteristics and country_ids on country as foreign key
SELECT ci.country_name, sc.age_recr
FROM country_ids ci, sample_characteristics sc
WHERE ci.country = sc.country
ORDER BY sc.age_recr ASC
LIMIT 10; # since only first row is of interest

## 7.5: Name of country with largest amount of male samples
	# country_name: in country_ids
    # sex: in sample_characteristics
		# 1 is female
        # 2 is male ## we are interested in 2
    # sample_id: in sample_characteristics
    
	# join sample_characteristics and country_ids on country as foreign key
SELECT ci.country_name, COUNT(sc.sample_id) AS malecount
FROM country_ids ci, sample_characteristics sc
WHERE ci.country = sc.country AND sc.sex = 2
GROUP BY ci.country
ORDER BY malecount DESC;

## 7.6: Country with largest number of distinct centers
	# country_name: in country_ids
    # center: in sample_characteristics
		# find distinct via DISTINCT()
        # cound distinct via COUNT(DISTINCT())

	# join sample_characteristics and country_ids on country as foreign key
SELECT ci.country_name, COUNT(DISTINCT(sc.center)) AS centercount
FROM country_ids ci, sample_characteristics sc
WHERE ci.country = sc.country
GROUP BY ci.country
ORDER BY centercount DESC;

## 7.7: Country-center with largest number of samples
	# country_name: in country_ids
    # center: in sample_characteristics
    # sample_id: in sample_characteristics

	# join sample_characteristics and country_ids on country as foreign key
SELECT ci.country_name, sc.center, COUNT(sc.sample_id) as samplecount
FROM country_ids ci, sample_characteristics sc
WHERE ci.country = sc.country
GROUP BY ci.country, sc.center
ORDER BY samplecount DESC
LIMIT 10; # since only first row is of interest




# Creating new data from old data
## 8.1: Create table sample_char_genotypes that contains 500 genotype samples
	# from sample_genotypes: sample_id, SNP1, SNP2, SNP3, SNP4, SNP5
    # from sample_characteristics: dob, sex, cc_status, age_recr, country
    # from country_ids: country_name
    
	# join on foreign keys; country and sample_id
CREATE TABLE sample_char_genotypes
SELECT sg.sample_id, sc.dob, sc.sex, sc.cc_status, sc.age_recr, sc.country, ci.country_name, sg.SNP1, sg.SNP2, sg.SNP3, sg.SNP4, sg.SNP5
FROM country_ids ci, sample_characteristics sc, sample_genotypes sg
WHERE ci.country = sc.country AND sc.sample_id = sg.sample_id;


# END











