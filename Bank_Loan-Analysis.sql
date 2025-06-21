create database Bank;
use Bank;
select * from bank_loan;
select count(*) from bank_loan;
#updating date column
ALTER TABLE bank_loan
ADD issue_date_fixed DATE,
ADD last_credit_pull_date_fixed DATE,
ADD last_payment_date_fixed DATE,
ADD next_payment_date_fixed DATE;
SET SQL_SAFE_UPDATES = 0;
UPDATE bank_loan
SET 
  issue_date_fixed = STR_TO_DATE(issue_date, '%d-%m-%Y'),
  last_credit_pull_date_fixed = STR_TO_DATE(last_credit_pull_date, '%d-%m-%Y'),
  last_payment_date_fixed = STR_TO_DATE(last_payment_date, '%d-%m-%Y'),
  next_payment_date_fixed = STR_TO_DATE(next_payment_date, '%d-%m-%Y');
  
  ALTER TABLE bank_loan
DROP COLUMN issue_date,
DROP COLUMN last_credit_pull_date,
DROP COLUMN last_payment_date,
DROP COLUMN next_payment_date;

ALTER TABLE bank_loan
CHANGE issue_date_fixed issue_date DATE,
CHANGE last_credit_pull_date_fixed last_credit_pull_date DATE,
CHANGE last_payment_date_fixed last_payment_date DATE,
CHANGE next_payment_date_fixed next_payment_date DATE;

#TOTAL LOAN APPLICATIONS:
select count(id) as total_no_application from bank_loan;

#TOTAL MONTH TO DATE LOAN APPLICATIONS :
select count(id) as mtd_total_loan_application 
from bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

#TOTAL PREVIOUS MONTH TO DATE LOAN APPLICATIONS :
select count(id) as pmtd_total_loan_application 
from bank_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

select * from bank_loan;

#TOTAL FUNDED AMOUNT
select sum(loan_amount) as total_funded_amount from bank_loan;

#TOTAL FUNDED AMOUNT MONTH TO DATE 
select sum(loan_amount) as mtd_total_funded_amount 
from bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

#TOTAL FUNDED AMOUNT PREVIOUS MONTH TO DATE 
select sum(loan_amount) as pmtd_total_funded_amount 
from bank_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

#TOTAl AMOUNT RECIEVED
select sum(total_payment) as total_amount_recieved from bank_loan;

#TOTAl AMOUNT RECIEVED MONTH TO DATE 
select sum(total_payment) as mtd_total_amount_recieved
from bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

#TOTAL AMOUNT RECIEVED PREVIOUS MONTH TO DATE 
select sum(total_payment) as pmtd_total_amount_recieved
from bank_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

#AVERAGE INTEREST RATE
select avg(int_rate) as average_intrest_rate from bank_loan;

#AVERAGE INTEREST RATE in percentage
select round(avg(int_rate),4)*100 as average_int_rate
from bank_loan;

#AVERAGE INTEREST RATE in percentage MONTH TO DATE
select round(avg(int_rate),4)*100 as mtd_average_int_rate
from bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021 ;

#AVERAGE INTEREST RATE in percentage previous month to date
select round(avg(int_rate),4)*100 as pm_average_int_rate
from bank_loan
where month(issue_date) = 11 and year(issue_date) = 2021 ;

#AVERAGE DTI RATIO
select round(avg(dti),4) * 100 as average_DTI from bank_loan;

#AVERAGE DTI RATIO MONTH TO DATE
select round(avg(dti),4) * 100 as mtd_average_DTI from bank_loan
where month(issue_date) = 12 and year(issue_date) = 2021;

#AVERAGE DTI RATIO PREVIOUS MONTH TO DAY
select round(avg(dti),4) * 100 as pmtd_average_DTI from bank_loan
where month(issue_date) = 11 and year(issue_date) = 2021;

select * from bank_loan;

#GOOD LOAN APPLICATION PERCENTAGE
select 
        (count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id
        end)*100)
        /
        count(id) as good_loan_application_percentage
from bank_loan;

#GOOD LOAN APPLICATION
select count(id) from bank_loan 
where loan_status = 'Fully Paid' or loan_status = 'Current';

#GOOD LOAD FUNDED_AMOUNT
SELECT SUM(loan_amount) as good_loan_funded_mount
FROM bank_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

#GOOD LOAN RECIEVED AMOUNT
SELECT sum(total_payment) as total_amount_recieved from bank_loan
where loan_status = 'Fully Paid' or loan_status = 'Current';

#TOTAL APPLICATION FOR BAD LOAN PERCENTAGE
select 
   (count(case when loan_status = 'Charged Off' then id end) * 100)/
   count(*) as bad_loan_percentage
   from bank_loan;
   
   # TOTAL BAD LOAN APPLICATIONS
   SELECT count(id) as bad_loan_application from bank_loan
   where loan_status = 'Charged Off' ;
   
# BAD LOAD FUNDED_AMOUNT
SELECT SUM(loan_amount) as BAD_loan_funded_mount
FROM bank_loan
where loan_status = 'Charged Off';


# BAD LOAD RECIEVED AMOUNT
SELECT SUM(total_payment) as total_amount_recieved
FROM bank_loan
where loan_status = 'Charged Off';

#LOAN STATUS
select loan_status, 
     count(id) as total_loan_applications,
     sum(total_payment) as total_amount_recieved,
     sum(loan_amount) as total_amount_funded,
     avg(int_rate * 100) as interest_rate,
     avg(dti * 100) as DTI
from bank_loan
group by loan_status;

#LOAN STATUS BY MONTH
select loan_status, 
     count(id) as total_loan_applications,
     sum(total_payment) as total_amount_recieved,
     sum(loan_amount) as total_amount_funded,
     avg(int_rate * 100) as interest_rate,
     avg(dti * 100) as DTI
from bank_loan
where month(issue_date) = 12
group by loan_status;

#MONTHLY LOAN DETAILS
select
	month(issue_date) as month_number,
     monthname(issue_date) as month_name,
     count(id) as total_loan_application,
     sum(loan_amount) as total_amount_funded,
      sum(total_payment) as total_amount_recieved
from bank_loan
group by month(issue_date) , monthname(issue_date)
order by month(issue_date);

#LOAN DETAILS BY ADDRESS
select
	address_state,
     count(id) as total_loan_application,
     sum(loan_amount) as total_amount_funded,
      sum(total_payment) as total_amount_recieved
from bank_loan
group by address_state
order by total_amount_funded DESC;

