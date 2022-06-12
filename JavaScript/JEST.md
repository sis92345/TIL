# 1. JEST

최근 개발을 계속하면서 테스트의 중요성을 느끼고 있습니다. 기존에는 설계 -> 개발 -> 브라우저에서 직접 엑션으로 테스트를 진행하는  순서로 개발을 진행하였는데 이 경우 로직 자체의 실패 케이스 테스트를 진행하기가 어렵습니다.  그래서 Backend 개발 시 Junit을 많이 활용하여 개발을 진행하고 있습니다. 로직을 설계 -> 각 테스트 케이스 작성 -> 테스트 -> 설계 수정 및 실패 케이스 테스트 작성으로요, 이를 통해서 특히 실패 테스트 케이스를 작성한 부분이 도움이 많이 되었습니다. 브라우저에서 체크하면 이런 실패 테스트를 하기가 어렵습니다.

그런데 Frontend에서는 TEST tool을 사용하지 않았습니다. 가장 큰 이유는 Dev tool이 있기때문에 console.log나 debugger로 충분히 테스트가 가능하기 때문입니다. 

하지만 Dev Tool을 이용하는 테스트는 수동 E2E Test이기 때문에 개발자가 직접 진행하기에는 문제가 존재합니다.  개발 시 가장 빠르게 피드백을 받을 수 있는 Unit Test, Integration Test는 테스트 프레임워크를 사용해야 함이 맞습니다. 

이때 회사 package.json에 잠자고 있던 jest를 발견했습니다. jest는 frontend에서 사용할 수 있는 test framework입니다. 이번에는 Jest의 가장 기본적인 설정에 대해서 설명합니다.



# 2. CONFIGURATION

Nuxt와 함께 사용할 시 반드시 설정해야 하는 설정입니다.

```javascript
module.exports = {
  // 리소스나 모듈 위치 path alias와 매핑할 수 있도록 지정
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1', // ~/env
    '^~/(.*)$': '<rootDir>/$1', // ./env
    '^vue$': 'vue/dist/vue.common.js'
  },
  // global 설정을 처리하는 모듈 test 실행 시 최초 한번 실행되며 반드시 module.export = async () => {} 형태이어야 함
  globalSetup : "./jest.setup.js",
  // 모듈이 사용할 수 있는 파일 확장자 배열 : 모듈을 사용할 시 왼쪽에서 오른쪽으로 해당 모듈의 이름 + 확장자로 모듈을 찾음
  moduleFileExtensions: [
    'js',
    'vue',
    'json'
  ],
  // 타입스크립트, 바벨을 사용할 때 설정해야 한다. 사용할 transform 모듈을 반드시 설치되어 있어야 함
  transform: {
    '^.+\\.(js|mjs)$': 'babel-jest', // js 파일은 자동으로 Babel로 컴파일 하도록 설정, 특히 ES6 이상의 문법을 사용하기 위해 필수임
    '.*\\.(vue)$': 'vue-jest',
    ".+\\.(css|styl|less|sass|scss|png|jpg|ttf|woff|woff2)$": "jest-transform-stub" // jest는 asset을 다루지 않으므로 여기서 처리해야 함
  },
  // 테스트 커버리지 보고 : 현재 파일에서 JEST가 커버하고 있는 파일 라인을 봅니다. 단 이거 키면 느려질 수  있음
  collectCoverage: false,
  // 테스트 커버리지가 true일 경우 커버할 파일 FROM
  collectCoverageFrom: [
    '<rootDir>/components/**/*.vue',
    '<rootDir>/pages/**/*.vue'
  ],
  // 테스트에 사용할 환경 정보
  testEnvironment: 'jsdom'
}
```

# 3. NUXT_SETUP

Nuxt를 사용할 경우 Store를 mock에 setting하기 위해서 필요한 설정입니다.

```javascript
import { Nuxt, Builder } from 'nuxt'
import nuxtConfig from './nuxt.config'

// 스토어 빌드만을 위해서 나머지 옵션들을 끄자.
const resetConfig = {
  loading: false,
  loadingIndicator: false,
  fetch: {
    client: false,
    server: false,
  },
  features: {
    store: true,
    layouts: false,
    meta: false,
    middleware: false,
    transitions: false,
    deprecations: false,
    validate: false,
    asyncData: false,
    fetch: false,
    clientOnline: false,
    clientPrefetch: false,
    clientUseUrl: false,
    componentAliases: false,
    componentClientOnly: false,
  },
  build: {
    indicator: false,
    terser: false,
  },
}

// SPA모드로, 위에 오버라이드 한 config를 집어넣는다.
const config = Object.assign({}, nuxtConfig, resetConfig, {
  ssr: false,
  srcDir: nuxtConfig.srcDir,
  ignore: ['**/components/**/*', '**/layouts/**/*', '**/pages/**/*'],
})

const buildNuxt = async () => {
  const nuxt = new Nuxt(config)
  await new Builder(nuxt).build()
  return nuxt
}

module.exports = async () => {
  const nuxt = await buildNuxt()

  // 나중에 테스트에서 사용 하기 위해서 PATH를 따로 환경변수에 저장 해놓자.
  process.env.buildDir = nuxt.options.buildDir
}
```



# 4. Run Test

