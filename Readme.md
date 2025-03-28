# NiFi pipeline

### Описание пайплайна

Apache NiFi получает данные по API каждые 15 минут, обрабатывает их и записывает в Kafka, выступая в качестве продюсера. Затем NiFi, уже в роли консьюмера, извлекает данные из Kafka и загружает их в ClickHouse для хранения и анализа. Данные из ClickHouse могут быть визуализированы в Grafana или Metabase.

### Стек технологий:

 - Apache NiFi 
 - Apache Kafka 
 - ClickHouse (или PostgreSQL) 
 - Grafana (или Metabase) 
 - Docker 
 - Conduktor (UI для Kafka)

После запуска **docker-compose** сервисы будут доступны:
- NiFi UI: https://localhost:8443/nifi
- Kafka: localhost:29092 (с хоста) или kafka:9092 (из Docker-сети)
- Conduktor (UI для Kafka): http://localhost:8080 (При первом заходе мастер установки попросит создать администратора)
- ClickHouse: http://localhost:8123 для API-запросов и для DBeaver
- Metabase: http://localhost:3000 (При первом заходе мастер установки попросит создать администратора)
- Grafana: http://localhost:3001 (Стандартные учётные данные: admin/admin - попросит сменить пароль при первом входе)

***Если есть проблемы с запуском nifi или clickhouse, то читать тут >> ([nifi и clickhouse не запустились.md](https://github.com/serg-int/data-pipeline-nifi-kafka-clickhouse/blob/main/nifi%20%D0%B8%20clickhouse%20%D0%BD%D0%B5%20%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D1%82%D0%B8%D0%BB%D0%B8%D1%81%D1%8C.md))***

### NiFi pipeline состоит из 2-х частей:

 1. первая группа процессоров получает данные по API и отправляет их в топик в Kafka
 2. вторая группа процессоров считывает данные из Kafka и отправляет их в ClickHouse (или PostgreSQL)

За визуализацию витрины данных отвечает Grafana (или Metabase) - кому что больше нравится.

**Шаблоны NiFi для импорта готового pipeline находятся в папке backups.** Там же находятся драйверы для подключения к clickhouse / postgres.

По поводу подключению nifi к clickhouse. 
- Database Connection URL: jdbc:clickhouse://clickhouse:8123/default?compress=1&compress_algorithm=gzip
- Database Driver Class Name: com.clickhouse.jdbc.ClickHouseDriver
Без **"?compress=1&compress_algorithm=gzip"** в URL у меня данные в БД не записывались.

По поводу подключению nifi к postgres. 
- Database Connection URL: jdbc:postgresql://postgres:5432/mydatabase
- Database Driver Class Name: org.postgresql.Driver