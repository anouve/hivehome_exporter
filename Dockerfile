FROM docker.io/library/golang:latest as builder
RUN mkdir /build
RUN mkdir -p /etc/hivehome_exporter
ADD . /build/
WORKDIR /build
RUN go mod tidy && go mod vendor
RUN CGO_ENABLED=0 go build ./hivehome_exporter.go


FROM scratch

COPY --from=builder /etc/hivehome_exporter /etc/hivehome_exporter
COPY --from=builder /build/hivehome_exporter /bin/hivehome_exporter
#COPY config.yaml  /etc/hivehome_exporter

EXPOSE     8000:8000
ENTRYPOINT [ "/bin/hivehome_exporter" ]
