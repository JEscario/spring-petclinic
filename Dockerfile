FROM alpine/git:latest AS clone
ARG hostname=github.com
ARG username=JEscario
ARG project=spring-petclinic
WORKDIR /clone-folder
RUN git clone https://$hostname/$username/$project

FROM maven:alpine AS build
WORKDIR /build-folder
COPY --from=clone /clone-folder/spring-petclinic . 
RUN mvn install && mv target/spring-petclinic-*.jar target/spring-petclinic.jar

FROM openjdk:jre-alpine AS production
WORKDIR /production-folder
COPY --from=build /build-folder/target/spring-petclinic.jar .
ENTRYPOINT ["java","-jar"]
CMD ["spring-petclinic.jar"]
