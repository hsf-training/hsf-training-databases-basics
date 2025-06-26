---
title: "Intro to Grafana and mysql"
teaching: x
exercises: x
---


# Grafana Setup: Add MySQL Data Source (Local Testing)

## 1. Log in to Grafana
- Open your browser and go to [http://localhost:3000](http://localhost:3000).
- Log in using your admin credentials.

## 2. Add MySQL Data Source
- In the left sidebar, hover over the **Connections** icon (plug icon), then click **Data sources**.
- Click the **Add new data source** button.
- In the list, search for and select **MySQL**.

## 3. Configure Data Source Settings

| Setting               | Value / Example                  | Notes                                                                 |
|-----------------------|----------------------------------|-----------------------------------------------------------------------|
| **Name**              | `My MySQL DB`                    | Descriptive name for your data source.                                |
| **Host**              | `localhost`                      | Use IP or hostname. Port can be included here.                        |
| **Port**              | `3306`                           | Leave blank if specified in `Host`. Default: `3306`.                  |
| **Database**          | `your_database_name`             | Name of your MySQL database.                                          |
| **User**              | `grafana_user`                   | MySQL user that Grafana will use.                                     |
| **Password**          | `your_secure_password`           | Password for the MySQL user.                                          |
| **SSL Mode**          | `disable` *(for testing only)*   | Use `require`, `verify-ca`, or `verify-full` for production.          |

### 4. Optional Connection Settings (Defaults are usually fine)
- **Min time interval:** `1m` or `5s`
- **Max open connections:** `10`
- **Max idle connections:** `10`
- **Connection max lifetime:** `14400s`

## 5. Save and Test
- Click **Save & Test**.
- You should see the message: ✅ `Database Connection OK`.

## Notes
- 🔒 **SSL Mode**:
  - `disable`: No encryption. **Use only for local testing.**
  - `require`: Encrypted connection, no certificate verification.
  - `verify-ca`: Requires and verifies CA-signed cert.
  - `verify-full`: Requires full cert validation and hostname match.

- 📁 **For `verify-ca` or `verify-full`**, upload the CA certificate via Grafana UI.

- ✅ If connection fails, check:
  - MySQL is running and accessible from Grafana.
  - Correct database/user/password.
  - Grafana logs for detailed error messages.