mvn clean install -DskipTests=true && docker build -t fluentd-led-integ-javaee-wildfly-swarm . && docker-compose up
