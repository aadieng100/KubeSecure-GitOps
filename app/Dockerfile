# Stage 1: Build the application using Maven
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /build

# Copy only the metadata and source files needed for compilation
COPY pom.xml .
COPY src ./src

# Package the application and skip unit tests for faster build
RUN mvn clean package -DskipTests

# Stage 2: Create the secure, lightweight runtime image
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# DevSecOps Best Practice: Create a dedicated non-root system user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Copy the compiled heavy artifact from the build stage
COPY --from=build /build/target/gitops-api-1.0.0.jar app.jar

# Ensure the non-root user owns the application files
RUN chown -R appuser:appgroup /app

# Switch context to the non-root user
USER appuser

# Expose the application port
EXPOSE 8080

# Run the application with optimized flag for graceful shutdown support
ENTRYPOINT ["java", "-jar", "app.jar"]
