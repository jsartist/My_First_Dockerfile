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
RUN touch pwn01
RUN echo 'service sys01' >> pwn01
RUN echo '{' >> pwn01
RUN echo '   disable = no' >> pwn01
RUN echo '   flags = REUSE' >> pwn01
RUN echo '   socket_type = stream' >> pwn01
RUN echo '   protocol = tcp' >> pwn01
RUN echo '   wait = no' >> pwn01
RUN echo '   user = pwn01' >> pwn01
RUN echo '   server = /home/pwn01/hi' >> pwn01
RUN echo '}' >> pwn01

WORKDIR /etc
RUN echo "sys01         20101/tcp" >> services

WORKDIR /usr/local/bin
RUN touch start.bash
RUN echo '#!/bin/bash' >> start.bash
RUN echo 'echo "hi"' >> start.bash
RUN chmod 4755 start.bash

WORKDIR /home/pwn01