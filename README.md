# sql-challenges

## Setup 

* Install Postgres 14+
* Create a new database called `sql_challenge`.

## Challenge

* Update `schema/schema.sql` with the following enhancements: 
	* Introduce a new `type_id` to the `policies` table.
	* Add a foreign key reference from the `policies` table to the `carriers` table so we can make sure all policies are associated with a carrier.
	* Add any indexes that might be needed for the below reporting purposes.
* Apply the schema in the `schema/` folder to the database created during setup.
* Create an SQL script to populate the database with synthetic data:
  * A list of 10 `carriers`.
  * A list of 1k users.
  * A list of 5k policies.

* For each of the following tasks, add a new file to the `reports/` folder demonstrating a query that meets the needs of the report:
  * Total number of policies by carrier.
  * Total number of policies by type.
  * Total number of users grouped by policy count.

## Submission

To submit this challenge use the following steps:

* Fork this repository to your personal github account.
* Create a new branch with the above changes.
* Send in a pull request for review.

If you have any questions while attempting this challenge, open an issue on this repo with your question and we can discuss there.
