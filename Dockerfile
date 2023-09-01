FROM anapsix/alpine-java
VOLUME /tmp
ADD target/petclinic.war app.war
EXPOSE 8080
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.war"]
