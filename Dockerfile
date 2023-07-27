FROM ubuntu:latest

MAINTAINER jayesh <sonawanejayesh2322@gmail.com>

RUN apk --update add nginx

COPY /var/lib/jenkins/workspace/viprofile-ci-pipeline /app

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]