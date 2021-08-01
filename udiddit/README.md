## Udiddit Social Media Database

- In this project I learn to migrate an existing database
- The original database is denormalize
- I have hands on experience to start redesign the database into normalize form
- Trying to migrate an existing database into the new schema.
- Below is the ERD for the new Database <br />
  <br />
  ![Udiddit ERD](/udiddit/ERD.png)

- These are the length of each table after migration <br />
  select count (_) from users; --11080 <br />
  select count (_) from topics; --91 <br />
  select count (_) from posts; -- 49849 <br />
  select count (_) from votes; -- 498189 <br />
  select count (\*) from votes; -- 99720
