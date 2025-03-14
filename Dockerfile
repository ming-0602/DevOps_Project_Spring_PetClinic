FROM openjdk:17-jdk-slim
WORKDIR /app

# Ensure the JAR file is coming from the correct path
ARG JAR_FILE=target/spring-petclinic-3.4.0-SNAPSHOT.jar

# Copy the JAR from the build context
COPY ${JAR_FILE} app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
