FROM alpine:3.10 as tippecanoe-builder

ARG TIPPECANOE_RELEASE="1.34.3"

RUN echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.8/main" > /etc/apk/repositories \
 && echo "https://mirror.tuna.tsinghua.edu.cn/alpine/v3.8/community" >> /etc/apk/repositories \
 && apk add --no-cache sudo git g++ make libgcc libstdc++ sqlite-libs sqlite-dev zlib-dev bash \
 && mkdir -p /code/tippecanoe \
 && cd /code/tippecanoe \
 && git clone https://github.com/mapbox/tippecanoe.git tippecanoe \
 && cd tippecanoe \
 && git checkout tags/$TIPPECANOE_RELEASE \
 && cd tippecanoe \
 && make -j2 \
 && make install

FROM osgeo/gdal:alpine-small-latest
COPY --from=tippecanoe-builder  /usr/local/bin /usr/local/bin


