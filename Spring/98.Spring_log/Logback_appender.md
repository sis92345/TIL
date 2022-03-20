# LogBack : Appender

## 1. Appender 란?

`Appender`는 `logback`에서 로그를 **출력 할 위치, 출력 형식 등**을 설정하는 역할을 합니다.  따라서 appender는 log의 출력에서 가장 큰 역할을 합니다( 다만 이벤트를 layout이나 filter에 위임할 수 있음 ) Logback.xml 설정에서 핵심적인 역할을 하므로 logback을 다룬다면 반드시 언급해야할 주제입니다.

Appender의 종류는 아래와 같습니다.

- core : 일반적인 로그 이벤트
  - ConsoleAppender : 일반적인 Console 출력 로그
  - FileAppender : 로그를 File에 기록하는 Appender
  - RollingFileAppender : FileAppender로 작성된 File을 rolling처리할 수 있는 Appender
    - rollingPolicy : 롤링 시점을 정하기 위해 사용
      - Timebasedrollingpolicy : 시간을 기준으로 rollover , 일반적
      - SizeTimeBasedrollingpolicy : 사이즈와 시간을 기준으로 rollover , Timebasedrollingpolicy의 totalSizeCap property로 정할 수 있어서 사실 잘 사용 안함
      - fixedWinodwRollingPolicy
    - triggerPolicy : RollingFileAppender에 rollover 시점을 지시하기 위해 사용
- classic : ILoggingEvent의 인스턴스 
  - SslSocketAppender
  - SMTPAppender
  - DBAppender 
  - SiftingAppender

logback은 로그 작성 이벤트를 `appender` 에게 위임합니다. 이 `Appender`는 반드시 `ch.qos.logback.core.Appender`를 implement해야 합니다.  이제 아래에서 appender를 구성하는 기초적인 클래스로 들어가 봅시다.

### 1.1 ch.qos.logback.core.Appender Interface

```java
package ch.qos.logback.core;

import ch.qos.logback.core.spi.ContextAware;
import ch.qos.logback.core.spi.FilterAttachable;
import ch.qos.logback.core.spi.LifeCycle;

public interface Appender<E> extends LifeCycle, ContextAware, FilterAttachable<E> {
  		
  			// 모든 Appender는 setter와 getter를 가지고 있다.
        String getName();

  			void setName(String var1);
				
  			// doAppender는 로그백 모듈마다 달라지는 E를 파라메터로 받는다
        void doAppend(E var1) throws LogbackException;
}
```

### 1.2 ch.qos.logback.core.AppenderBase

- 위 `Appender`  interface를 상속받는 abstract class 입니다. 이 클래스에서는 appender의 name, filter , layout을 가져오거나 모든 appender가 사용하는 기본적인 기능을 제공합니다. 

- Appender.class는 doAppender를 override하고 있습니다.

  - doAppender

    ```javascript
    // doAppend는 append가 정상적으로 실행될 수 있는지 체크하는 역할
    public synchronized void doAppend(E eventObject) {
      							// Guard가 ture가 아니라면 즉시 종료
                    if (!this.guard) {
                            try {
                                    this.guard = true;
                                    if (this.started) {
                                            if (this.getFilterChainDecision(eventObject) == FilterReply.DENY) {
                                                    return;
                                            }
    
                                            this.append(eventObject);
                                            return;
                                    }
    
                                    if (this.statusRepeatCount++ < 5) {
                                            this.addStatus(new WarnStatus("Attempted to append to non started appender [" + this.name + "].", this));
                                    }
                            } catch (Exception var6) {
                                    if (this.exceptionCount++ < 5) {
                                            this.addError("Appender [" + this.name + "] failed to append.", var6);
                                    }
    
                                    return;
                            } finally {
                                    this.guard = false;
                            }
    
                    }
            }
    ```

## 2. Appender 종류

### 2.1 Core Appender

#### 2.1.1 OutputStreamAppender

- UnsynchronizedAppenderBase를 상속받습니다. Event를 outputstream으로 발행하는 역할입니다.

