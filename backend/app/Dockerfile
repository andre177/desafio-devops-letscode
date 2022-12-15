# using temurin image for performance purposes
FROM eclipse-temurin:11-jre
RUN mkdir /opt/app
COPY target/*.jar /opt/app/app.jar
EXPOSE 8080
CMD ["java", "-jar", "/opt/app/app.jar"]