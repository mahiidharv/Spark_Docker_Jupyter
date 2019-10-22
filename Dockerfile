FROM ubuntu:latest
FROM java:8-jdk
FROM python:3.7.4-stretch

# Set the working directory
WORKDIR /home/pyspark/pyspark_activities


#WORKDIR /home
ENV SPARK_VERSION=2.4.3
ENV HADOOP_VERSION=2.7
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1

USER root
RUN apt-get update


RUN apt-get install -y curl bash \
      && wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && tar -xvzf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      && mkdir /usr/local/spark \
      && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}/* /usr/local/spark \
      && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
      #&& cd /css \
      #&& jar uf /spark/jars/spark-core_2.11-${SPARK_VERSION}.jar org/apache/spark/ui/static/timeline-view.css \
      && cd /

RUN apt-get install openjdk-8-jdk-headless -qq    

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN export JAVA_HOME
#ENV IPADDRESS=$ip_address
# Fix the value of PYTHONHASHSEED
# Note: this is needed when you use Python 3.3 or greater
ENV PYTHONHASHSEED 1
ENV PYSPARK_PYTHON python3
#ENV PYSPARK_DRIVER_PYTHON=python3


RUN pip install jupyter

ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS='notebook'
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.7-src.zip
# RUN pip3 install pymongo
# RUN pip3 install requests
#COPY ./spark_streaming/app /app
#RUN ls /app
# RUN pip3 install --upgrade pip
#RUN pip3 install -r /app/requirements.txt

EXPOSE 8088
#Spark UI
EXPOSE 4040
CMD ["jupyter","notebook","--no-browser","--ip=0.0.0.0","--port=8088","--allow-root"]