- Property

  | Property Name  | Type    | 설명                                                         |
  | -------------- | ------- | ------------------------------------------------------------ |
  | encoder        | Encoder | 이벤트가 OutputStreamAppender에 기록되는 방식을 결정         |
  | immediateFlush | Boolean | Default true , true시 outputstream을 기록 즉시 flush한다. true로 설정할 시 outputstream이 적절하게 닫히지만 false설정 시 안닫힐 수 있으므로 주의 |

  - `OutputStreamAppender`가 중요한 이유는 주로 사용하는 Appender의 super class가 `OutputStreamAppender`이기 때문입니다.

    - `ConsoleAppender` , 'FileAppender' , 'RollingFileAppender'

      <img width="866" alt="스크린샷 2021-12-11 오후 2 56 28" src="https://user-images.githubusercontent.com/68282095/145665975-70c3684e-b929-4fd5-87b4-a89f6ada8e99.png">

#### 2.1.2 ConsoleAppender

**이름 그대로 console에 log를 출력합니다**.  가장 기본적인 appender이며 추가적인 설정으로 System.out or System.err로 출력할 수 있습니다.

- class : `ch.qos.logback.core.ConsoleAppender`

- Property

  | Property Name | Type    | 설명                                                         |
  | ------------- | ------- | ------------------------------------------------------------ |
  | encoder       | Encoder | 이벤트가 OutputStreamAppender에 기록되는 방식을 결정         |
  | target        | String  | System.out or System.err 중 하나 기본은 System.out           |
  | withJansi     | boolean | default false, Jansi 라이브러리 활성화,  ture시 org.fusesource.jansi:jansi:1.18을 클래스 페스에 넣어야 함 |

- 예시

  ```xml
  <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
  				<!-- withJansi -->
          <!-- Jansi Hightlist : %black, %red, %green, %yellow, %blue, %magenta, %cyan, %white, %gray, %boldRed, %boldGreen, %boldYellow, %boldBlue, %boldMagenta, %boldCyan, %boldWhite -->
          <withJansi>true</withJansi>
          <encoder>
              <pattern>%d{HH:mm:ss.SSS} [%thread] %boldYellow(%-5level) %logger{36} - %boldBlue(%X{StopwatchTime}) %n</pattern>
          </encoder>
      </appender>
  ```

  <img width="536" alt="스크린샷 2021-12-11 오후 3 17 32" src="https://user-images.githubusercontent.com/68282095/145666541-937a1224-6f36-445b-aceb-e02a144ebd22.png">

#### 2.1.3 FileAppender

`OutputStreamAppender`의 서브 클래스입니다. log event를 파일로 기록하는 appender 입니다.

- class : `ch.qos.logback.core.FileAppender`

