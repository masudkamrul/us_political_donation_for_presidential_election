CREATE TABLE US_donation.all_presidential_donation_from_dec2019_nov2020 AS
    SELECT
     *
        FROM
          (
            SELECT * from `US_donation.dec2019_1`
            UNION ALL 
            SELECT * from `US_donation.dec2019_2`
            UNION ALL 
            SELECT * from `US_donation.jan2020_1`
            UNION ALL 
            SELECT * from `US_donation.jan2020_2`
            UNION ALL 
            SELECT * from `US_donation.feb2020_1`
            UNION ALL 
            SELECT * from `US_donation.feb2020_2`
            UNION ALL 
            SELECT * from `US_donation.feb2020_3`
            UNION ALL 
            SELECT * from `US_donation.feb2020_4`
            UNION ALL 
            SELECT * from `US_donation.mar2020_1`
            UNION ALL 
            SELECT * from `US_donation.mar2020_2`
            UNION ALL 
            SELECT * from `US_donation.apr2020_1`
            UNION ALL 
            SELECT * from `US_donation.apr2020_2`
            UNION ALL 
            SELECT * from `US_donation.may2020_1`
            UNION ALL 
            SELECT * from `US_donation.may2020_2`
            UNION ALL 
            SELECT * from `US_donation.jun2020_1`
            UNION ALL 
            SELECT * from `US_donation.jun2020_2`
            UNION ALL 
            SELECT * from `US_donation.jun2020_3`
            UNION ALL 
            SELECT * from `US_donation.jul2020_1`
            UNION ALL 
            SELECT * from `US_donation.jul2020_2`
            UNION ALL 
            SELECT * from `US_donation.jul2020_3`
            UNION ALL 
            SELECT * from `US_donation.aug2020_1`
            UNION ALL 
            SELECT * from `US_donation.aug2020_2`
            UNION ALL 
            SELECT * from `US_donation.aug2020_3`
            UNION ALL 
            SELECT * from `US_donation.aug2020_4`
            UNION ALL 
            SELECT * from `US_donation.aug2020_5`
            UNION ALL 
            SELECT * from `US_donation.sep2020_1`
            UNION ALL 
            SELECT * from `US_donation.sep2020_2`
            UNION ALL 
            SELECT * from `US_donation.sep2020_3`
            UNION ALL 
            SELECT * from `US_donation.sep2020_4`
            UNION ALL 
            SELECT * from `US_donation.sep2020_5`
            UNION ALL 
            SELECT * from `US_donation.sep2020_6`
            UNION ALL 
            SELECT * from `US_donation.sep2020_7`
            UNION ALL 
            SELECT * from `US_donation.oct2020_1`
            UNION ALL 
            SELECT * from `US_donation.oct2020_2`
            UNION ALL 
            SELECT * from `US_donation.oct2020_3`
            UNION ALL 
            SELECT * from `US_donation.oct2020_4`
            UNION ALL 
            SELECT * from `US_donation.oct2020_5`
            UNION ALL 
            SELECT * from `US_donation.oct2020_6`
            UNION ALL 
            SELECT * from `US_donation.oct2020_7`
            UNION ALL 
            SELECT * from `US_donation.oct2020_8`
            UNION ALL 
            SELECT * from `US_donation.oct2020_9`
            UNION ALL 
            SELECT * from `US_donation.oct2020_10`
            UNION ALL 
            SELECT * from `US_donation.oct2020_11`
            UNION ALL 
            SELECT * from `US_donation.nov2020_1`
            UNION ALL 
            SELECT * from `US_donation.nov2020_2`
            UNION ALL 
            SELECT * from `US_donation.nov2020_3`
            UNION ALL 
            SELECT * from `US_donation.nov2020_4`
            UNION ALL 
            SELECT * from `US_donation.nov2020_5`
            );


# Finding out colunm with NULL values
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE committee_id IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE committee_name IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE report_year IS NULL ; 
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE transaction_id IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE entity_type_desc IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_name IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_city IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_state IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_employer IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_occupation IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_id IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contribution_receipt_date IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contribution_receipt_amount IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_aggregate_ytd IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE fec_election_type_desc IS NULL ;
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE amendment_indicator_desc IS NULL ;


