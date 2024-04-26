import ballerina/sql;
import ballerinax/mysql;
import ballerinax/mysql.driver as _;
import ballerina/io;

// Define configurable variables for MySQL configurations
configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string database = ?;
configurable int port = ?;

type Result record {
    string id;
    string firstName;
    string lastName;
};

public function main() returns error? {

    // Create a MySQL client to connect to the database
    mysql:Client mysqlClient = check new (
        host = host,
        user = user,
        password = password,
        database = database,
        port = port
    );

    stream<Result, sql:Error?> resultStream = mysqlClient->query(`SELECT id, firstName, lastName FROM Customers`);

    check from Result {id, firstName, lastName} in resultStream
        do {
            io:println("ID: " + id + ", Name: " + firstName + " " + lastName);
        };
    check resultStream.close();
}
