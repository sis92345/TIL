# Command Pattern

**요청을 객체의 형태로 [캡슐화](https://ko.wikipedia.org/wiki/캡슐화)**하여 사용자가 보낸 요청을 나중에 이용할 수 있도록 매서드 이름, 매개변수 등 요청에 필요한 정보를 저장 또는 로깅, 취소할 수 있게 하는 패턴이다.

# 1. Command Pattern의 구분

커맨드 패턴에는 항상 Command, Receiver, Invoker, Client의 네개의 용어가 뒤따른다.

1. Command Object : receiver Object와 일련의 행동을 캡슐화, execute시 Receiver의 메소드를 호출
2. Receiver Object : 정의된 메소드를 실행
3. Invoker Object : 커맨드 객체를 받아서 명령을 발동한다.
4. Client Object : 어느 시점에 어느 명령을 수행할 지 결정 

![스크린샷 2022-06-08 오전 12 18 54](https://user-images.githubusercontent.com/68282095/172418052-8035679a-30a5-4a5e-8dc9-bc6f10645d19.png)