- Property

  | Property Name   | Type    | 설명                                                         |
  | --------------- | ------- | ------------------------------------------------------------ |
  | append          | boolean | default true, ture일 시 이벤트 로그가 존재하는 파일의 끝에 추가됩니다. false라면 기존에 존재하는 파일은 잘립니다. |
  | encoder         | Encoder | Encoder                                                      |
  | **file**        | String  | 기록될 파일의 이름을 정합니다. 파일이 존재하지 않는다면 새로 생성합니다(상위 폴더도 없으면 자동 생성). default값이 없으므로 FileAppender사용 시 반드시 적어야 하는 값입니다. |
  | prudent         | boolean | Prudent mode에서 FileAppender는 특정 파일을 안전하게 작성할 수 있습니다. |
  | immediate flush | boolean | Outputstreamappender.immediateflush                          |

  - 예

    ```xml
    <appender name="NOT_APPEND_FILE_OUT" class="ch.qos.logback.core.FileAppender">
    				<!-- append 여부 -->
            <append>false</append>
      
            <file>${JAVA_STUDY_HOME}/logs/notAppendFile/logfile.log</file>
            <encoder>
                <pattern>[ %-5level] [%d{HH:mm:ss.SSS}] at %C %X{StopwatchName} : StartTime[#%X{StartTime}] , TIME : %X{StopwatchTime} %X{TimeUnit}%n%n</pattern>
            </encoder>
        </appender>
    ```

  - 로그 파일 이름을 동적으로 받을 수 있습니다.

    ```xml
    <!-- TimeStamp 설정 -->
    <timestamp key="FILE_NAME_BY_SECOND" datePattern="yyyyMMdd 'T' HHmmsss"/>
    
    <!-- logback home -->
    <property name="JAVA_STUDY_HOME" value="/내프로젝트경로!!!!/javaStudy"/>
    
    <!-- File Appender -->
    <appender name="NOT_APPEND_FILE_OUT" class="ch.qos.logback.core.FileAppender">
      	<append>true</append>
        <file>${JAVA_STUDY_HOME}/logs/notAppendFile/${FILE_NAME_BY_SECOND}_logFile.log</file>
      	<encoder>
                <pattern>[ %-5level] [%d{HH:mm:ss.SSS}] at %C %X{StopwatchName} : StartTime[#%X{StartTime}] , TIME : %X{StopwatchTime} %X{TimeUnit}%n%n</pattern>
            </encoder>
    </appender>
    
    <!-- Logger -->
    <logger name="com.spring.stream" level="info" additivity="false">
    	<appender ref="NOT_APPEND_FILE_OUT"></appender>
    </logger>
    
    ```

    <img width="502" alt="스크린샷 2021-12-11 오후 4 06 23" src="https://user-images.githubusercontent.com/68282095/145667839-904a0691-e342-459f-883f-d98ba52f1c94.png">

  - append

    - false일 시 서버를 내렸다가 다시 키면 로그가 초기화 되어 있다.

      ```
      // 서버 내리기 전 로그
      [ INFO ] [15:29:49.318] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:29:49.311] , TIME : 8 MILLISECONDS
      ```

      ```
      // 서버 내린 후 초기화 
      [ INFO ] [15:43:27.419] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:43:27.411] , TIME : 8 MILLISECONDS
      ```

    - true일 시 서버가 꺼져도 계속 append 된다.

      ```
      [ INFO ] [15:43:27.419] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:43:27.411] , TIME : 8 MILLISECONDS
      
      [ INFO ] [15:45:08.221] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:45:08.216] , TIME : 5 MILLISECONDS
      
      [ INFO ] [15:45:08.648] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:45:08.648] , TIME : 0 MILLISECONDS
      
      [ INFO ] [15:45:09.164] at com.spring.common.aspect.StopwatchAspect flatMap_Test : StartTime[#2021-12-11T15:45:09.164] , TIME : 0 MILLISECONDS
      ```

#### 2.1.4 RollingFileAppender

FileAppender는 정말 유용하지만 로그를 제한없이 계속 쌓으므로 불필요한 과거 로그까지 보관하므로 로그 파일 용량이 커질 수 있다는 단점이 있습니다. 따라서 logback에서는 `RollingFileAppender`를 사용해서 로그 파일을 롤링 처리할 수 있도록 지원합니다.

RollingFileAppender는 두 클래스를 구성요소로 가지고 있습니다. 첫번째로 `RollingPolicy`와 `TriggeringPolicy`입니다. 두 요소에 대해서는 잠시후 설명하겠습니다.

- class : `ch.qos.logback.core.RollingFileAppender`

- property

  | Property Name | Type          | 설명                                                         |
  | ------------- | ------------- | ------------------------------------------------------------ |
  | File          | String        | FileAppender file property                                   |
  | append        | boolean       | FileAppender append                                          |
  | rollingPolicy | RollingPolicy | Rollover가 발생될 때 RollingFileAppender의 동작을 지시하는 구성 요소 |
  | triggerPolicy | TriggerPolicy | Rollover를 발생시키기 위한 시기를 RollingFileAppender에게 알리는 역할 |
  | encoder       | Encoder       | Encoder                                                      |
  | prodent       | boolean       |                                                              |

