# LogBack Introduce

## 1. LogBack 이란?

- `LogBack`이란 자바 **오픈소스 로깅 프레임워크**, SLF4J의 구현체입니다.

Spring을 처음사용할 때 로그를 남기기 위해 `log4j`를 사용합니다. 그런데 Project를 사용하던 중 logback을 사용하게 되었고 이번에 Logback이 무엇이고 어떻게 사용하는지 남기기 위해 작성했습니다.

### 1-1. Logback 기본 설정

- Dependency : [LogBack Classic Module](https://mvnrepository.com/artifact/ch.qos.logback/logback-classic/1.2.7)

  ```xml
  <dependency>
  			<groupId>ch.qos.logback</groupId>
  			<artifactId>logback-classic</artifactId>
  			<version>1.2.7</version>
  			<scope>test</scope>
  </dependency>
  ```

  - **Spring Boot에서는 `spring-boot-starter`에 기본적으로 포함되어 있습니다.**

    - Spring-booter에서 Logger를 사용한다면 slf4j를 구현한 logback을 이용하고 있으므로 따로 의존성을 주입할 필요는 없습니다.(다만 필요에 따라 주입해서 사용할 수 있습니다)

      ```java
      public void slf4jLoggerTest(){
      				
        			// Basic Info. Map
      				slf4jLogger.info(slf4jLogger.getClass().getName());
      				slf4jLogger.info("==============================");
      				slf4jLogger.info(slf4jLogger.getClass().getSimpleName());
      				slf4jLogger.info("==============================");
      				Class<?>[] list = slf4jLogger.getClass().getInterfaces();
      				Arrays.stream( list ).forEach( item -> System.out.println(item.getName()) );
      				slf4jLogger.info("기본 로그 설정은 다음과 같습니다.");
      				StatusPrinter.print( (LoggerContext) LoggerFactory.getILoggerFactory() );
      				
      		}
      
      // 결과 
      2021-12-05 19:17:57.514  INFO 17443 --- [nio-8080-exec-1] c.s.j.d.logback.LogbackIntroduce         : ch.qos.logback.classic.Logger
      2021-12-05 19:17:57.515  INFO 17443 --- [nio-8080-exec-1] c.s.j.d.logback.LogbackIntroduce         : ==============================
      2021-12-05 19:17:57.515  INFO 17443 --- [nio-8080-exec-1] c.s.j.d.logback.LogbackIntroduce         : Logger
      2021-12-05 19:17:57.515  INFO 17443 --- [nio-8080-exec-1] c.s.j.d.logback.LogbackIntroduce         : ==============================
        
        
        
      2021-12-05 19:25:22.532  INFO 17584 --- [nio-8080-exec-1] c.s.j.d.logback.LogbackIntroduce         : 기본 로그 설정은 다음과 같습니다.
      19:25:15,591 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback-test.xml]
      19:25:15,591 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback.groovy]
      19:25:15,592 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback.xml]
      19:25:15,592 |-INFO in ch.qos.logback.classic.BasicConfigurator@20821ebd - Setting up default configuration.
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating ERROR level on Logger[org.apache.catalina.startup.DigesterFactory] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating ERROR level on Logger[org.apache.catalina.util.LifecycleBase] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating WARN level on Logger[org.apache.coyote.http11.Http11NioProtocol] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating WARN level on Logger[org.apache.sshd.common.util.SecurityUtils] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating WARN level on Logger[org.apache.tomcat.util.net.NioSelectorPool] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating ERROR level on Logger[org.eclipse.jetty.util.component.AbstractLifeCycle] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating WARN level on Logger[org.hibernate.validator.internal.util.Version] onto the JUL framework
      19:25:15,827 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating WARN level on Logger[org.springframework.boot.actuate.endpoint.jmx] onto the JUL framework
      19:25:15,842 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@79fdf179 - Propagating INFO level on Logger[ROOT] onto the JUL framework  
      ```

      ```java
      // Logger 구현체 
      public final class Logger implements org.slf4j.Logger, LocationAwareLogger, AppenderAttachable<ILoggingEvent>, Serializable {...}
      ```

      

  - `Logback`은 `slf4`와 `logback-core`을 필요로 합니다. LogBack Classic Module를 install하면 `slf4`와 `logback-core` 를 포함하고 있는 것을 확인 할 수 있습니다.

    <img width="621" alt="스크린샷 2021-12-05 오후 6 38 55" src="https://user-images.githubusercontent.com/68282095/144741355-0b463e18-03c8-41e7-b3b2-4718ededb316.png">

### 1-2. Logback으로 들어가보기

 위 코드블록에서 유의 깊게 봐야할 부분이 있습니다.

```
ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback-test.xml]
19:25:15,591 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback.groovy]
19:25:15,592 |-INFO in ch.qos.logback.classic.LoggerContext[default] - Could NOT find resource [logback.xml]
19:25:15,592 |-INFO in ch.qos.logback.classic.BasicConfigurator@20821ebd - Setting up default configuration.
```

- Logback-test.xml , logback.groovy , logback.xml 파일이 없어서 logback이 기본 설정으로 작동되었음을 의미합니다. 
- 따라서 설정이 필요할 경우 우리는 logback.xml 파일을 통해 logback 설정을 해야합니다.

logback은 로그를 파라메터화 해서 사용할 수 있습니다.

```java
Class<?>[] list = slf4jLogger.getClass().getInterfaces();
slf4jLogger.warn( "{} , {} , {} , {}" , list[0] , list[1] , list[2] , list[3]);

// 021-12-05 20:10:39.053  WARN 18065 --- [nio-8080-exec-1] com.spring                               : interface org.slf4j.Logger , interface org.slf4j.spi.LocationAwareLogger , interface ch.qos.logback.core.spi.AppenderAttachable , interface java.io.Serializable
```



#### 1-2-1. LogBack Architecture

- Logback classic module
  - logback core
  - slf4j

#### 1-2-2. LogBack의 메인 클래스

 - logback은 다음 세 주요 클래스로 구성됩니다.
   - Logger : 실제 로그 기능을 수행하는 객체로 각 Logger마다 **Name을 부여하여 사용**합니다.
   - Appenders : 
     - 로그를 **출력 할 위치, 출력 형식 등**을 설정할 수 있습니다.
     - 하나 이상의 어펜더를 로거에 첨부할 수 있습니다.
     - Appender도
   - Layout

## 2. LogBack Level 상속

- Logger Level은 상속될 수 있습니다. 만약 logger가 할당되지 않았다면 상위 조상에서 로그 레벨을 상속 받습니다. Logger의 최상위는 ROOT입니다. 예를 들어 다음과 같이 LOGGER LEVEL이 설정되었다고 해봅시다. 참고로 Appender도 마찬가지로 상속받을 수 있습니다.

  ```java
  private static ch.qos.logback.classic.Logger logger = (ch.qos.logback.classic.Logger) LoggerFactory.getLogger( "com" );
  	
  	public static void main(String[] args) {
  		SpringApplication.run(JavaApplication.class, args);
  			
  			logger.setLevel( Level.WARN );
  			logger.info( "Logger Level is ... " + logger.getLevel() );
  			logger.warn( "Logger Level is ... " + logger.getLevel() );
  	}
  ```

  - name이 `com` 인 Logger의 LEVEL이 WARN이라면 `com.spring`은 Logger Level이 설정되어있지 않으므로 상위 Logger Level인 com의 Level인 WARN을 상속받으므로 `info` 은 나오지 않습니다.

    ```java
    private final Logger slf4jLogger = LoggerFactory.getLogger( "com.spring" );
    		private final LoggerContext logBackLogger = (LoggerContext) LoggerFactory.getILoggerFactory();
    		
    		public void slf4jLoggerTest(){
    				
    				slf4jLogger.info(slf4jLogger.getClass().getName());
    				slf4jLogger.info("==============================");
    				slf4jLogger.info(slf4jLogger.getClass().getSimpleName());
    				slf4jLogger.info("==============================");
    				Class<?>[] list = slf4jLogger.getClass().getInterfaces();
    				Arrays.stream( list ).forEach( item -> System.out.println(item.getName()) );
    				slf4jLogger.info("기본 로그 설정은 다음과 같습니다.");
    				//StatusPrinter.print( (LoggerContext) LoggerFactory.getILoggerFactory() );
    				
    		}
    
    // 결과 : 상위 레벨인 WARN을 받으므로 info는 나오지 않는다.
    2021-12-05 19:55:00.171  INFO 17938 --- [nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 0 ms
    org.slf4j.Logger
    org.slf4j.spi.LocationAwareLogger
    ch.qos.logback.core.spi.AppenderAttachable
    java.io.Serializable
    ```

    

## 3. LogBack Configuration Introduce

- LogBack은 다음과 같이 설정을 찾습니다.

  1. Logback [은 classpath에서 ](http://logback.qos.ch/faq.html#configFileLocation)*logback-test.xml* 이라는 파일을 찾으려고 시도합니다 .
  2. 그러한 파일이 발견되지 않으면 logback [은 classpath에서 ](http://logback.qos.ch/faq.html#configFileLocation)*logback.groovy* 라는 파일을 찾으려고 시도합니다 .
  3. 그러한 파일이 없으면 [클래스 경로에서 ](http://logback.qos.ch/faq.html#configFileLocation)*logback.xml* 파일을 확인합니다 .
  4. 그러한 파일이 없으면 [서비스 제공자 로딩 기능](http://docs.oracle.com/javase/6/docs/api/java/util/ServiceLoader.html) (JDK 1.6에 도입됨)이 *META-INF\services\ch.qos.logback.classic.spi.Configurator* 파일을 찾아 인터페이스 구현을 해결하는 데 사용됩니다 . 클래스 경로. 그 내용은 원하는 구현 의 완전한 클래스 이름을 지정해야 합니다 . [`com.qos.logback.classic.spi.Configurator`](http://logback.qos.ch/xref/ch/qos/logback/classic/spi/Configurator.html)`Configurator`
  5. 위의 어느 것도 성공하지 못하면 logback [`BasicConfigurator`](http://logback.qos.ch/xref/ch/qos/logback/classic/BasicConfigurator.html) 은 로깅 출력이 콘솔로 전달되도록 하는 를 사용하여 자동으로 구성됩니다 .

- Logback.xml은 다음과 같이 경로를 설정할 수 있습니다.

  - 기존에는 아래와 같은 방식을 사용했으나 ..

    ```java
    System.setProperty(ContextInitializer.CONFIG_FILE_PROPERTY, "/path/to/config.xml");
    ```

  - Spring에서는 작동을 안해서 `logback.xml`에 lnclude해서 사용할 수 있습니다.

    ```java
    // resource /logback.xml
    <configuration debug="true">
    
        <include resource="logback/logbackConfig.xml"/>
    
    </configuration>
    ```

    ```java
    // resource /logback/logbackConfig.xml
    <included>
    
        <!-- APPENDER : 로그를 출력 할 위치, 출력 형식 등을 설정 -->
        <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
            <!-- encoders are assigned the type
                 ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
            <encoder>
                <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
            </encoder>
        </appender>
    
        <!-- ROOT에 APPENDER를 추가 -->
        <root level="info">
            <appender-ref ref="STDOUT" />
        </root>
    </included>
    ```

    

- 이제 `logback.xml`을 추가해 봅시다.

  ```xml
  <configuration>
  
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
          <!-- encoders are assigned the type
               ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
          <encoder>
              <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
          </encoder>
      </appender>
  
      <root level="info">
          <appender-ref ref="STDOUT" />
      </root>
  </configuration>
  ```

  - 이제 `StatusPrinter.print( (LoggerContext) LoggerFactory.getILoggerFactory() );` 로 조회시 기본 설정으로 설정됐다는 메시지가 안나오는 것을 확인할 수 있습니다. StatusPrinter.print는 logback 설정과 관련된 메시지를 출력하는 역할을 합니다. logback이 문제가 생겼을 경우 StatusPrinter.print를 이용해서 디버깅 할 수 있습니다.

    ```java
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - ch.qos.logback.classic.Logger
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - ==============================
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - Logger
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - ==============================
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - interface org.slf4j.Logger , interface org.slf4j.spi.LocationAwareLogger , interface ch.qos.logback.core.spi.AppenderAttachable , interface java.io.Serializable
    20:19:42.911 [http-nio-8080-exec-1] WARN  com.spring - 기본 로그 설정은 다음과 같습니다.
    20:19:31,063 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - debug attribute not set
    20:19:31,063 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - About to instantiate appender of type [ch.qos.logback.core.ConsoleAppender]
    20:19:31,063 |-INFO in ch.qos.logback.core.joran.action.AppenderAction - Naming appender as [STDOUT]
    20:19:31,064 |-INFO in ch.qos.logback.core.joran.action.NestedComplexPropertyIA - Assuming default type [ch.qos.logback.classic.encoder.PatternLayoutEncoder] for [encoder] property
    20:19:31,064 |-INFO in ch.qos.logback.classic.joran.action.RootLoggerAction - Setting level of ROOT logger to INFO
    20:19:31,064 |-INFO in ch.qos.logback.classic.jul.LevelChangePropagator@1e870a92 - Propagating INFO level on Logger[ROOT] onto the JUL framework
    20:19:31,064 |-INFO in ch.qos.logback.core.joran.action.AppenderRefAction - Attaching appender named [STDOUT] to Logger[ROOT]
    20:19:31,064 |-INFO in ch.qos.logback.classic.joran.action.ConfigurationAction - End of configuration.
    20:19:31,064 |-INFO in org.springframework.boot.logging.logback.SpringBootJoranConfigurator@5af51f22 - Registering current configuration as safe fallback point
    ```

  - `StatusPrinter.print( (LoggerContext) LoggerFactory.getILoggerFactory() );`은 statusListener로 추가할 수 있습니다. 또는 `<configuration debug="true">` 를 사용할 수 있습니다.

    ```
    <!-- STATUS_LISTENER : LogBack 상태를 출력 -->
        <statusListener class="ch.qos.logback.core.status.OnConsoleStatusListener" />
    ```

- 아래는 `logback`예시입니다. 

  ```xml
  // logback.xml
  <configuration debug="true">
  
      <include resource="logback/logbackConfig.xml"/>
  
  </configuration>
  ```

  

  ```xml
  <included>
  
      <property name="JAVA_STUDY_HOME" value="/Users/anbyeonghyeon/Documents/00.repositoy/javaStudy" />
  
      <conversionRule conversionWord="clr" converterClass="org.springframework.boot.logging.logback.ColorConverter" />
      <conversionRule conversionWord="wex" converterClass="org.springframework.boot.logging.logback.WhitespaceThrowableProxyConverter" />
      <conversionRule conversionWord="wEx" converterClass="org.springframework.boot.logging.logback.ExtendedWhitespaceThrowableProxyConverter" />
  
      <!-- APPENDER : 로그를 출력 할 위치, 출력 형식 등을 설정 -->
      <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
          <!-- encoders are assigned the type
               ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
          <encoder>
              <pattern>%d{HH:mm:ss.SSS} [%thread] %-5level %logger{36} - %msg%n</pattern>
          </encoder>
      </appender>
  
      <appender name="STOPWATCH" class="ch.qos.logback.core.ConsoleAppender">
          <encoder>
              <pattern>%clr([ %-5level]){cyan} [%clr(%d{HH:mm:ss.SSS}){yellow}] at %clr(%C){magenta} %clr(#%X{StopwatchName}){faint} : StartTime[%clr(#%X{StartTime}){green}] , TIME : %clr(%X{StopwatchTime}){blue} %clr(%X{TimeUnit}){cyan}%n%n</pattern>
          </encoder>
      </appender>
  
      <appender name="LOGIC_STDOUT" class="ch.qos.logback.core.ConsoleAppender">
  
          <!-- encoders are assigned the type
               ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
          <encoder>
              <pattern>%clr([ %-5level]){cyan} : %clr(%d{HH:mm:ss.SSS}){grey} %clr(%C){red} %msg%n%n %X{TimeUnit}</pattern>
          </encoder>
      </appender>
  
      <!-- 일반적인 FILE APPENDER -->
      <appender name="GENERAL_FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
          <file>${JAVA_STUDY_HOME}/logs/${StopwatchName}/logFile.log</file>
          <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
              <!-- daily rollover -->
              <fileNamePattern>logFile.%d{yyyy-MM-dd}.log</fileNamePattern>
  
              <!-- keep 30 days' worth of history capped at 3GB total size -->
              <maxHistory>3</maxHistory>
              <totalSizeCap>100MB</totalSizeCap>
  
          </rollingPolicy>
          <!-- encoders are assigned the type
               ch.qos.logback.classic.encoder.PatternLayoutEncoder by default -->
          <encoder>
              <pattern>[ %-5level] [%d{HH:mm:ss.SSS}] at %C %X{StopwatchName} : StartTime[#%X{StartTime}] , TIME : %X{StopwatchTime} %X{TimeUnit}%n%n</pattern>
          </encoder>
      </appender>
      <!-- SiftingAppender : Log를 discriminator별로 분리할 수 있다.-->
      <appender name="SIFT_FILE" class="ch.qos.logback.classic.sift.SiftingAppender">
          <!-- in the absence of the class attribute, it is assumed that the
               desired discriminator type is
               ch.qos.logback.classic.sift.MDCBasedDiscriminator -->
          <discriminator>
              <key>StopwatchName</key>
              <defaultValue>default</defaultValue>
          </discriminator>
          <sift>
              <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
                  <file>${JAVA_STUDY_HOME}/logs/${StopwatchName}/logFile.log</file>
                  <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
                      <!-- daily rollover -->
                      <!-- Attempted to append to non started appender [FILE] : 다른 SIFT 파일이 동일한 fileNamePattern을 사용하고 있어서 오류-->
                      <fileNamePattern>${StopwatchName}_logFile.%d{yyyy-MM-dd}.log</fileNamePattern>
                      <!-- keep 30 days' worth of history capped at 3GB total size -->
                      <maxHistory>3</maxHistory>
                      <totalSizeCap>100MB</totalSizeCap>
  
                  </rollingPolicy>
  
                  <encoder>
                      <pattern>[ %-5level] [%d{HH:mm:ss.SSS}] at %C %X{StopwatchName} : StartTime[#%X{StartTime}] , TIME : %X{StopwatchTime} %X{TimeUnit}%n%n</pattern>
                  </encoder>
              </appender>
          </sift>
      </appender>
  
      <!-- com.spring.stream LOG, 더블 log 방지를 위해 additivity를 false로 추가 -->
      <logger name="com.spring.stream" level="info" additivity="false">
          <appender-ref ref="STOPWATCH" />
          <appender-ref ref="SIFT_FILE" />
      </logger>
  
      <!-- ROOT에 APPENDER를 추가 -->
      <root level="info">
          <appender-ref ref="STDOUT" />
      </root>
  </included>
  ```

- 위 로그를 적용시킨 결과

  <img width="1162" alt="스크린샷 2021-12-05 오후 10 33 34" src="https://user-images.githubusercontent.com/68282095/144748723-a3b2dcc0-5d2f-45d8-911e-b36ee4e799dc.png">