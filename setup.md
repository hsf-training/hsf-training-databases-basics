---
title: Setup
---
We will be using docker to setup our database server. Please make sure you have docker installed and configured.
You can follow the [hsf-training-docker](https://hsf-training.github.io/hsf-training-docker/setup.html).

## mySQL docker container.
To run a mySQL server we will use mySQL docker image.
~~~bash
docker run -d --name=metadata -p 3306:3306 --env="MYSQL_ROOT_PASSWORD=mypassword" mysql
~~~
Here we named the container as ``metadata`` and your mysql server running on host ``localhost`` and port ``3306``.
A user with name ``root`` already exists with password you set as ``mypassword``.

> ## Port conflict issues
> If you run into port conflict issue. Then you can change the port number to other number in place of ``XXXX`` in ``-p xxxx:3306`` in above docker command.

To test that if everything is setup and working run the following command.
~~~bash
docker exec -it metadata bash -c "mysql -uroot -pmypassword"
~~~
you should see the mysql prompt as ``mysql>``. If yes then everything is working. You can type ``exit;`` in the mysql command prompt to exit.
