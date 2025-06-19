# Etapa 1: build da aplicação
FROM eclipse-temurin:21-alpine AS build

WORKDIR /app

COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN ./mvnw dependency:go-offline

COPY src ./src
RUN ./mvnw clean package -DskipTests

# Etapa 2: imagem final e leve
FROM eclipse-temurin:21-alpine

WORKDIR /app

COPY --from=build /app/target/eucomida-api*.jar eucomida-api.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "eucomida-api.jar"]
