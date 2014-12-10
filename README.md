====================
HuntingForJobs: an API for accessing Tecoloco data
---------------------
[ ![Codeship Status for rojotic26/jobhuntersControllerData](https://codeship.com/projects/7b2dce80-62a1-0132-93ea-4e545b297600/status?branch=master)](https://codeship.com/projects/52110)


## Handles:

## URL in Heroku: http://jobhunterservice.herokuapp.com/

Brand New! API v2 routes!

- GET /
	- returns OK message, showing that the service is alive and wel

- GET /api/v2/job_openings/:category.json
	- returns JSON body containing job info of a certain category
	- Parameter (:category) should be a valid Tecoloco category, like "marketing"
	- Returns status code:
	  - 200 for success
		- 404 for not found

- GET /api/v2/job_openings/:category/city/:city.json
	- returns JSON body containing job info of a certain category within a city
	- Parameters
		- :category => should be a valid Tecoloco category, like "marketing"
		- :city => should be a valid Tecoloco city (country, actually) like El Salvador or Nicaragua
	- Returns status code:
		- 200 for success
		- 404 for not found

- GET /api/v2/offers/:id
	- retrieves offers info previously stored
	- Parameters
		- :id => id of the offer (1, 2, 3...)
	- Returns status code:
		- 200 for success
		- 404 for not found

- POST /api/v2/joboffers
	- record offer request to DB
		- category (string)
		- city (string)
	- Returns status code:
		- 200 for success
		- 400 for bad request

- DELETE /api/v2/joboffers/:id
	- Deletes an offer record
	- Parameters
		- :id => id of the offer (1, 2, 3...)
	- returns status code:
		-	200 for success
		-	404 for not found

API v1 Routes:

-	GET /*
	- returns deprecation message
	- returns status code 400



## Team Members

- Mauricio Jaime - mjboyarov@gmail.com / Nicaragua (毛里求 - 尼加拉瓜)
- Roger Gomez - rojotic26@gmail.com / Nicaragua (羅傑 - 尼加拉瓜)
- Edwin Mejia - eddwin@live.com / El Salvador (埃德温 - 薩爾瓦多)
