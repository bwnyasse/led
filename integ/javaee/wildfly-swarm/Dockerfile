FROM java:openjdk-8u91-jre
EXPOSE 8080
ADD /target/*swarm.jar /usr/src/myapp/app.jar
WORKDIR /usr/src/myapp
ENTRYPOINT ["java","-jar","app.jar"]
CMD [""]
