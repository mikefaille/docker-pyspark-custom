# docker-pyspark-custom

This docker projet boostrap standalone and featurefull spark environment to develop ML.

## Quickstart

```
CONTAINER_ID=$(docker run -d -ti -p 8888:8888 mikefaille/pyspark-custom)
docker logs $CONTAINER_ID -f
```

Note : For compatibilities/accessibilities/simplicites against hardware and env. requirements, tensoflow and pytorch are configured without AVX and Cuda.
