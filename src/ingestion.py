from faker import Faker
import sqlite3

fake = Faker()
conn = sqlite3.connect('mydatabase.db')
cursor = conn.cursor()

for _ in range(5):
    customer_data = (
        None,
        fake.email(),
        fake.first_name(),
        fake.last_name(),
        fake.random_element(elements=('M', 'F')),
        fake.address(),
        fake.date_of_birth(minimum_age=18, maximum_age=65),
        fake.phone_number()
    )

    cursor.execute('INSERT INTO Customer VALUES (?, ?, ?, ?, ?, ?, ?, ?)', customer_data)

conn.commit()
conn.close()
