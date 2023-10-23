import mysql.connector as connector
from mysql.connector import Error


try:
    connection = connector.connect(
        host="localhost",
        user="root",
        passwd="" ,
        db = "littlelemondb" 
    )
    print("Connection to littlelemondb was successful")
except Error as e:
    print(f"The error '{e}' occurred")


#task3
cursor = connection.cursor()
sql_query = """
select concat(FirstName,' ',LastName) as full_name , c.PhoneNumber , o.BillAmount 
from customers as c
left join bookings as b on c.CustomerID=b.CustomerID 
left join orders as o on o.BookingID = b.BookingID 
where o.BillAmount > 60 
"""
cursor.execute(sql_query)
results = cursor.fetchall()
cols = cursor.column_names
print(cols)
for result in results:
    print(result)