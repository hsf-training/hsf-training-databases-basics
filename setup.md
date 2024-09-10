---
title: Setup
---
# MYSQL setup

We recommend using a Docker container to run your first MySQL server. This is the easiest way to get started and it works on all major operating systems (Linux, macOS, and Windows).

## Option 1: Use a Docker container

Please make sure you have docker installed and configured. You can follow the instructions at the
[Docker official documentation](https://docs.docker.com/get-docker/). To test your installation, execute
```bash
docker run hello-world
```

> ## Permission issues on Linux
> If you installed Docker Engine on Linux (instead of Docker Desktop), you will encounter an error while trying to run the above command that will look something like this.
> ```
> docker: permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Post "http://%2Fvar%2Frun%2Fdocker.sock/v1.24/containers/create": dial unix /var/run/docker.sock: connect: permission denied.
> ```
> To solve it you will need to run the commands with ``sudo`` or follow [these instructions](https://docs.docker.com/engine/install/linux-postinstall/#manage-docker-as-a-non-root-user).
{: .callout}

Once Docker is installed and configured, we will run a mySQL server using the
[official Docker image](https://hub.docker.com/_/mysql). We require to two ingredients to setup the MySQL server:
* A port number to communicate with the server. MySQL server uses port ``3306`` by default.
* A password for the root user.

Execute the following command to pull the image and run the MySQL server in a Docker container:
```bash
docker run -d --name=myfirst-sqlserver -p 3306:3306 --env="MYSQL_ROOT_PASSWORD=mypassword" mysql
```
Here we named the container as ``myfirst-sqlserver``. It is running on host ``localhost`` and port ``3306``.
A user with name ``root`` already exists with the password that you set in the environment variable ``MYSQL_ROOT_PASSWORD``.

> ## Port conflict issues
> If you run into a port conflict issue (because the port is already in use, for example), then you can map the port
> number to a different one. Something like port ``XXXX`` in ``-p XXXX:3306`` in the above Docker command.
{: .callout}

> ## Never use weak passwords in production!
> Probably obvious, but this is a friendly reminder. Use [strong passwords](https://security.harvard.edu/use-strong-passwords)
> when you are working with real data in databases that are accessible from outside your computer.
{: .callout}


To test that if everything is up and running, execute the following command:
```bash
docker exec -it myfirst-sqlserver bash -c "mysql -uroot -pmypassword"
```
you should see the mysql prompt as ``mysql>``. If yes, then everything is working.

You can type ``exit;`` in the mysql command prompt to exit.


## Option 2: Setup a MySQL server via Apptainer

If you are working on institutional computers, then you might not have the permission to install or run Docker.
In that case, you can use [Apptainer](https://apptainer.io/), which allows you to run containers in shared resources
without installing Docker. Chances are that you already have Apptainer available in institutional computers, check by
executing the following command:
```bash
apptainer --version
```

We will use the same image as in Option 1.
Apptainer images are readonly if overlayfs is not available, so we'll be mounting the socket and  database directories. This allows also for some persistency.
Depending on the system settings, unprivileged Apptainer may not be allowed to bind to ports, so we'll use a socket file to connect to the server.
First move to a local directory: the image is not small and disk access will be faster, e.g. `mkdir /scratch/<username>/mysql-apptainer; cd /scratch/<username>/mysql-apptainer`.
Then execute the following commands to run the MySQL server in an Apptainer instance (replace mypassword with your password):
```bash
echo "SET PASSWORD FOR 'root'@'localhost' = 'mypassword';" > .mysqlrootpw
mkdir -p ./mysql/var/lib/mysql/ ./mysql/run/mysqld
apptainer pull --name mysql.sif docker://mysql
apptainer instance start --bind ${PWD} --bind ${PWD}/mysql/var/lib/mysql/:/var/lib/mysql --bind ${PWD}/mysql/run/mysqld:/run/mysqld  ./mysql.sif mysql
apptainer instance list    # just to make sure the instance started
apptainer exec instance://mysql mysqld --initialize
apptainer exec instance://mysql mysqld --init-file=${PWD}/.mysqlrootpw &
```
The ``&`` at the end of the last command will make it run in the background. You can press enter after the logs are printed, and you will see that you can continue using the terminal. If you don't run the last command in background the terminal will be used by the server console and you'll have to use another terminal for other commands.

To test that if everything is up and running, execute the following command:
```bash
apptainer exec instance://mysql mysql -S /var/run/mysqld/mysqld.sock -u root -pmypassword
```
Remember to use it also throughout the tutorial instead of the docker command.

You may want to use a different password and a safer way to run mysql id to avoid to put the password in the command line, e.g. save in ``mysqlclient.ini`` the following:
```
[client]
password="mypassword"
```
And then run with (--defaults-extra-file must be the first option):
```bash
apptainer exec instance://mysql mysql --defaults-extra-file=mysqlclient.ini -S /var/run/mysqld/mysqld.sock -u root
```

If you are interested on learning more about Apptainer, take a look at the
[HSF Training on Apptainer](https://hsf-training.github.io/hsf-training-singularity-webpage/)


## Option 3: Use a MySQL server on a remote machine

If you have access to a remote machine with a MySQL server (provided by your university or your laboratory),
then you can use that.


## Option 4: Use a MySQL/MariaDB server installed on your computer

If you want to install MySQL server on your computer, then you can follow the instructions at the
[official documentation](https://dev.mysql.com/doc/refman/8.2/en/installing.html).

Or you can use [MariaDB](https://mariadb.org/), which is an open source fork of MySQL. You can follow the instructions
at the [official documentation](https://mariadb.org/). At the time of writing this document, both basic MySQL and MariaDB
commands are compatible with each other.


# Opensearch setup

```bash
docker run -d -p 9200:9200 -p 9600:9600 -e "discovery.type=single-node" -e "OPENSEARCH_INITIAL_ADMIN_PASSWORD=<custom-admin-password>" opensearchproject/opensearch:latest
```

Replace: `<custom-admin-password>` to a secure password of your choice.

> ## Choosing a safe password
> If you run with `-it` instead of `-d` and the password is not secure you will see the following message and the container will exit immediately.
>
> ```
> Password <your-admin-password> failed validation:
>
> < reason for failure >
>
> Please re-try with a minimum 8 character password and must contain at least one uppercase letter, one lowercase letter, one digit, and one special character that is strong. Password strength can be tested here: https://lowe.github.io/tryzxcvbn
> ```
> {: .output}
>
{: .callout}

To test that if everything is up and running, execute the following command:
```bash
curl https://localhost:9200 -ku 'admin:<custom-admin-password>'
```
