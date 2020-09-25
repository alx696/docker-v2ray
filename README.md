# 特点

* v2ray

# 运行示例

```
$ docker run -d --restart=always \
  -p 4444:4444 -p 4445:4445 \
  -v $PWD/v2ray.json:/app/config.json \
  --name v2ray xm69/v2ray
```

# 构建

```
$ docker build -t xm69/v2ray .
```
