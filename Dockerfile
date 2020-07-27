FROM ubuntu:latest
MAINTAINER jsartist
RUN apt-get update
RUN apt-get install -y xinetd nano gcc

RUN useradd -m -s /bin/bash pwn01

WORKDIR /home/pwn01
RUN touch hi.c
RUN echo '#include <stdio.h>' >> hi.c
RUN echo 'int main(){' >> hi.c
RUN echo '      printf("hello world");' >> hi.c
RUN echo '      return 0;' >> hi.c
RUN echo '}' >> hi.c
RUN cat hi.c | sed 's/world/world\\abc/gi' > hi2.c
RUN cat hi2.c | sed -e 's/abc/n/gi' > hi.c

RUN gcc hi.c -o hi
RUN chmod 750 hi
RUN chown root hi
RUN chgrp pwn01 hi

WORKDIR /etc/xinetd.d
RUN touch pwn1
RUN echo 'service pwn1' >> pwn1
RUN echo '{' >> pwn1
RUN echo '   disable = no' >> pwn1
RUN echo '   flags = REUSE' >> pwn1
RUN echo '   socket_type = stream' >> pwn1
RUN echo '   protocol = tcp' >> pwn1
RUN echo '   wait = no' >> pwn1
RUN echo '   user = pwn01' >> pwn1
RUN echo '   server = /home/pwn01/hi' >> pwn1
RUN echo '}' >> pwn1

WORKDIR /etc
RUN echo "pwn1         20201/tcp" >> services

WORKDIR /usr/local/bin
RUN touch start.bash
RUN echo '#!/bin/bash' >> start.bash
RUN echo 'echo "hi"' >> start.bash
RUN chmod 4755 start.bash

WORKDIR /home/pwn01
