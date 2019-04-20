FROM maven:3.6.1-jdk-12 AS mvn
WORKDIR /opt/app
COPY src src
COPY pom.xml pom.xml
RUN mvn package

FROM openjdk:12.0.1-jdk-oracle AS jlink
WORKDIR /opt
COPY --from=mvn /opt/app/target/app.jar app/app.jar
RUN ["jlink", "--output", "jre", "--module-path", "app/app.jar", "--add-modules", "http.server.example"]

FROM frolvlad/alpine-glibc
COPY --from=jlink /opt /opt
ENV PATH $PATH:/opt/jre/bin
ENTRYPOINT ["java", "-jar", "/opt/app/app.jar"]
