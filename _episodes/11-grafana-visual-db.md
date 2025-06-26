---
title: "Intro to Grafana and mysql"
teaching: x
exercises: x
---


Grafana Setup: 
Add MySQL Data SourceNow, let's configure Grafana to connect to your MySQL database.
- Log in to Grafana:Open your web browser and navigate to your Grafana instance (usually http://localhost:3000).
- Log in with an administrator account.
- Add Data Source:In the left-hand navigation menu, hover over the Connections icon (plug icon) and click Data sources.
- Click the Add new data source button.
  - In the "Add data source" list, search for and select MySQL.
  - Configure Data Source Settings:
    - `Name`: A descriptive name for your data source (e.g., My MySQL DB, Production MySQL).
    - `Host`: The hostname or IP address of your MySQL server (e.g., localhost:3306). If you specify the port in the host, you can leave the "Port" field blank.
    - `Port`: The port your MySQL server is listening on (default is 3306).
    - `Database`: The name of the database you want to connect to (e.g., your_database_name).
    - `User`: The username created for Grafana (e.g., grafana_user).
    - `Password`: The password for the Grafana user (your_secure_password).
    - SSL Mode:
      - `disable`: No SSL encryption (not recommended for production).
      - `require`: Encrypts communication, but doesn't verify the server certificate.
      - `verify-ca`: Encrypts and verifies the server certificate against a provided CA certificate.
      - `verify-full`: Encrypts, verifies the server certificate against a provided CA, and checks the hostname.For basic setup on a trusted local network, disable might be used for testing, but require or verify-ca/verify-full are highly recommended for production. If using verify-ca or verify-full, you'll need to upload the CA certificate.
      - `Min time interval`: A default minimum time interval for queries, often 1m (1 minute) or 5s (5 seconds).
      - `Max open connections`: Limit the number of open connections (default 10).
      - `Max idle connections`: Number of idle connections to keep (default 10).
      - `Connection max lifetime`: Maximum time a connection can be reused (default 14400s).
  - Save & Test:Click the Save & Test button at the bottom.You should see a message confirming "Database Connection OK". If not, review your settings and check Grafana logs for more details.