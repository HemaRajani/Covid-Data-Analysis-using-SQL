--Use Covid_Data_Analysis;

--select * from [dbo].[covid-data]; 

--select* from [dbo].[vaccin-data];

--Total continents
select continent from [dbo].[covid-data]
where continent is not null
group by continent;

select distinct continent from [dbo].[covid-data]
where continent is not null;


--Overall worldwide cases
select sum(total_cases+new_cases) as WorldWIde_cases from [dbo].[covid-data]

--Total case population wise(in %)
Select location ,total_cases,(total_cases/population )*100 as total_case_population_wise,convert(date,date) as Date
from [dbo].[covid-data]
where location is not null
order by location,total_cases desc;

--Total population continent-wise
select continent,sum(population) as total_population_continent_wise
from [dbo].[covid-data]
group by continent
having continent is not null
order by continent;

--Highest cases
select continent,MAX(total_cases+new_cases) as Total_Cases
from [dbo].[covid-data]
group by continent
having continent is not null
order by 2 desc;

--Looking for Total Cases vs Population in United States
--On particular date against population total number of case increase in United States

select location,date,population,total_cases,(total_cases/population)*100 as Total_Cases_in_percent
from [dbo].[covid-data]
where location like '%states%'
order by date,location

--Fully Vacinated
select location as Location,sum(cast(people_vaccinated as float)) as First_Dose_Completed ,sum(people_fully_vaccinated) as Fully_Vaccinated from [dbo].[Vaccination-data]
where people_fully_vaccinated is not null
group by location
order by location;

--Fully Vacinated data for India
select A.location,A.date,total_cases,people_fully_vaccinated
from [dbo].[covid-data] as A
join
[dbo].[vaccin-data] as B
on A.location=B.location and A.date=B.date
where A.location ='India'
order by 1,2 desc;

--Top 3 continent total cases
select top 3 continent,sum(total_cases) as Total_cases
from [dbo].[covid-data]
where continent is not null
group by continent

--Delete null in continent
Delete from [dbo].[vaccin-data]
where continent is null

--Human_development_index 
select distinct A.continent,A.location,A.population,B.human_development_index
from [dbo].[covid-data] as A
inner join
[dbo].[vaccin-data] as B
on A.location=B.location and A.continent=B.continent
where A.population is not null
order by A.continent

--Level in covid(High is above 0.5 on estimate basis)(group by can be used but for list it cant be used)
select  distinct continent,(Positive_rate),
case
when Positive_rate between 0 and .5 then 'Low'
else'high'
end
as Level
from [dbo].[vaccin-data]
where positive_rate is not null
order by positive_rate desc


--Temp Table for total_deaths
---Drop table if exists Total_Death_till_Date
Create table Total_Death_till_Date
(continent nvarchar (255),
date datetime,
Total_deaths numeric
)

Insert into Total_Death_till_Date
select continent ,date ,sum(Total_deaths+new_deaths) as Total_deaths
from [dbo].[covid-data]
group by continent ,date
having continent='Asia'
order by date desc

Select SUM(total_deaths) as Total_deaths_in_Asia from Total_Death_till_Date



--Creating view for Vizualization
Create View TotalDeathtillDate as 
select continent ,sum(Total_deaths+new_deaths) as Total_deaths --,date 
from [dbo].[covid-data]
where continent is not null
group by continent --,date
--having continent='Asia'
--order by date desc

Select * from TotalDeathtillDate

--Drop view if exists TotalDeathtillDate