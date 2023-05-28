/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [Country]
      ,[Year]
      ,[Status]
      ,[Life expectancy ]
      ,[Adult Mortality]
      ,[infant deaths]
      ,[Alcohol]
      ,[percentage expenditure]
      ,[Hepatitis B]
      ,[Measles ]
      ,[ BMI ]
      ,[under-five deaths ]
      ,[Polio]
      ,[Total expenditure]
      ,[Diphtheria ]
      ,[ HIV/AIDS]
      ,[GDP]
      ,[Population]
      ,[ thinness  1-19 years]
      ,[ thinness 5-9 years]
      ,[Income composition of resources]
      ,[Schooling]
  FROM [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']


  select *
  from [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']
 where year= '2015'

 
 update [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']
 set [ BMI ]= 0 where [ BMI ] is null 


 select country, status, [Life expectancy ], [Total expenditure], [Adult Mortality], [infant deaths]
 from [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']
 WHERE STATUS = 'Developing'
 group by country, status, [Life expectancy ], [Total expenditure], [Adult Mortality], [infant deaths]
 ORDER BY [Life expectancy ] DESC
  

  
 select year, Country, [Life expectancy ], status, [Total expenditure], [Adult Mortality], [infant deaths]
 from [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']
 group by Country,year, status, [Life expectancy ], [Total expenditure], [infant deaths]
order by [Status] 


select  year, Country, [Life expectancy ], status, [Total expenditure], [Adult Mortality], [infant deaths],
Case 
	when [Life expectancy ] >= '70' then 'high'
	else 'low'
	end AS 'LEVEL OF LE'
from [SQL PORTFOLIO 3].[dbo].['Life Expectancy Data$']
Where Year = 2015
order by [Life expectancy ] desc