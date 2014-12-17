Monitoring in a box
=======================


Building
--------

    docker build -t omd .

Running
-------

    docker run --privileged -p 5000:5000 -it omd

Login
------

    firefox http://omdadmin:admin@localhost:5000/master


