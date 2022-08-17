# README
This system was created for educational and evaluative purposes, is a simple ruby on rails application to simulate a parking operation


# HOW TO START?
To run the project you will only need docker and docker-compose
1- Clone the repository
2- In the project folder run: docker-compose up
3- After build, if this is your first time starting the project, run: docker-compose run web rails db:create db:migrate

# RUNNING UNIT TESTS
1- With the container instance 'db' and 'web' running, run: docker-compose run web bundle exec rspec -f d

# FUNCTIONAL TESTS
replace PLATE, with a plate of your choice in the format "AAA-9999"

1- TO RECORD A NEW ENTRY 
curl -X POST -d '{"plate": "PLATE"}' -H 'Content-type: application/json' http://127.0.0.1/parking

2- TO RECORD PAYMENT FOR A PLATE
curl -X PUT http://127.0.0.1/parking/PLATE/pay

3- TO RECORD EXIT FOR A PLATE
curl -X PUT http://127.0.0.1/parking/PLATE/out

4- TO SEE ALL RECORDS OF A PLATE
curl http://127.0.0.1/parking/PLATE