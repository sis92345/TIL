# Nuxt : cross env 구현

Front 환경에서 각 서버 환경 별로 각각 다른 환경 변수를 정의해야 할 필요성이 있다. 예를 들어서 dev에서는 이 dev 환경에 맞추어진 url을 사용하거나, real에서는 실제 url을 환경변수에 정의해야 할 경우가 대표적이다.  이 문서에는 env에는 민감한 정보 ( exe : key, db 관련 데이터.. )를 당연히 담지 않는다고 가정하였다. 특별한 조치를 취하지 않는 한 민감한 정보를 env에 담지 않는 것은 당연하다.

crossEnc에 관심을 가졌던 것은 마침 회사에서 필요한 요구였기 때문이다. 기존에는 cookie를 사용해서 환경을 구분했는데 이 부분이 불편했기 때문이고, 문서 하나에 환경에 따른 각 변수를 정의하고 싶었다.

인터넷에 검색한 결과 다음과 같이 crossEnv를 구현할 수 있었다.

- node_env
- dotenv

dotenv로 package.json script 명령어로 상위 node_env를 정의한 후 dotenv를 사용해서 환경에 맞는 env 파일을 로드하는 방식이었다. 이 방식을 그대로 적용하려고 했지만 nuxt에서 다음과 같은 문제점이 존재했다.

- nuxt에서는 NODE_ENV를 정의할 수 없다.
  - 아직까지 원인은 파악하지 못했지만 nuxt 내부에서 이 환경변수를 강제로 정의하는 것으로 추정된다.

따라서 nuxt에서 다음 문서를 통해서 cross env를 구현했다.

- [NUXT_ENV Surppix로 Nuxt에서 사용할 수 있는 env를 추가할 수 있다.](https://nuxtjs.org/docs/configuration-glossary/configuration-env/#automatic-injection-of-environment-variables)

즉 다음과 같이 cross env를 구현했다.

1. package.json에서 각 환경을 실행하는 script를 추가했다.

   - NUXT_ENV_STAGE는 각 환경을 정의한다. npm run gen_dev 명령어를 사용하면 상위 환경 변수는 .dev를 설정했다.

   ​	

   ```
   "dev": "SET NUXT_ENV_STAGE=.local&& nuxt",
   "dev_mac": "NUXT_ENV_STAGE=.local nuxt",
   "build": "SET NUXT_ENV_STAGE=.real&& nuxt build",
   "build:dev": "SET NUXT_ENV_STAGE=.dev nuxt build",
   "build:dev_mac": "NUXT_ENV_STAGE=.dev nuxt build",
   "start": "nuxt start",
   "gen": "SET NUXT_ENV_STAGE=.real&& nuxt generate",
   "gen_mac": "NUXT_ENV_STAGE=.real nuxt generate",
   "gen:dev": "SET NUXT_ENV_STAGE=.dev&& nuxt generate",
   "gen:dev_mac": "NUXT_ENV_STAGE=.dev nuxt generate",
   ```

2. nuxt.config.js에서 dotenv를 사용해서 환경 변수를 load 한다.

   ```
   dotenv: { filename : '/env/.env' + process.env.NUXT_ENV_STAGE},
   ```

## 보완할 점

사실 이 방법은 nuxt에서 변경을 권장하는 방법이다. 실제로는 여러 사정때문에 최신 소스로 변경이 불가능했다. 다음 방법으로의 변경이 되야한다.

1. mac, window같은 개발 환경을 script로 사전에 변경이 가능해야 한다.
2. nuxt에 [runtime config](https://nuxtjs.org/docs/directory-structure/nuxt-config#runtimeconfig)가 추가되었다. 이 방법으로 변경이 필요하다.