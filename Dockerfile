FROM alpine:3

#工作目录
WORKDIR /app

#环境变量
ENV MACHINE="64"

#执行命令
RUN \
  apk update && \
  #设置时区
  apk add --no-cache tzdata && \
  cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
  echo "Asia/Shanghai" > /etc/timezone && \
  apk del tzdata && \
  # 安装工具
  apk add --no-cache wget unzip && \
  # 构建V2Ray下载链接
  wget --header="Accept: application/vnd.github.v3+json" -O version.json "https://api.github.com/repos/v2fly/v2ray-core/releases/latest" && \
  VERSION_TAG="$(sed 'y/,/\n/' "version.json" | grep 'tag_name' | awk -F '"' '{print $4}')" && \
  rm version.json && \
  DOWNLOAD_LINK="https://github.com/v2fly/v2ray-core/releases/download/$VERSION_TAG/v2ray-linux-$MACHINE.zip" && \
  # 下载V2Ray
  wget -O v2ray.zip $DOWNLOAD_LINK && \
  unzip v2ray.zip && \
  rm v2ray.zip && \
  apk del wget unzip && \
  mkdir -p /var/log/v2ray/ && \
  touch /var/log/v2ray/access.log && \
  touch /var/log/v2ray/error.log && \
  ln -sf /dev/stdout /var/log/v2ray/access.log && \
  ln -sf /dev/stderr /var/log/v2ray/error.log

CMD ["/app/v2ray", "-config", "/app/config.json"]
