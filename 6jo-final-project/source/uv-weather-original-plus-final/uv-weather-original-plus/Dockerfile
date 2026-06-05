FROM debian:13

RUN apt-get update \
    && apt-get install -y --no-install-recommends cron curl jq ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY mycron /etc/cron.d/mycron
COPY uv-weather-original-plus/update_data.sh /app/uv-weather-original-plus/update_data.sh

RUN chmod 0644 /etc/cron.d/mycron \
    && crontab /etc/cron.d/mycron

CMD ["bash", "-lc", "bash /app/uv-weather-original-plus/update_data.sh && cron -f"]
