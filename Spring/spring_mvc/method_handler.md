# 핸들러 메소드란
Spring Web 에서 사용자의 요청(request)을 받은 응답(response)을 리턴하는 메서드
1. 매핑 정보
2. 요청
3. 응답

![image](https://user-images.githubusercontent.com/85658845/174442995-e1bbf888-2736-4446-9959-566ba56f48bd.png)

## 1. 매핑 정보

> ## RequestMapping
> - name: 뷰 템플릿에서 식별할 떄 쓰는 이름
> - value: URL
> - method: HTTP method ( ex: GET,POST)
> - params: 파라미터 검사
> - headers: 헤더 검사
> - consumes: 헤더의 Content-Type 검사
> - produces: 헤더의 Accept 검사
    > ![image](https://user-images.githubusercontent.com/85658845/174443118-e243da77-2ff4-46f4-a0fa-367af2c5c6f6.png)

이처럼 많은 매핑 정보를 담는 value가 있다.

> @RequestMapping shortcuts
> - @GetMapping
> - @PostMapping
> - @PutMapping
> - @DeleteMapping
> - @PatchMapping


## 2. 요청

> ## 핸들러 메소드가 받을 수 있는 요청들
> 메소드 파라미터로 적어 넣을 수 있는 타입들
> - ServletRequest, ServletResponse, HttpSession
> - WebRequest, NativeWebRequest
> - @RequestParam, @PathVariable
> - @RequestBody, HttpEntity\<B\>
> - @ModelAttribute, @SessionAttribute, Model, ModelMap
> - @RequestHeader, @CookieValue
> - Principal, Locale, TimeZone, InputStream, OutStream, Reader, Writer ....
> - 등 너무 많다.

## 3. 응답
> ## 핸들러 매소드가 내보낼 수 있는 응답들
> 메소드가 리턴 할 수 있는 타입들
> - ModelAndview
> - String, View
> - @ModelAttribute, Map, Model
> - @ResponseBody
> - HttpEntity\<B\>, ResponseEntity\<B\>
> - HttpHeaders
> - void
    > 등등

void는 추천하지 않는다 확실한 리턴이 있어야 컨트롤러 이다.
## Reference
https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#mvc-ann-methods 

  