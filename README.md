# BetManager

## Setup

  * Create a `.env` file in the root folder, edit the variables like below.
      ```
        PORT=4000
        MIX_ENV=dev
        DB_USER=postgres
        DB_PASSWORD=postgres
        DB_DATABASE=bet_manager_dev
        DB_DATABASE_TEST=bet_manager_test
        DB_HOST=db
        DB_POOL=10
      ```
  * Run the application with `docker-compose up --build`