- RollingPolicies

  `rollingPolicy`는 rollover시 파일을 이동시키거나 이름을 재정의하는 역할을 수행합니다.

  ```java
  // RollingPolicy interface
  package ch.qos.logback.core.rolling;  
  
  import ch.qos.logback.core.FileAppender;
  import ch.qos.logback.core.spi.LifeCycle;
  
  public interface RollingPolicy extends LifeCycle {
  
    public void rollover() throws RolloverFailure;
    public String getActiveFileName();
    public CompressionMode getCompressionMode();
    public void setParent(FileAppender appender);
  }
  ```

  - RollingPolicy의 종류

    - `TimeBasedRollingPolicy` : 일반적인 rolling-policy, 시간을 기준으로 rollingpolicy를 시행
    - `SizeAndTimeBasedRollingPolicy` :  파일 사이즈와 시간을 기존으로 rollingpolicy를 시행
      - 단 이미 `TimeBasedRollingPolicy`의 totalSizeCap property가 있으므로 직접 사용할 일은 없다
    - `FixedWindowRollingPolicy` : 고정된 알고리즘에 의해 rolling될 때 사용

  - `TimeBasedRollingPolicy`

    - 일반적인 rolling-policy, 시간을 기준으로 rollingpolicy를 시행

    - Class : `ch.qos.logback.core.rolling.TimeBasedRollingPolicy`

    - property

      - | Property Name       | Type   | 설명                                                         |
        | ------------------- | ------ | ------------------------------------------------------------ |
        | fileNamePatterrn    | String | rollover되는 파일의 이름 패턴을 정의 , 필수 , 재정의 되는 파일 이름은 java.text.SimpleDateFormat에서 지정한 날짜 , 패턴을 사용할 수 있다. 기본적으로 y**yyy-MM-dd rollover 기간은 fileNamePattern의 값을 통해서 유추됨을 유의**  파일 이름 패턴은 여기를 참고 http://logback.qos.ch/manual/appenders.html |
        | maxHistory          | int    | 보관할 log 파일의 최대 개수 maxHistory가 넘어가는 파일의 경우 더 오래된 파일을 삭제 , 옵션 |
        | totalSizeCap        | int    | 한 로그 파일에 보관할 로그 파일의 사이즈 제한                |
        | cleanHistoryOnStart |        | true일 경우 appender가 실행될 때 자동으로 보관 로그를 삭제   |

      - file property와 fileNamePatterrn을 함께 사용할 경우 현재 사용하고 있는 로그는 file property 경로로 , rollover된 로그는 fileNamePattern으로 분리할 수 있음을 유의 , 만약 file property가 없을 경우 fileNamePattern을 기준으로 설정됨'

      - 만약 fileNamePattern으로 여러 date를 사용할 경우 부가적인 date에 aux를 붙여야 한다.

        ```xml
        <fileNamePattern>/var/log/%d{yyyy/MM, aux}/myapplication.%d{yyyy-MM-dd}.log</fileNamePattern>
        ```

  - TimeBasedRollingPolicy를 이용한 예 : gz 압축 + 롤링 처리

    ```xml
    <!-- SIFT_APPENDER -->
    <appender name="SIFT_FILE" class="ch.qos.logback.classic.sift.SiftingAppender">   
      			<!-- MDC에 put한 StopwatchName을 사용하기 위해서 discrimator로 정의-->
            <discriminator>
                <key>StopwatchName</key>
                <defaultValue>default</defaultValue>
            </discriminator>
            <sift>
                <appender name="MINUIT_ROLLING" class="ch.qos.logback.core.rolling.RollingFileAppender">
                    
                  <!-- 롤링이 안된 현재 로그 위치 설정 : RollingFileEncoder Property -->
                    <file>${JAVA_STUDY_HOME}/logs/${StopwatchName}/logfile.log</file>
                    <append>true</append>
                    <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
    <!-- Rolling할 파일의 이름 패턴 : fileNamePattern의 $d으로 rolling규칙을 정의 -->      
    <!-- 현재 mm까지 있으므로 rolling은 분 단위로 롤링된다. -->     
    <!-- .gz로 리네임할 시 로그를 gzip으로 압축할 수 있음 -->   <fileNamePattern>${JAVA_STUDY_HOME}/logs/${StopwatchName}/logFile.${StopwatchName}.%d{yyyy-MM-dd_HH-mm}.gz</fileNamePattern>
                      	<!-- totalSizeCap : 롤링할 파일의 사이즈 -->
                        <totalSizeCap>1MB</totalSizeCap>
                      	<!-- 최대 롤링할 파일의 개수 : 3개가 넘어가면 오래된 파일을 삭제 -->
                        <maxHistory>3</maxHistory>
                    </rollingPolicy>
    								<!-- Encode : RollingFileEncoder Property -->
                    <encoder>
                    <pattern>[ %-5level] [%d{HH:mm:ss.SSS}] at %C %X{StopwatchName} : StartTime[#%X{StartTime}] , TIME : %X{StopwatchTime} %X{TimeUnit}%n%n</pattern>
                    </encoder>
                </appender>
            </sift>
        </appender>
    ```

    - 3개이상일 시 삭제되는 것을 확인 할 수 있다.

    <img width="916" alt="스크린샷 2021-12-11 오후 5 15 04" src="https://user-images.githubusercontent.com/68282095/145669651-9509d6e7-cf49-4268-a636-251dc26c4067.png">

  - `trigger policies`

    - `triggerpolicy`는 'RollingPolicyAppender'에  rollover시점을 지시하는 역할을 수행합니다.
    - TriggerPolicy의 종류
      - SizeBasedTriggerPolicy : 현재 파일의 사이즈를 보고 현재 사이즈가 크다면 RollingFileAppender에 rollover하도록 합니다.

