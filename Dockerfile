#----------------------------------
# Stage 1
#----------------------------------

# Import docker image with maven installed
FROM maven:3.8.3-openjdk-17 AS builder

# Set working directory
WORKDIR /src

# Copy source code from local to container
COPY . /src

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2
#--------------------------------------

# Import small size java image
FROM openjdk:17-alpine AS deployer

# Copy build from stage 1 (builder)
COPY --from=builder /src/target/*.jar /src/target/doctor-appointment.jar

# Expose application port
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/src/target/doctor-appointment.jar"]
