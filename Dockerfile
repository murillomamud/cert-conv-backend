# Estágio de construção (build)
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app

# Adiciona os arquivos de código-fonte necessários para realizar o build
COPY . /app

# Realiza o build da aplicação usando o Maven
RUN mvn clean package

# Estágio de execução
FROM amazoncorretto:17-alpine-jdk

RUN apk add --no-cache curl

WORKDIR /app

# Copia o JAR construído no estágio anterior para a imagem de execução
COPY --from=build /app/target/certificate-conversion.jar app.jar

# Define o comando de inicialização da aplicação Spring Boot
CMD ["java", "-jar", "app.jar"]
