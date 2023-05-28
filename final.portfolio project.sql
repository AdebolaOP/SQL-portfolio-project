/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
      ,[new_tests]
      ,[total_tests]
      ,[total_tests_per_thousand]
      ,[new_tests_per_thousand]
      ,[new_tests_smoothed]
      ,[new_tests_smoothed_per_thousand]
      ,[positive_rate]
      ,[tests_per_case]
      ,[tests_units]
      ,[total_vaccinations]
      ,[people_vaccinated]
      ,[people_fully_vaccinated]
      ,[new_vaccinations]
      ,[new_vaccinations_smoothed]
      ,[total_vaccinations_per_hundred]
      ,[people_vaccinated_per_hundred]
      ,[people_fully_vaccinated_per_hundred]
      ,[new_vaccinations_smoothed_per_million]
      ,[stringency_index]
      ,[population]
      ,[population_density]
      ,[median_age]
      ,[aged_65_older]
      ,[aged_70_older]
      ,[gdp_per_capita]
      ,[extreme_poverty]
      ,[cardiovasc_death_rate]
      ,[diabetes_prevalence]
      ,[female_smokers]
      ,[male_smokers]
      ,[handwashing_facilities]
      ,[hospital_beds_per_thousand]
      ,[life_expectancy]
      ,[human_development_index]

	  select *
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  
  --selecting useful data for some calculation

  select location, date, total_cases, new_cases, total_deaths, population
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  order by 1,2

 --1; total cases vs total death

 select *
  FROM [new portfolio ].[dbo].[CovidDeaths$]


 select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as deathpercentage
  FROM [new portfolio ].[dbo].[CovidDeaths$]
 -- where location like'%canada%'
   where total_deaths is not null
  order by 1,2

  --total cases vs population
  --showing the percentage of population that got covid in the world and also specifically canada

  select location, date, total_cases, population, (total_cases/population)*100 as infectedpopulationpercentage
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  --where location like'%canada%'
  order by 1,2

  --looking at countries with the highest infection rate i.e max(totalcases) compared to population

   select location, max(total_cases) as highestinefectioncount, population, max((total_cases/population))*100 as infectedpopulationpercentage
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  group by location, population
  order by infectedpopulationpercentage desc

  --looking for the country with the highest deathcount

  select location, max(total_deaths) as highestdeathcount
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  group by location
  order by highestdeathcount desc

  --based on continent

   select continent, max(total_cases) as highestinefectioncount, max((total_cases/population))*100 as infectedpopulationpercentage
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  where continent is not null
  group by continent
  order by infectedpopulationpercentage desc



  select continent, max(total_cases) as highestinefectioncount, max(total_cases/(population)) *100 as infectedpopulationpercentage
  FROM [new portfolio ].[dbo].[CovidDeaths$]
  where continent is not null
  group by continent
  order by infectedpopulationpercentage desc

  --using the cast function to convert values to integer

  Select SUM(new_cases) as total_cases, SUM(cast(new_deaths_smoothed as int)) as total_deaths, SUM(cast(new_deaths_smoothed as int))/SUM(New_Cases)*100 as DeathPercentage
From  [new portfolio ].[dbo].[CovidDeaths$]
--Where location like '%states%'
where continent is not null 
order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths_smoothed as int)) as TotalDeathCount
From [new portfolio ].[dbo].[CovidDeaths$]
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc

select *
from [new portfolio ].[dbo].[CovidDeaths$]

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From [new portfolio ].[dbo].[CovidDeaths$]
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc



-- join queries with covid vaccination table


-- 1.
select *
from [new portfolio ].[dbo].[CovidVaccinations$]

Select dea.continent, dea.location, dea.date, dea.population
, MAX(vac.life_expectancy) as highestlifeexpectancy
--, (RollingPeopleVaccinated/population)*100
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
group by dea.continent, dea.location, dea.date, dea.population
order by 1,2




Select continent, Location, date, population, total_cases, total_deaths
From [new portfolio ].[dbo].[CovidDeaths$]
--Where location like '%states%'
where continent is not null 
order by 1,2


Select dea.continent, dea.location, dea.date, dea.population, vac.life_expectancy
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3


Select dea.continent, dea.location, dea.date, dea.population, vac.life_expectancy
, SUM(CONVERT(int,vac.life_expectancy)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as rollinglifeexpectancy
--, (RollingPeopleVaccinated/population)*100
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

--using CTE


With PopvsLE (Continent, Location, Date, Population, life_expectancy, Rollinglifeexpectancy)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.life_expectancy
, SUM(CONVERT(int,vac.life_expectancy)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rollinglifeexpectancy
--, (Rollinglifeexpectancy/population)*100
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (Rollinglifeexpectancy/Population)*100 as Percentlifeexpectancy
From PopvsLE


--temp table

drop table if exists #percentageoflifeexpectancy
Create Table #percentageoflifeexpectancy
(
continent nvarchar (255),
location nvarchar (255),
date datetime, 
population numeric,
life_expectancy numeric,
rollinglifeexpectancy numeric 
)
insert into  #percentageoflifeexpectancy
Select dea.continent, dea.location, dea.date, dea.population, vac.life_expectancy
, SUM(CONVERT(int,vac.life_expectancy)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rollinglifeexpectancy
--, (RollingPeopleVaccinated/population)*100
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (Rollinglifeexpectancy/Population)*100 as Percentlifeexpectancy
From #percentageoflifeexpectancy


create view percentageoflifeexpectanccy as
Select dea.continent, dea.location, dea.date, dea.population, vac.life_expectancy
, SUM(CONVERT(int,vac.life_expectancy)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as Rollinglifeexpectancy
--, (RollingPeopleVaccinated/population)*100
From [new portfolio ].[dbo].[CovidDeaths$] dea
Join [new portfolio ].[dbo].[CovidVaccinations$] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
