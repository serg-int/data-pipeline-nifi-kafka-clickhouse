### Проблема (nifi и clickhouse не запустились):
```bash
Processing configuration file '/etc/clickhouse-server/config.xml'.
Logging trace to /var/log/clickhouse-server/clickhouse-server.log
Logging errors to /var/log/clickhouse-server/clickhouse-server.err.log

sed: can't read /opt/nifi/nifi-current/conf/nifi.properties: No such file or directory
File [/opt/nifi/nifi-current/conf/nifi.properties] replacing [nifi.web.https.port]
```

Проблема в том, что контейнеры не могут найти необходимые конфигурационные файлы, так как вы не создали соответствующие директории и файлы на хосте перед запуском. Давайте это исправим:

### Решение проблемы:

1. **Создайте необходимые директории** (выполните на хосте):
```bash
mkdir -p \
  ./nifi/conf \
  ./nifi/database_repository \
  ./nifi/flowfile_repository \
  ./nifi/content_repository \
  ./nifi/provenance_repository \
  ./clickhouse/data \
  ./clickhouse/config
```

2. **Для ClickHouse** добавьте базовый конфиг:

Создайте файл `./clickhouse/config/config.xml` со следующим содержимым:
```xml
<yandex>
    <listen_host>0.0.0.0</listen_host>
    <logger>
        <level>trace</level>
        <log>/var/log/clickhouse-server/clickhouse-server.log</log>
        <errorlog>/var/log/clickhouse-server/clickhouse-server.err.log</errorlog>
    </logger>
</yandex>
```

И файл `./clickhouse/config/users.xml`:
```xml
<yandex>
    <users>
        <user>
            <password>password</password>
            <networks>
                <ip>::/0</ip>
            </networks>
            <profile>default</profile>
            <quota>default</quota>
        </user>
    </users>
</yandex>
```

3. **Для NiFi** нужно скопировать конфиги из контейнера:

Сначала временно запустите контейнер:
```bash
docker run --name nifi-temp -d apache/nifi:1.28.1
```

Затем скопируйте конфиги:
```bash
docker cp nifi-temp:/opt/nifi/nifi-current/conf/. ./nifi/conf/
docker stop nifi-temp && docker rm nifi-temp
```
