FROM openjdk:17-jdk-slim
WORKDIR /app
COPY spring-petclinic-3.4.0-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