### 3. DB_LOGGER

이제 DB를 log로 남기기 위한 작업을 진행하겠습니다. 기존의 PreparedStatement로는 파라메터를 포함하는 SQL로그를 확인할 수 없었습니다. 이를 위해 따로 구현해야 했으나 이제는 편하게 의존성만 주입해서 logback과 함께 사용할 수 있습니다.

- dependency : log4jdbc

  ```xml-dtd
  <!-- https://mvnrepository.com/artifact/org.bgee.log4jdbc-log4j2/log4jdbc-log4j2-jdbc4.1 -->
  		<dependency>
  			<groupId>org.bgee.log4jdbc-log4j2</groupId>
  			<artifactId>log4jdbc-log4j2-jdbc4.1</artifactId>
  			<version>1.16</version>
  		</dependency>
  ```

  - log4jdbc를 사용합니다. 다만 2013년 이후로 업데이트가 없으므로 이점을 유의해야 합니다.
  - (Log4jdbc){https://log4jdbc.brunorozendo.com/}

- log4jdbc를 사용하기 위해서 driver를 변경해야합니다.

  ```java
  
  // 기존 설정 
  connectionPoolConfig.setDriverClassName( "org.mariadb.jdbc.Driver" );
  connectionPoolConfig.setJdbcUrl( "jdbc:mysql://localhost:3306/world?serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true&useSSL=false" );
  			
  
  
  // 변경 후
  	connectionPoolConfig.setDriverClassName( "net.sf.log4jdbc.sql.jdbcapi.DriverSpy" );
  				connectionPoolConfig.setJdbcUrl( "jdbc:log4jdbc:mysql://localhost:3306/world?serverTimezone=UTC&characterEncoding=utf8&allowPublicKeyRetrieval=true&useSSL=false" );
  ```

- log4jdbc는 이름에서부터 알 수 있듯이 log4j를 사용합니다. log4j는 취약점이 존재하고 그대로 log에 사용하기에는 문제점이 많습니다.

  - 따로 설정하고 바로 사용 시 sql과 관련된 모든 로그가 나오므로 내가 원하는 정보만 찾기 어렵습니다.

    ```java
    // Log4j2SpyLogDelegator
    public class Log4j2SpyLogDelegator implements SpyLogDelegator {
    	private static final Logger LOGGER = LogManager.getLogger("log4jdbc.log4j2");
    }
    ```

    - 기본 설정인  `Log4j2SpyLogDelegator`는 logger를 `log4jdbc.log4j2` 만 가지고 있으므로 불필요한 sql 관련 로그를 제외할 수 없습니다.

  - 따라서  이  `Log4j2SpyLogDelegator`를 `Slf4jSpyLogDelegator`로 변경해야 각 SQL 로그에 맞는 logger를 커스터마이징해서 사용할 수 있습니다. `Slf4jSpyLogDelegator`에서 볼 수 있는 sql 관련 logger는 다음과 같습니다.

    ```java
    public class Slf4jSpyLogDelegator implements SpyLogDelegator {
    				// jdbc.audit : ResultSet을 제외한 모든 JDBC
            private final Logger jdbcLogger = LoggerFactory.getLogger("jdbc.audit");
      			// jdbc.resultset : ResultSet을 포함한 모든 JDBC 호출 정보를 로그로 남긴다.
            private final Logger resultSetLogger = LoggerFactory.getLogger("jdbc.resultset");
      			// jdbc.sqlonly : sql 쿼리문
            private final Logger sqlOnlyLogger = LoggerFactory.getLogger("jdbc.sqlonly");
      			// jdbc.sqltiming : sql 쿼리문 + 쿼리 실행 시간
            private final Logger sqlTimingLogger = LoggerFactory.getLogger("jdbc.sqltiming");
      			// jdbc connection과 관련된 정보 , Connection Pool 설정
            private final Logger connectionLogger = LoggerFactory.getLogger("jdbc.connection");
            private final Logger debugLogger = LoggerFactory.getLogger("log4jdbc.debug");
      			// jdbc.resultsettable : jdbc 결과를 테이블로 표현
            private final Logger resultSetTableLogger = LoggerFactory.getLogger("jdbc.resultsettable");
      			.
     		 		.
      			.
     }
    ```

- `Log4j2SpyLogDelegator`를 `Slf4jSpyLogDelegator`는 다음과 같이 변경할 수 있습니다,

  1. `log4jdbc.log4j2.properties` 생성

  2. 다음의 메시지를 추가

     ```properties
     log4jdbc.spylogdelegator.name=net.sf.log4jdbc.log.slf4j.Slf4jSpyLogDelegator
     ```

- `이제 Slf4jSpyLogDelegator`에 정의된 logger를 `logback.xml`에서 자유롭게 커스터마이징할 수 있다.

  ```xml
  <appender name="SQL_QUERY_OUT" class="ch.qos.logback.core.rolling.RollingFileAppender">
          <file>${JAVA_STUDY_HOME}/logs/sql/querylog.log</file>
          <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
              <fileNamePattern>${JAVA_STUDY_HOME}/logs/sql/%d{yyyyMMdd}.sqlquery.log</fileNamePattern>
              <maxHistory>3</maxHistory>
              <totalSizeCap>100MB</totalSizeCap>
          </rollingPolicy>
          <encoder>
              <pattern>%d{HH:mm:ss.SSS} %C : [%thread] %-5level %logger{36} - %msg %n</pattern>
          </encoder>
      </appender>
  
      <!-- SQL 관련 -->
      <!-- SQL CONNECTION : Connection Pool 관련 설정-->
      <logger name="jdbc.connection" level="OFF"/>
      <!-- SQL LOGGER 설정 : RESULT_SET을 포함한 모든 JDBC 호출 정보-->
      <logger name="jdbc.resultset" level="OFF"/>
      <!-- SQL AUDIT : RESULT_SET을 제외한 모든 JDBC 호출 정보 로그  -->
      <logger name="jdbc.audit" level="OFF"/>
      <!-- SQL ONLY : SQL 문 만을 로그로 처리 -->
      <logger name="jdbc.sqlonly" level="OFF" />
      <!-- SQL RESULTSETTABLE : SQL 결과를 테이블로 표현-->
      <logger name="jdbc.resultsettable" level="INFO" />
      <!-- SQL TIMING : SQL 과 실행 시간을 처리한다. : FILE APPENDR로 처리-->
      <logger name="jdbc.sqltiming">
          <level>info</level>
          <appender-ref ref="SQL_QUERY_OUT"/>
      </logger>
  ```

  