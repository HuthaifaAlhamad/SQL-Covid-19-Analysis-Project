SELECT SUM(new_cases) AS total_cases
	,SUM(cast(new_deaths AS INT)) AS total_deaths
	,SUM(cast(new_deaths AS INT)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
WHERE continent IS NOT NULL
GROUP BY DATE
ORDER BY 1
	,2

SELECT location
	,SUM(cast(new_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
WHERE continent IS NULL
	AND location NOT IN (
		'World'
		,'European Union'
		,'International'
		)
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT Location
	,Population
	,MAX(total_cases) AS HighestInfectionCount
	,Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
--Where location like '%states%'
GROUP BY Location
	,Population
ORDER BY PercentPopulationInfected DESC

SELECT Location
	,Population
	,DATE
	,MAX(total_cases) AS HighestInfectionCount
	,Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
--Where location like '%states%'
GROUP BY Location
	,Population
	,DATE
ORDER BY PercentPopulationInfected DESC

SELECT dea.continent
	,dea.location
	,dea.DATE
	,dea.population
	,MAX(vac.total_vaccinations) AS RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
JOIN CovidVaccinations vac ON dea.location = vac.location
	AND dea.DATE = vac.DATE
WHERE dea.continent IS NOT NULL
GROUP BY dea.continent
	,dea.location
	,dea.DATE
	,dea.population
ORDER BY 1
	,2
	,3

SELECT SUM(new_cases) AS total_cases
	,SUM(cast(new_deaths AS INT)) AS total_deaths
	,SUM(cast(new_deaths AS INT)) / SUM(New_Cases) * 100 AS DeathPercentage
FROM CovidDeaths
--Where location like '%states%'
WHERE continent IS NOT NULL
--Group By date
ORDER BY 1
	,2

SELECT location
	,SUM(cast(new_deaths AS INT)) AS TotalDeathCount
FROM CovidDeaths
--Where location like '%states%'
WHERE continent IS NULL
	AND location NOT IN (
		'World'
		,'European Union'
		,'International'
		)
GROUP BY location
ORDER BY TotalDeathCount DESC

SELECT Location
	,Population
	,MAX(total_cases) AS HighestInfectionCount
	,Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM CovidDeaths
--Where location like '%states%'
GROUP BY Location
	,Population
ORDER BY PercentPopulationInfected DESC

-- took the above query and added population
SELECT Location
	,DATE
	,population
	,total_cases
	,total_deaths
FROM CovidDeaths
--Where location like '%states%'
WHERE continent IS NOT NULL
ORDER BY 1
	,2
WITH PopvsVac(Continent, Location, DATE, Population, New_Vaccinations, RollingPeopleVaccinated) AS (
		SELECT dea.continent
			,dea.location
			,dea.DATE
			,dea.population
			,vac.new_vaccinations
			,SUM(CONVERT(INT, vac.new_vaccinations)) OVER (
				PARTITION BY dea.Location ORDER BY dea.location
					,dea.DATE
				) AS RollingPeopleVaccinated
		--, (RollingPeopleVaccinated/population)*100
		FROM CovidDeaths dea
		JOIN CovidVaccinations vac ON dea.location = vac.location
			AND dea.DATE = vac.DATE
		WHERE dea.continent IS NOT NULL
		)

--order by 2,3
SELECT *
	,(RollingPeopleVaccinated / Population) * 100 AS PercentPeopleVaccinated
FROM PopvsVac

SELECT Location
	,Population
	,DATE
	,MAX(total_cases) AS HighestInfectionCount
	,Max((total_cases / population)) * 100 AS PercentPopulationInfected
FROM.CovidDeaths
--Where location like '%states%'
GROUP BY Location
	,Population
	,DATE
ORDER BY PercentPopulationInfected DESC