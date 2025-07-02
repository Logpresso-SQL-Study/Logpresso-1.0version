# 클라이언트 오류(400번대 응답 코드)에 해당하는 로그만 필터링
table wc
| search status >= 400 and status < 500

------------------------------------------------------------------

# 특정 API 요청(GET /english/images/hm_ligne4_col4.gif)에 대해
# 400번대 오류 응답이 발생한 로그만 조회 (최대 10건)
table limit=10 wc
| search request == "GET /english/images/hm_ligne4_col4.gif HTTP/1.0" and status >= 400 and status < 500


------------------------------------------------------------------

# 400번대 오류 중, 호출량이 많은 API 요청(GET /images/comp_bg2_hm.gif)에 대해
# remote_host별 요청 수 및 응답 바이트 통계 집계
table wc
| search status >= 400 and status < 500 and request == "GET /images/comp_bg2_hm.gif HTTP/1.0"
| stats count as request_count,
        sum(resp_bytes_clf) as total_bytes,
        avg(resp_bytes_clf) as avg_bytes,
        max(resp_bytes_clf) as max_bytes
  by remote_host