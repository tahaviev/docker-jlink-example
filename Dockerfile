FROM maven:3.6.1-jdk-13-alpine AS build
WORKDIR /build
COPY src src
COPY pom.xml pom.xml
RUN \
  mvn compile &&\
  jlink\
    --add-modules http.server.example\
    --compress=2\
    --module-path target/classes\
    --no-header-files\
    --no-man-pages\
    --output target/jre\
    --strip-debug

FROM alpine:3.12.0
WORKDIR /app
COPY --from=build /build/target/jre jre
EXPOSE 80
ENTRYPOINT ["jre/bin/java", "--module", "http.server.example/com.github.tahaviev.Main"]
