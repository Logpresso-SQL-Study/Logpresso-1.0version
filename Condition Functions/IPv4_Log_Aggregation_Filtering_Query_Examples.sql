# wc 테이블에서 데이터 조회
table wc

------------------------------------------------------------------

# 로그 내에 'remote_host' 문자열이 포함된 항목 필터링
| search remote_host
# remote_host 값별로 그룹화하여 각 그룹의 행 개수 집계
| stats count() by remote_host

------------------------------------------------------------------

# 대용량 테이블일 때, 기간 제한 또는 조건 추가로 범위 줄이기
table wc
| search _time >= '2025-07-01T00:00:00' and _time < '2025-07-02T00:00:00'
| stats count() by remote_host

------------------------------------------------------------------

# 조회 속도 기반
table wc
| stats count() by remote_host

------------------------------------------------------------------

# "traffic" 문자열 검색
fulltext "traffic" from index_delims

------------------------------------------------------------------

# "10.10.180.35" IP 검색
fulltext "10.10.180.35" from index_delims

------------------------------------------------------------------

# IP를 각각 토큰으로 나눠서 검색
fulltext "10" and "10" and "180" and "35" from index_delims

------------------------------------------------------------------

# SQL 튜닝 (최적화)
fulltext "10" and "180" and "35" from index_delims

------------------------------------------------------------------

# Search SQL
table wc | search remote_host == ip("10.12.176.148")

------------------------------------------------------------------

# Fulltext SQL
fulltext "10.12.176.148" from wc

------------------------------------------------------------------

# 결과 집합에서 총 건수 대신 request별 건수와 전송량을 서머리
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request

------------------------------------------------------------------

# Top 20 도출
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request
| sort limit=20 -Datas

------------------------------------------------------------------

# 순번생성
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request
| sort limit=20 -Datas
| eval Number = seq()

------------------------------------------------------------------

# API URL 컬럼 생성
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request
| sort limit=20 -Datas
| eval Number = seq() | rename request as API

------------------------------------------------------------------

# GET 문자열 제거
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request
| sort limit=20 -Datas
| eval Number = seq() | rename request as API
| fields Number, API, Datas
| eval API = replace(API, "GET", "")

------------------------------------------------------------------

# 소문자 > 대문자 변경
fulltext "10.12.176.148" from wc
| stats count, sum(resp_bytes_clf) as Datas by request
| sort limit=20 -Datas
| eval Number = seq() | rename request as API
| fields Number, API, Datas
| eval API = replace(API, "GET", ""), API = if(contains(API, "english"), upper(API), API)

------------------------------------------------------------------
# SQL 튜닝
fulltext "10.12.176.148" from wc
| stats count() as Count, sum(resp_bytes_clf) as Datas by request
| sort -Datas
| limit 20
| eval Number = seq(),
       API = replace(request, "GET ", ""),
       API = if(contains(lower(API), "english"), upper(API), API)
| fields Number, API, Datas