

use project;
alter table hr add Attrition_count varchar(10) after Attrition;
select * from hr2;
desc hr;

alter table hr modify Attrition_count int;
update hr set Attrition_count=1 where Attrition="yes";
update hr set Attrition_count=0 where Attrition="no";



######Total employees
create view Total_employee as
select count(*)  Total_employee	 from hr;

select * from Total_employee;
########## Attrition count

select "Attrition_Rate",count(employeecount)  as Number
 from hr
where attrition="yes" ;



###########Department wise attrition rate

select Department,
sum(attrition_count) as AttritionCount,
count(attrition) as TotalEmployees,
 concat(round(sum(attrition_count)/count(attrition)*100,2),"%") as Attrition_rate from hr group by department;
 
########## Attritionrate wise Monthly income

create view  Income as
select attrition_count,
case 
when monthlyincome  <10000 then "0-10000"
when monthlyincome  >10001 and monthlyincome <20000 then "10000-20000"
when monthlyincome >20001 and monthlyincome <30000 then "20000-30000"
when monthlyincome >30001 and monthlyincome <40000 then "30000-40000"
when monthlyincome > 40001 and  monthlyincome <50000 then "40000-50000"
else  "50000-60000"
end as Income_group 
from hr2 as h left outer join hr as e on ( h.EmployeeID=e.employeenumber)  ;

select* from income;
select Income_group as MonthlyIncome_Range ,sum(attrition_count) as Attrition_count
 from income
 group by income_group;
 
 ##########Average Hourly rate of Male Research Scientist
 select gender,jobrole,avg(hourlyrate)
 from hr
 where gender="Male" and jobrole="research scientist";
 
 ############Average working years for each department
 
 select Department,round(avg(yearsatCompany),2) as "Average working Years" from hr 
 left outer join hr2 on ( hr2.EmployeeID=hr.employeenumber)
 group by department;
 
 ###########Job Role Vs Work life balance
 
 create view  worklife as
select worklifebalance,jobrole,
case 
when worklifebalance=1 then "Poor"
when worklifebalance=2  then "Average"
when worklifebalance=3 then "Good"
else  "Excellence"
end as Worklife 
from hr2  left outer join hr on ( hr2.EmployeeID=hr.employeenumber)  ;
 
select jobrole,worklife,count(Worklife),
round(count(Worklife) /sum(count(Worklife)) over(partition by worklife) *100,2) as WorklifeBalanceRate
from Worklife  
group by jobrole,worklife order by worklife,jobrole;

########### Attrition rate Vs Year since last promotion relation

select YearsSinceLastPromotion , sum(attrition_count) as Attrition_Count,
concat(round(sum(attrition_count)/sum(sum(attrition_count))over()*100,2),"%" )as Attrition_Rate
from hr2  left outer join hr on ( hr2.EmployeeID=hr.employeenumber) 
group by YearsSinceLastPromotion
 order by YearsSinceLastPromotion ;