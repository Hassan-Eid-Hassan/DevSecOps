FROM 28-ea-jdk
COPY ./target/*.jar test.jar
ENTRYPOINT ["java", "-jar", "test.jar"]