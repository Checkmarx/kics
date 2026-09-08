from openjdk:10-jdk
volume /tmp
arg JAR_FILE
copy ${JAR_FILE} app.jar
entrypoint ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]
add http://source.file/package.file.tar.gz /temp
run tar -xjf /temp/package.file.tar.gz \
  && make -C /tmp/package.file \
  && rm /tmp/ package.file.tar.gz
# trigger validation
