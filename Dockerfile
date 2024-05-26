FROM ubuntu:latest AS build

# Atualizar e instalar dependências
RUN apt-get update && \
    apt-get install openjdk-21-jdk -y && \
    apt-get install maven -y

# Criar diretório de trabalho
WORKDIR /app

# Copiar arquivos pom.xml e de configuração primeiro para cache
COPY pom.xml .

# Baixar dependências do Maven
RUN mvn dependency:go-offline

# Copiar o restante do código-fonte do projeto
COPY src ./src

# Construir o projeto
RUN mvn clean install

# Etapa final
FROM openjdk:21-jdk-slim

# Expor a porta
EXPOSE 8080

# Copiar o JAR compilado da etapa de build para a imagem final
COPY --from=build /app/target/todoList-0.0.1-SNAPSHOT.jar app.jar

# Comando de entrada
ENTRYPOINT ["java", "-jar", "app.jar"]
