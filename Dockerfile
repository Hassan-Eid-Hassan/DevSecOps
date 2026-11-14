FROM openjdk
COPY ./target/*.jar test.jar
ENTRYPOINT ["java", "-jar", "test.jar"]