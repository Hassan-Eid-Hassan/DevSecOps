FROM openjdk:11.0.11-slim
EXPOSE 8080
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]