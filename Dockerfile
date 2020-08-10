FROM maven:3.6.1-jdk-13-alpine AS build
WORKDIR /app
COPY src src
COPY pom.xml pom.xml
RUN \
  mvn package &&\
  jlink\
    --add-modules http.server.example\
    --compress=2\
    --module-path target/app.jar\
    --no-header-files\
    --no-man-pages\
    --output target/jre\
    --strip-debug

FROM alpine:3.12.0
COPY --from=build /app/target/jre /usr/jre
ENV PATH $PATH:/usr/jre/bin
WORKDIR /app
COPY --from=build /app/target/app.jar app.jar
EXPOSE 80
ENTRYPOINT ["java", "-jar", "app.jar"]
