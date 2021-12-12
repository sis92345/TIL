# Vue.js는 무엇인가?

저는 회사에서 `Vue.js`와 `Nuxt.js`를 사용합니다. 그 동안은 사용하는 방법만 알았는데 이번기회에 제대로 Vue.js에 대해서 알아보려고 이번에 TIL에 추가했습니다. 이제 바로 주제에 대해서 바로 넘어가봅시다. Vue.js는 무엇일까요?

> Vue.js는 interatice하고 reactive한 Web Frontend를 쉽게 빌드할 수 있도록 도와주는 Javascript Framework입니다.

모든 정의가 그렇듯 처음 접하는 우리에게 딱히 도움을 주진 않습니다. 우리에게 필요한 것은 위 정의를 키워드로 나누어서 접근하는 것입니다.

1. JavaScipt
   - 모든 브라우저가 지원하는 프로그래밍 언어
   - 자바스크립트는 작동중인 페이지를 제어할 수 있으므로 사용자 경험을 향상시킬 수 있습니다.
2. Framwork
   - 프레임워크는 유용한 유틸리티 기능(메소드나 도구 등 )과 애플리케이션 빌드 방법을 포함하는 (thirdparty)라이브러리입니다.
   - 프레임워크의 장점은 어플리케이션 구조 로직을 프레임워크의 규칙에 위임함으로서 비즈니스 로직에 집중할 수 있다는 점입니다.
3. reactive
   - 유저가 무엇을 하던 어플리케이션은 유저의 입력에 따라 메우 반응성 있어야 된다는 것
   - 예를 들어 유저가 입력창에 잘못 입력했다면 에러창을 보여준다던지..., 유저가 검색하면 바로 검색화면에 결과를 동적으로 보여준다던지
   - reative한 어플리케이션은 현대적인 웹 분위기를 나타낼 수 있습니다.
     - 전통적인 Web 환경은 사용자가 요청하면 서버가 요청에 따른 HTML 페이지를 반환했습니다.  이 말은 전통적인 웹에서는 모든 응답을 기다려야 했습니다.
     - JavaScript는 페이지가 로딩될 때 브라우저에서 작동하므로 페이지가 로딩될 때 데이터를 변경할 수 있습니다. 따라서 페이지를 받아오는 것이 아니라 DOM을 조작해서 화면을 제어할 수 있습니다. 
       - 따라서 JavaScrip는 화면을 불러온 후 데이터를 교환해서 DOM을 조작해서 화면을 제어합니다.
   - vue.js는 reative한 어플리케이션을 구성하는데 쉬운 접근법을 제공합니다.
4. web frontend
   - Vue.js는 web frontend와 관련이 깊다. 즉 vue.js는 유저가 보는 화면과 관련이 깊습니다.
   - 따라서 vue.js는 서버 사이드 프레임워크와 거리가 멉니다(물론 사용할 수는 있습니다.).

이제 위 키워드를 정리해서 다시 Vue.js가 무엇인지 정리해봅시다.

*우리는 `HTML` , `CSS`, `JavaScript` 를 사용해서 사용자가 보는 브라우저 화면을 제어하여 reative하고 interative한 web Frontend 환경을 구성할 수 있습니다. Vue.js는 바로 그러한 JavaScript  기반 사용자 인터페이스를 쉽게 구축할 수 있는 프레임워크입니다,*

사실 우리는 프론트 제어를 Vanila JavaScript로 할 수 있습니다. Vue.js는 사실 불필요합니다. 하지만 reative하고 interative한 웹을 만들기 위해 모든 코드를 작성해야 합니다. 이 점은 작업해야할 코드가 늘어난다는 것 이외에 불필요한 코드가 들어갈 수 있으므로 에러나 버그 문제가 생깁니다. 이때 Vue.js는 비즈니스 로직을 제외한 다른 코드를 프레임워크에 맞기므로 시간과 불필요한 코드를 최소화 할 수 있으며, 협업 시 공통적인 개발 룰이 정해진다는 이점이 생깁니다.

# Vue.js를 사용하는 2가지 방법

우리가 Vue.js에 본격적으로 들어가기 전에 Vue.js를 사용하는 방법이 2가지 있다는 점을 알려드리고 싶습니다.

1. Vue.js는 HTML의 일부만을 제어하기 위해서 사용할 수 있습니다.
   - e.g. 서버에 의해 렌더링 되는 Multi-page-application Widget만 제어하기 위해 사용
2. Vue.js는 Web Application의 모든 Fronetned를 제어하기 위해 사용할 수 있습니다.

두 번째 방법을 우리는 `Single-Page-Application`이라고 부릅니다. 서버는 오직 하나의 HTML 페이지를 제공하며 그 후 Vue.js는 UI 제어권을 가져옵니다.

# Vue.js의 대체제들

이번에는 Vue.js를 깊게 들어가지만, 사실 Vue.js를 대체하는 JavaScript Framwork가 많이 존재합니다.

1. Vue.js : Component based UI Framework, 화면 제어에 필요한 모든 기능들이 포함
2. React : Component based JavaScript Framework(라고 알려졌지만 사실 UI library), Vue보다는 기능이 적지만 많은 package가 이를 보완함
3. Angular : Component based UI Framework Vue보다 기능이 조금 더 많음 타입스크립트를 사용한다. 단 소규모 프로젝트에는 부적절할 수 있다.

# Start Vue.js

```javascript
/**
 * Vanila JavaScript로 구성한 App
 */
// const buttonEl = document.querySelector( "button" );
// const inputEl = document.querySelector( "input" );
// const ulEl = document.querySelector( "ul" );
//
// function addGoal(){
// 	const enteredValue = inputEl.value;
// 	const listItemEl = document.createElement( "li" );
// 	listItemEl.textContent = enteredValue;
// 	ulEl.appendChild( listItemEl );
//
// 	inputEl.value = "";
// }
//
// buttonEl.addEventListener( "click" , addGoal );

/**
 * Vue를 구성한 App
 * */
// Vue.createApp() : Vue App을 설정하는 method
debugger;
Vue.createApp({
	
	// data : function(){} Property : value로 function을 가지므로 아래와 같이 사용할 수 있다.
	// data method는 반드시 객체를 리턴해야 한다. 리턴하는 객체는 Vue App에서 사용하는 데이터를 정의한다.
	data(){
		return{
			goals : [],
			enteredValue : ""
		}
	},
	
	// methods : vue에서 사용할 method를 정의 , html 코드 내부에서 호출이 가능
	methods : {
		addGoal(){
			this.goals.push( this.enteredValue );
		}
	}
}).mount( "#app" ); // mount() Vue에게 어떤 부분을 컨트롤 할 지 알리는 역할
```

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>A First App</title>
    <link rel="stylesheet" href="styles.css" />
  </head>
  <body>
    <div id="app">
      <div>
        <label for="goal">Goal</label>
	    <!-- v-model이라는 HTML attribute를 작성 directive라고 부르며 directive는 HTML에서 지원하지 않으며 오직 vue만이 읽을 수 있음-->
        <input type="text" id="goal" v-model="enteredValue" />
	    <!-- v-on:{event} : 작동할 이벤트 -->
        <button v-on:click="addGoal">Add Goal</button>
      </div>
	  <!-- v-for item in list  : list에서 item을 뽑아서 loop -->
      <ul >
        <li v-for="goal in goals" :key="goal">{{ goal }}</li>
      </ul>
    </div>
    <!-- Vue CDN -->
    <script src="https://unpkg.com/vue@next"></script>
    <script src="app.js?v=5"></script>
  </body>
</html>

```

