This repo contains a recipe for making a [Docker](http://docker.io) container
for Wordpress, using Linux, Apache and MySQL on Ubuntu running on IBM Power
servers. Additionally ssh server is also setup, allowing ssh based access to
the container. Further key-based ssh is setup for vagrant user, to help with
Vagrant usage. 

Before building this ensure you have created a local utopic image by following
these steps.  This is required since multi-architecture support is still not
there in docker hub
```
sudo debootstrap --components=main,universe utopic utopic
sudo tar -C utopic -c . | sudo docker import - local:utopic
```


To build, make sure you have Docker [installed](http://www.docker.io/gettingstarted/), clone this repo somewhere, and then run:
```
sudo docker build -rm -t <yourname>/wordpress .
```

Then run it, specifying your desired ports! Woo! 
```
sudo docker run --name wordpress -d -p <http_port>:80 <ssh_port>:22 <yourname>/wordpress 
```


Check docker logs after running to see MySQL root password and Wordpress MySQL password, as so

```
sudo echo $(docker logs wordpress | grep password)
```

(note: you won't need the mysql root or the wordpress db password normally)


Your wordpress container should now be live, open a web browser and go to http://localhost:<http_port>, then fill out the form. 
No need to mess with wp-config.php, it's been auto-generated with proper values. 


You can shutdown your wordpress container like this:
```
docker stop wordpress
```

And start it back up like this:
```
docker start wordpress
```

Enjoy your wordpress install courtesy of Docker!
