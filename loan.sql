use bank_loan;
show tables;

CREATE TABLE `loan` (
  `id` int DEFAULT NULL,
  `address_state` varchar(2),
  `application_type` varchar(10),
  `emp_length` varchar(10) ,
  `emp_title` varchar(100),
  `grade` varchar(1),
  `home_ownership` varchar(10),
  `issue_date` date,
  `last_credit_pull_date` date,
  `last_payment_date` date,
  `loan_status` varchar(15),
  `next_payment_date` date,
  `member_id` int DEFAULT NULL,
  `purpose` varchar(30),
  `sub_grade` varchar(2),
  `term` varchar(12),
  `verification_status` varchar(20),
  `annual_income` int ,
  `dti` float,
  `installment` float,
  `int_rate` float,
  `loan_amount` int ,
  `total_acc` int ,
  `total_payment` int
);

SELECT * 
FROM loan;

--- #Query1 finding duplicates

WITH cte AS
	(
	SELECT id , ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) AS rn
	FROM loan)
SELECT  * 
	FROM cte 
    WHERE rn >1;

---#Query2 Total Loan Application

SELECT COUNT(id) AS total_loan_application 
		FROM loan;
        
----#Query3 Total MTD Loan Application

SELECT COUNT(id) AS MTD_total_loan_application 
		FROM loan
        WHERE MONTH(issue_date)=12 
        AND YEAR(issue_date)=2021;

---#Query4 Total Funded_Amount 

Select sum(loan_amount) as Total_funded_amount 
from loan;

---#Query5 Total MTD Funded_Amount 

Select sum(loan_amount) as MTD_total_funded_amount 
from loan
where month(issue_date)=12
and year(issue_date)=2021;

---#Query6 Total Received Amount 

select sum(total_payment) as Total_received_amount 
from loan;

---#Query7 Total MTD Received Amount 

select sum(total_payment) as MTD_Total_received_amount 
from loan
where month(issue_date)=12
and year(issue_date)=2021;

---#Query8 Avg interest charges

select round(avg(int_rate)*100,2) as avg_interest_rate 
from loan;

---#Query9 MTD Avg interest charges

select round(avg(int_rate)*100,2) as avg_interest_rate 
from loan
where month(issue_date)=12 
and year(issue_date)=2021;

---#Query10  Avg DTI

Select round(avg(dti)*100,2) as avg_dti 
from loan;

---#Query11  MTD Avg DTI

Select round(avg(dti)*100,2) as MTD_avg_dti 
from loan
where month(issue_date)=12 
and year(issue_date)=2021;

---#Query12  Good Loan Percentage

select 
	round(count(case when loan_status = 'Fully Paid'
		or loan_status ='Current' then id end) *100/count(id)) as Good_loan_percentage
from loan;


---#Query13 count of good loan application

select count(id) as good_loan_application
from loan
where loan_status = 'Fully Paid' or loan_status ='Current' ;

---#Query14 total good loan funded amount

select sum(loan_amount) as good_loan_funded_amount
from loan
where loan_status = 'Fully Paid' or loan_status ='Current' ;

---#Query15 total good_loan_recieved_amount

select sum(total_payment) as good_loan_recieved_amount
from loan
where loan_status = 'Fully Paid' or loan_status ='Current' ;


---#Query16 Bad Loan Percentage

select 
	round(count(case when loan_status = 'Charged off' then id end) *100/count(id)) as Bad_loan_percentage
from loan;

---#Query17 count of bad loan application

select count(id) as bad_loan_application
from loan
where loan_status = 'Charged off';

---#Query18 total bad loan funded amount

select sum(loan_amount) as bad_loan_funded_amount
from loan
where loan_status = 'Charged off' ;

---#Query19 total bad_loan_recieved_amount

select sum(total_payment) as bad_loan_recieved_amount
from loan
where loan_status = 'Charged off' ;

---#Query20 loan status

select loan_status ,
	count(id) as total_loan_application,
	sum(loan_amount) as total_funded_amount,
	sum(total_payment) as total_amount_received,
	round(avg(int_rate*100),2) as interest_rate,
	round(avg(dti*100),2) as dti
from loan
group by loan_status
order by total_funded_amount desc , total_amount_received desc;


---#Query21 MTD loan status

select loan_status ,
	sum(loan_amount) as MTD_total_funded_amount,
	sum(total_payment) as MTD_total_amount_received	
from loan
where month(issue_date)=(select max(month(issue_date)) from loan)
and year(issue_date)=(select max(year(issue_date)) from loan)
group by loan_status
order by MTD_total_funded_amount desc , MTD_total_amount_received desc;

        
---#Query22 Monthly wise loan status

select 
	month(issue_date) as month,
	monthname(issue_date) as month_name,
    count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by month , month_name
order by month;

---#Query23 Address_state wise loan status , Highest total_funded_amount , Highest total_loan_application

select 
	address_state,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by address_state
order by total_funded_amount desc;

select 
	address_state,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by address_state
order by total_loan_application desc;


---#Query24 Analysis on the basis of Loan_Term 

select 
	term,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by term
order by term ;

---#Query25 Analysis on the basis of Employee_length 

select 
	emp_length,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by emp_length
order by total_funded_amount desc ;


---#Query26 Analysis on the basis of Purpose 

select 
	Purpose,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by Purpose
order by count(id) desc ;

---#Query27 Analysis on the basis of Home_ownership 

select 
	Home_ownership,
	count(id) as total_loan_application,
    sum(loan_amount) as total_funded_amount,
    sum(total_payment) as total_received_amount
from loan
group by Home_ownership
order by total_funded_amount desc ;




































