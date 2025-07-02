# 400번대 응답 코드(클라이언트 오류)에 해당하는 로그만 필터링하는 쿼리
table wc
| search status >= 400 and status < 500

------------------------------------------------------------------

# 400번대 응답 코드(클라이언트 오류)중, 특정 API Request 타겟 조회
table limit=10 wc
| search request == "GET /english/images/hm_ligne4_col4.gif HTTP/1.0"
| search status >= 400 and status < 500