```javascript
// 1. 테스트 용 IMPORT
import NoteBlockSetBLO from "~/TestBLO.js";
import share_note_edit from "~/test_page";

// 2. 테스트 모듈 세팅
import { mount, shallowMount , createLocalVue } from "@vue/test-utils";
import axios from 'axios';
import Vuex from 'vuex'
import Element from 'element-ui'

// 3. 테스트 변수
const _mockContext = {};
let $store;
let $axios;
let NuxtStore;
const localVue = createLocalVue();


/**
 * Nuxt의 Plugin에서 사용하는 Inject을 직접 전역에 등록합니다.
 * @param {String} key : $nuxt.[ $ + keu ]
 * @param {*} value : Plugin
 * */
const mockInjector = function( key , value ) {
  window.$nuxt[ "$" + key ] = value
}

/**
 * Before Each
 *
 * 테스트 시 Nuxt관련 dependency를 주입하기 위해서 사용합니다.
 * */
beforeEach( async () => {

  // 1. $store 주입
  const storePath = `testStore.js`
  NuxtStore = await import(storePath);
  $store = await NuxtStore.createStore();
  $axios = axios;
  localVue.use(Vuex);

  localVue.component( "CoreButton" )

  localVue.use(Element);
  // // root
  window.$nuxt = {};

  // 1. lodash
  window._ = require( "lodash" );

  // 2. $ui
  ui( _mockContext , mockInjector );

});

describe( "VUE INSTANCE 등록 테스트" , () =>{

  test( "TEST" , () => {

    const wrapper = shallowMount( test_page , {
      localVue,
      mocks: {
        $store,
        $axios,
        $route: {
          fullPath : "stubs"
        }
      },
      global: {
        plugins: [ Element ],
      },
    });

    console.log( wrapper.vm.isReadOnly )
    expect( wrapper.vm.isReadOnly ).toBeTruthy();

  });

  test('설정이 잘 먹혔는지 테스트', () => {

    const _param ={
      pageNum : 1,
      noteOid : "asd", // noteOid
      isReadOnly : true
    };

    const test = new testClass( _param );

    console.log( test );

  })

})
```

# 5. TEST

```javascript
describe( "POLLING TEST" , ()=>{

  /**
   * 폴링 테스트
   * */
  test( "POLLING이 잘 되는지 테스트" , async () => {

    jest.useFakeTimers();
    const mockFunc = jest.fn();

    polling( mockFunc , 1000 );

    // 테스트를 위한 SET_UP
    for (let i = 0; i < 6; i++) {
      jest.advanceTimersByTime(1000);
      await Promise.resolve();
    }

    expect(mockFunc).toHaveBeenCalledTimes(6)

  })
})

/**
 * polling 처리를 진행한다.
 *
 * @param {*} func - Polling으로 실행할 콜백
 * @param {int} timeout - setTimeOut을 줄 max
 * @param {int} maxAttempts - 최초 실행 기간
 * */
function polling( func , timeout, maxAttempts = -1 ) {

    if ( 0 === maxAttempts ) {
        return;
    }

    setTimeout( async ()=>{

      try {
          await func();
      }
      catch ( e ) {
          console.error( e );
      }

      // POLLING 설정
      polling( func , timeout , maxAttempts );

    } , timeout);
}
```



```javascript
describe( "유저 분할 테스트" , () => {

  test( "배열이 원하는 사이즈 만큼 청크로 나눌 수 있는지 검증한다." , () => {

    let userArr = [ "1" , "2" , "3" , "4" , "5" , "6"  ];

    expect(  userArr.slice( 5, userArr.length ).length ).toBeLessThan( 5 );
  })

  test( "청크 데이터를 다른 배열에 할당한 후 올바른 값인지 검증한다." , () => {

    const SHOW_MAX_COUNT = 5;
    const userArr = [
      { oid : "1" , userName : "김김김" },
      { oid : "2" , userName : "이이이" },
      { oid : "3" , userName : "박박박" },
      { oid : "4" , userName : "최최최" },
      { oid : "5" , userName : "강강강" },
      { oid : "6" , userName : "진진진" },
      { oid : "7" , userName : "진진진" },
      { oid : "8" , userName : "진진진" },
      { oid : "9" , userName : "진진진" },
      { oid : "10" , userName : "진진진" },
      { oid : "11" , userName : "진진진" },
      { oid : "12" , userName : "진진진" },
      { oid : "13" , userName : "진진진" },
    ]

    const showUserArr = userArr.slice( 0, SHOW_MAX_COUNT );
    const notShowUser = userArr.slice( SHOW_MAX_COUNT, userArr.length );

    expect( showUserArr.length ).toBe( 5 );
    expect( notShowUser.length ).toBe( 8 );
  })

  test( "청크 FUNCTION이 제대로 잘 작동되는지 검증한다." , () => {

    const SHOW_MAX_COUNT = 5;
    const userArr = [
      { oid : "1" , userName : "김김김" },
      { oid : "2" , userName : "이이이" },
      { oid : "3" , userName : "박박박" },
      { oid : "4" , userName : "최최최" },
      { oid : "5" , userName : "강강강" },
      { oid : "6" , userName : "진진진" },
      { oid : "7" , userName : "진진진" },
      { oid : "8" , userName : "진진진" },
      { oid : "9" , userName : "진진진" },
      { oid : "10" , userName : "진진진" },
      { oid : "11" , userName : "진진진" },
      { oid : "12" , userName : "진진진" },
      { oid : "13" , userName : "진진진" },
    ]

    const userList = chunkShowUserList( userArr , SHOW_MAX_COUNT  );

    expect( userList.length ).toBe( SHOW_MAX_COUNT );
  });
});

/**
 * 보여줄 유저의 리스트를 분리합니다.
 *
 * */
const chunkShowUserList = function ( shareUser , showMaxCount ) {

  return shareUser.slice( 0 , showMaxCount );
}

```

