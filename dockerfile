FROM tomcat:7.0
MAINTAINER "Prasad"
ADD  ./target/*.war /usr/local/tomcat/webapps/
CMD ["catalina.sh", "run"]