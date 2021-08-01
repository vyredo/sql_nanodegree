## Udiddit Social Media Database

- In this project I learn to migrate an existing database
- The original database is denormalize
- I have hands on experience to start redesign the database into normalize form
- Trying to migrate an existing database into the new schema.
- Below is the ERD for the new Database <br />
  <br />
  ![Udiddit ERD](/udiddit/ERD.png)

- These are the length of each table after migration <br />
  ```
  select count (*) from users; --11077
  select count (*) from topics; --89
  select count (*) from posts; -- 49849
  select count (*) from votes; -- 498186
  select count (*) from comments; -- 99720
  ```
