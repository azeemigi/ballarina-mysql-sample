import ballerinax/mysql;
import ballerina/config;
import ballerina/io;

// Define configurable variables for MySQL configurations
configurable string host = ?;
configurable string user = ?;
configurable string password = ?;
configurable string database = ?;
configurable int port = ?;

type Result record {
    string registrationId;
    string firstName;
    string lastName;
};

public function main() {

    // Create a MySQL client to connect to the database
    mysql:Client mysqlClient = check new (
        host = host,
        user = user,
        password = password,
        database = database,
        port = port
    );

    stream<Result, error?> resultStream = mysqlClient->query("SELECT id, firstName, lastName FROM Customers");

    check from Result {id, firstName, lastName} in resultStream
    do {
        io:println("ID: " + id + ", Name: " + firstName + " " + lastName);
    }
    but {
        io:println("Error querying the database: " + error?.message);
    }
}
