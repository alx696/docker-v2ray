FROM alpine:3
WORKDIR /app

#下载v2ray
RUN apk update && \
  apk add --no-cache wget unzip && \
  wget -O version.json --header="Accept: application/vnd.github.v3+json" "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" && \
  VERSION_TAG=$(sed 'y/,/\n/' "version.json" | grep 'tag_name' | awk -F '"' '{print $4}') && \
  rm version.json && \
  DOWNLOAD_LINK="https://github.com/v2fly/v2ray-core/releases/download/$VERSION_TAG/v2ray-linux-64.zip" && \
  wget -O v2ray.zip $DOWNLOAD_LINK && \
  unzip v2ray.zip && \
  rm v2ray.zip && \
  apk del wget unzip

RUN apk update && \
  #设置时区
  apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apk del tzdata && \
  #链接日志
  touch /app/access.log && \
  touch /app/error.log && \
  ln -sf /dev/stdout /app/access.log && \
  ln -sf /dev/stderr /app/error.log
CMD ["/app/v2ray", "-config", "/app/config.json"]
