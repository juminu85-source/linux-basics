#!/usr/bin/env bash
set -euo pipefail

OUT_DIR="/app/data"
OUT_FILE="${OUT_DIR}/weather.json"
TMP_FILE="${OUT_FILE}.tmp"
REPORT_FILE="${OUT_DIR}/generated-report.html"
REPORT_TMP_FILE="${REPORT_FILE}.tmp"
API_URL="https://api.open-meteo.com/v1/forecast"

mkdir -p "${OUT_DIR}"

declare -a AREAS=(
  "1100000000|서울|37.5665|126.9780"
  "2800000000|인천|37.4563|126.7052"
  "4111000000|경기 남부|37.2636|127.0286"
  "4115000000|경기 북부|37.7381|127.0338"
  "5100000000|강원|37.8854|127.7298"
  "4300000000|충북|36.6357|127.4913"
  "4400000000|충남|36.6588|126.6728"
  "3600000000|세종|36.4801|127.2890"
  "3000000000|대전|36.3504|127.3845"
  "4700000000|경북|36.5760|128.5056"
  "2700000000|대구|35.8714|128.6014"
  "5200000000|전북|35.8203|127.1088"
  "2900000000|광주|35.1595|126.8526"
  "4600000000|전남|34.8161|126.4629"
  "4800000000|경남|35.2383|128.6924"
  "3100000000|울산|35.5384|129.3114"
  "2600000000|부산|35.1796|129.0756"
  "5000000000|제주|33.4996|126.5312"
)

updated_at="$(date '+%Y-%m-%d %H:%M:%S %Z')"
areas_json="{}"
success_count=0

for area in "${AREAS[@]}"; do
  IFS="|" read -r code name lat lon <<< "${area}"
  url="${API_URL}?latitude=${lat}&longitude=${lon}&current=temperature_2m,relative_humidity_2m,uv_index,wind_speed_10m&daily=uv_index_max&timezone=Asia%2FSeoul&forecast_days=3"

  if response="$(curl -fsSL --retry 3 --connect-timeout 10 --max-time 20 "${url}")"; then
    area_json="$(jq -n \
      --arg code "${code}" \
      --arg name "${name}" \
      --argjson temp "$(jq '.current.temperature_2m // 0' <<< "${response}")" \
      --argjson humidity "$(jq '.current.relative_humidity_2m // 0' <<< "${response}")" \
      --argjson wind "$(jq '.current.wind_speed_10m // 0' <<< "${response}")" \
      --argjson h0 "$(jq '.daily.uv_index_max[0] // .current.uv_index // 3' <<< "${response}")" \
      --argjson h24 "$(jq '.daily.uv_index_max[1] // .daily.uv_index_max[0] // 3' <<< "${response}")" \
      --argjson h48 "$(jq '.daily.uv_index_max[2] // .daily.uv_index_max[1] // 3' <<< "${response}")" \
      '{code:$code,name:$name,temp:$temp,humidity:$humidity,wind:$wind,h0:$h0,h24:$h24,h48:$h48}')"

    areas_json="$(jq --arg code "${code}" --argjson area "${area_json}" '. + {($code): $area}' <<< "${areas_json}")"
    success_count=$((success_count + 1))
  fi
done

jq -n \
  --arg updatedAt "${updated_at}" \
  --arg source "Open-Meteo API" \
  --argjson successCount "${success_count}" \
  --argjson totalCount "${#AREAS[@]}" \
  --argjson areas "${areas_json}" \
  '{updatedAt:$updatedAt,source:$source,successCount:$successCount,totalCount:$totalCount,areas:$areas}' \
  > "${TMP_FILE}"

mv "${TMP_FILE}" "${OUT_FILE}"

rows_html="$(jq -r '
  .areas
  | to_entries
  | sort_by(.value.name)
  | map("<tr><td>" + .value.name + "</td><td>" + (.value.temp|tostring) + "°C</td><td>" + (.value.humidity|tostring) + "%</td><td>" + (.value.wind|tostring) + " km/h</td><td>" + (.value.h0|tostring) + "</td></tr>")
  | join("\n")
' "${OUT_FILE}")"

cat > "${REPORT_TMP_FILE}" <<HTML
<!doctype html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>자동 생성 날씨 리포트</title>
  <style>
    body{font-family:Arial,"Noto Sans KR",sans-serif;margin:24px;color:#172033;background:#f4f7fb}
    h1{margin:0 0 8px}
    p{color:#64748b}
    table{width:100%;border-collapse:collapse;background:white}
    th,td{border:1px solid #dbe3ef;padding:10px;text-align:left}
    th{background:#eef4fb}
  </style>
</head>
<body>
  <h1>자동 생성 날씨 리포트</h1>
  <p>cron이 Open-Meteo API 데이터를 수집해 생성한 HTML 파일입니다. 갱신 시간: ${updated_at}</p>
  <table>
    <thead>
      <tr><th>지역</th><th>기온</th><th>습도</th><th>풍속</th><th>자외선 지수</th></tr>
    </thead>
    <tbody>
      ${rows_html}
    </tbody>
  </table>
</body>
</html>
HTML

mv "${REPORT_TMP_FILE}" "${REPORT_FILE}"
echo "Updated ${OUT_FILE} and ${REPORT_FILE} at ${updated_at} (${success_count}/${#AREAS[@]})"
