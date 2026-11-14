FROM openjdk:11.0.11-slim
COPY ./target/*.jar test.jar
ENTRYPOINT ["java", "-jar", "test.jar"]