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


#task2
cursor = connection.cursor()
show_tables_query = "SHOW tables" 
cursor.execute(show_tables_query)
print("query is : show tables")
results = cursor.fetchall()
cols = cursor.column_names
print("""Tables are:\n""")
for result in results:
    print(result)