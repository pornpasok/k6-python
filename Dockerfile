FROM loadimpact/k6:latest AS k6official

FROM alpine:3.13
RUN apk add --no-cache ca-certificates && \
    adduser -D -u 12345 -g 12345 k6
COPY --from=k6official /usr/bin/k6 /usr/bin/k6

# Python 
RUN echo "http://dl-8.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN apk --no-cache --update-cache add gcc gfortran python3 python3-dev py3-pip build-base wget freetype-dev libpng-dev openblas-dev
RUN ln -s /usr/include/locale.h /usr/include/xlocale.h
RUN pip install numpy pandas

COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt
# End Python

USER 12345
WORKDIR /home/k6
#ENTRYPOINT ["k6"]