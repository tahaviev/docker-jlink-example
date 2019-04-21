FROM maven:3.6.1-jdk-12 AS build
WORKDIR /app
COPY src src
COPY pom.xml pom.xml
RUN ["mvn", "package"]
RUN ["jlink", "--add-modules", "http.server.example", "--compress=2",\
  "--module-path", "target/app.jar", "--no-header-files","--no-man-pages",\
  "--output", "target/jre", "--strip-debug"]

FROM frolvlad/alpine-glibc:alpine-3.9_glibc-2.29
COPY --from=build /app/target/jre /usr/jre
ENV PATH $PATH:/usr/jre/bin
WORKDIR /opt
COPY --from=build /app/target/app.jar app.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar"]
