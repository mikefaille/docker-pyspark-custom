# docker-pyspark-custom

This docker projet boostrap standalone and featurefull spark environment to develop ML.

## Quickstart


### To test hadoop:

0. Get dataset first : `./prepare.sh`

```
# Start shell on docker image :
docker run -v ./data:data -ti agileops/fastds-tutorial bash

# Start map/reduce job
 hadoop jar $HADOOP_HOME/hadoop-streaming.jar -input data -output out -mapper /bin/cat -reducer /bin/wc
```


### To run jupyter:

```
 CONTAINER_ID=$(docker run -d -ti -v data/data -p 8888:8888 agileops/fastds-tutorial)
 docker logs $CONTAINER_ID -f
```


Note : For compatibilities/accessibilities/simplicites against hardware and env. requirements, tensoflow and pytorch are configured without AVX and Cuda.



## Suggested datasets

To download theses datasets use the following command after cloning this repos.

```
./prepare.sh
```

Canada - Contrats octroyés 2009-ajd. 270 mo
https://ouvert.canada.ca/data/fr/dataset/53753f06-8b28-42d7-89f7-04cd014323b0

Montréal - Comptage sur les pistes cyclables
http://donnees.ville.montreal.qc.ca/dataset/velos-comptage
