# certbot-dns-tencent
腾讯云certbot-dns使用方法

## 一、创建腾讯云 DNS 凭证文件

### 1️⃣ 在宿主机创建配置目录

```bash
mkdir -p /opt/certbot/tencent
chmod 700 /opt/certbot/tencent
```

### 2️⃣ 创建凭证文件

```bash
vim /opt/certbot/tencent/tencent.ini
```

内容如下：

```ini
dns_dnspod_api_id = 你的SecretId
dns_dnspod_api_token = 你的SecretKey
```

权限必须是：

```bash
chmod 600 /opt/certbot/tencent/tencent.ini
```

⚠️ **权限不对 certbot 会直接拒绝运行**

------

## 二、使用镜像申请证书（关键命令）

### 单域名示例

```bash
docker run --rm \
  -v /opt/certbot/tencent:/etc/letsencrypt \
  camel52zhang/certbot-dns-tencent certonly \
  --dns-dnspod \
  --dns-dnspod-credentials /etc/letsencrypt/tencent.ini \
  -d yourdomain.com \
  -d *.yourdomain.com \
  --agree-tos \
  --email youremailaddress@youremail.com \
  --non-interactive
```

证书生成后会在：

```
/opt/certbot/tencent/live/yourdomain.com/
```

------

## 三、自动续期（非常适合你 NAS / VPS）

### 方式一：cron（推荐）

```bash
crontab -e
0 3 * * * docker run --rm \
  -v /opt/certbot/tencent:/etc/letsencrypt \
  camel52zhang/certbot-dns-tencent renew
```

### 方式二：docker-compose（你 NAS 上会更舒服）

```yaml
version: "3.8"

services:
  certbot:
    image: camel52zhang/certbot-dns-tencent
    container_name: certbot-dns-tencent
    volumes:
      - /opt/certbot/tencent:/etc/letsencrypt
    command: renew
```

------

## 四、常见坑位（你一定会遇到的）

### ❌ 1. 提示 DNSPod 权限不足

👉 API 密钥没有 DNS 权限，去腾讯云重新建

### ❌ 2. TXT 记录没生效

👉 域名 **必须在 DNSPod 托管**
👉 私有 DNS / 第三方 DNS 不行

### ❌ 3. 权限错误

👉 `tencent.ini` 必须是 `600`



[阿里云certbot-dns](https://github.com/camel52zhang/certbot-dns-aliyun)

~~~
camel52zhang/certbot-dns-aliyun:latest
~~~

[cloudflare certbot-dns](https://github.com/camel52zhang/certbot-dns-cloudflare)

~~~
camel52zhang/certbot-dns-cloudflare:latest
~~~

