# Docker Compose와 외부 API를 활용한 자동화된 웹 서버 구축

## 프로젝트 기획

기상청에서 제공하는 생활기상지수 조회서비스(3.0) 중 자외선지수조회 API를 활용하여 API 데이터를 주기적으로 수집하고, 지도 기반 HTML 화면에서 지역 별 기온, 풍속, 습도, 자외선 지수 등을 보여주는 시스템입니다.

## 구현 설명

- `data-generator` 컨테이너
  - `cron`을 사용해 10분마다 `update_data.sh` 실행
  - Open-Meteo 외부 API에서 지역 별 날씨 데이터를 수집
  - `data/weather.json`과 `data/generated-report.html` 파일 생성 및 갱신

- `web` 컨테이너
  - nginx로 `index.html`, `kr.svg`, `data/weather.json`, `data/generated-report.html` 정적 호스팅
  - 브라우저에서 `localhost:8080`으로 확인 가능

- `index.html`
  - 기존 자외선 지도 UI 유지
  - `kr.svg` 지도 이미지 위에 지역 별 마커 배치
  - 자외선 지수, 현재 기온, 풍속, 습도를 함께 표시
  - cron 데이터가 없을 경우 기존 공공데이터 API 또는 기본값으로 fallback

## 실행 방법

Docker Desktop을 먼저 실행한 뒤, 이 폴더에서 아래 명령을 실행합니다.

```bash
docker compose up --build
```

브라우저에서 아래 주소로 접속합니다.

```text
http://localhost:8080
```

`localhost refused to connect`가 보이면 웹 서버 컨테이너가 실행되지 않은 상태입니다. Docker Desktop이 켜져 있는지, `docker compose up --build`가 오류 없이 실행 중인지 확인합니다.

## 과제 조건 충족

| 조건 | 구현 내용 |
| --- | --- |
| 최소 2개 컨테이너 | `data-generator`, `web` |
| 외부 API 사용 | Open-Meteo API, 기존 공공데이터 API fallback |
| cron 사용 | `mycron`에서 10분마다 실행 |
| HTML 페이지 구성 | 기존 `index.html` 활용 및 cron이 `data/generated-report.html`도 생성 |
| nginx 호스팅 | `web` 컨테이너 |
| Dockerfile + docker-compose.yml | 포함 |
| localhost 확인 | `http://localhost:8080` |

## 팀원별 참여 항목

| 이름 | 참여 내용 |
| --- | --- |
| 주민우 (팀장) | 프로젝트 전체 구조 설계, Docker Compose 구성, `data-generator`/`web` 2컨테이너 구조 구현, cron 자동 갱신 설정, 외부 API 데이터 수집 스크립트 작성, 기존 HTML 코드 수정, `kr.svg` 지도 이미지 기반 지역 마커 위치 조정, 자외선/기온/풍속/습도 표시 기능 구현, README 작성 및 최종 제출 파일 정리 |
| 김려원 | 사이트 전반적인 아이디어 제시, 발표 담당, 프로젝트 동작 흐름 정리, 실행 화면 설명, 발표 자료 구성 및 질의응답 준비, 주석 보충, README 보충 및 최종 수정 |
| 김주형 | 역할 배정은 있었으나, 최종 제출물 기준으로 확인 가능한 코드 작성, 문서 작성, 발표 준비 기여 내용 없음 |