# new Column for Primary Key by merging transaction_id and Date 
SELECT 
	PRIMARY_KEY, 
  COUNT(*) as Duplicate_counts
FROM 
	(SELECT CONCAT(transaction_id, '_', DATE(contribution_receipt_date) ) as PRIMARY_KEY 
  from `US_donation.all_presidential_donation_from_dec2019_nov2020`)
GROUP BY PRIMARY_KEY
HAVING Duplicate_counts >1;


## Add the new column of PRIMARY KEY to my united Table 
-- Add a new column named 'primary_key' to the table
ALTER TABLE `US_donation.all_presidential_donation_from_dec2019_nov2020`
ADD COLUMN primary_key STRING;

-- Update the new column with values generated by the CONCAT function
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET primary_key = CONCAT(transaction_id, '_', DATE(contribution_receipt_date))
WHERE 1 = 1;

########
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`;

# Check duplicates rows in primary_key column 
SELECT SUM(duplicate_counts) as total_duplicates
FROM
 (
    Select primary_key, count(*) as duplicate_counts from `US_donation.all_presidential_donation_from_dec2019_nov2020`
    GROUP BY primary_key 
    HAVING duplicate_counts > 1 
 );

#removing all Dublicate rows by primary_key column from the Table 
DELETE FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`
WHERE primary_key IN (
    SELECT 
      primary_key 
    FROM 
      `US_donation.all_presidential_donation_from_dec2019_nov2020`
    GROUP BY primary_key
    HAVING COUNT(*) >1 
);


# Check if any duplicates rows in the primary_key column after removing duplicates  
SELECT SUM(duplicate_counts) as total_duplicates
FROM
 (
    Select primary_key, count(*) as duplicate_counts from `US_donation.all_presidential_donation_from_dec2019_nov2020`
    GROUP BY primary_key 
    HAVING duplicate_counts > 1 
 );

######
SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`;

# Fill all the NULL rows of contributor_city Column with “Unknown”
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_city = 'Unknown'
WHERE contributor_city IS NULL;

##contributor_city
# Check if there is any Null values in contributor_city column after filling out the Null values
SELECT contributor_city
FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`
where contributor_city is NULL;

##contributor_state
# Fill out the contributor_state column with 'UNKOWN' only where values in contributor_city  column is “Unknown” (done previously)
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_state = 'Unknown'
WHERE contributor_city = 'Unknown';

# Fill all other remaining NULL value in contributor_state Column With "Out_of_US" as these all cities are from Outside of US
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_state = 'Out_of_US'
WHERE contributor_state IS NULL;


## Check if there is any Null values in contributor_state column after filling out the Null values 
SELECT contributor_state
FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`
where contributor_state is NULL;

## contributor_employer
# Fill all the NULL values in contributor_employer Column With "Unknown"
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_employer = 'Unknown'
WHERE contributor_employer IS NULL;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_employer IS NULL ;



## contributor_occupation
# Fill all the NULL values in contributor_occupation Column With "Unknown"
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_occupation = 'Unknown'
WHERE contributor_occupation IS NULL;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_occupation IS NULL ;



## contributor_id
# Fill all the NULL values in contributor_id Column With "Unknown"
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET contributor_id = 'Unknown'
WHERE contributor_id IS NULL;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contributor_id IS NULL ;


## contribution_receipt_amount
# Removing the only row with Null Value in contribution_receipt_amount column
DELETE FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`
WHERE contribution_receipt_amount IS NULL;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE contribution_receipt_amount IS NULL ;



## fec_election_type_desc
# Fill all the NULL values in fec_election_type_desc Column With "Unknown"
UPDATE `US_donation.all_presidential_donation_from_dec2019_nov2020`
SET fec_election_type_desc = 'Unknown'
WHERE fec_election_type_desc IS NULL;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020` WHERE fec_election_type_desc IS NULL ;


## Removing the column contributor_id as it does not seem important 
ALTER TABLE `US_donation.all_presidential_donation_from_dec2019_nov2020`
DROP COLUMN contributor_id;

SELECT * FROM `US_donation.all_presidential_donation_from_dec2019_nov2020`