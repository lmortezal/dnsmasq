FROM alpine:3.20 as builder

LABEL maintainer="github.com/lmortezal.ir"


RUN apk update && apk add build-base \
    libcap-dev \
    dbus-dev \
    --no-cache


    # COPY ./dnsmasq /src
    
ADD https://thekelleys.org.uk/dnsmasq/dnsmasq-2.90.tar.gz /src/
    
RUN tar -xvf /src/dnsmasq-2.90.tar.gz -C /src
    
WORKDIR /src/dnsmasq-2.90

ENV COPTS "-DNO_TFTP -DNO-DHCP"

RUN make && make PREFIX=/dnsmasq install

FROM alpine:3.20 

COPY --from=builder /dnsmasq/sbin/dnsmasq /usr/sbin/dnsmasq

COPY dnsmasq.conf /etc/dnsmasq.conf

CMD [ "/usr/sbin/dnsmasq" , "-q" ,"--log-facility=-", "-k" ,"-C", "/etc/dnsmasq.conf"]



