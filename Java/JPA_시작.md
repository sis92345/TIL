# JPA 시작

# 1. 환경 설정

개발 환경

- spring boot 2.0
  - Spring-boot-starter-data-jpa
- Java 11
- Intellij
- Maven
- Mysql 8.0.29

pom.xml

```xml
<!-- Spring Boot -->
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-data-jpa</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.experimental</groupId>
            <artifactId>spring-native</artifactId>
            <version>${spring-native.version}</version>
        </dependency>

        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-tomcat</artifactId>
            <scope>provided</scope>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <!-- DB -->
        <!-- https://mvnrepository.com/artifact/mysql/mysql-connector-java -->
        <dependency>
            <groupId>mysql</groupId>
            <artifactId>mysql-connector-java</artifactId>
            <version>8.0.29</version>
        </dependency>
    </dependencies>
```

# 2. 객체 매핑 시작

기초적인 객체 매핑을 하는 방법이다.

| NO   | annotation | 설명                                                         |
| ---- | ---------- | ------------------------------------------------------------ |
| 1    | @Entity    | **이 클래스를 테이블과 매핑한다고 JPA에게 알려준다**. *@Entity 사용된 클래스를 엔티티 클래스* 라고 한다. |
| 2    | @Table     | **엔티티 클래스에 매핑할 테이블의 정보를 알려준다**. 아래 예제에서는 name 속성으로 테이블의 이름을 명시했다. 생략한다면 엔티티 이름을 사용한다. |
| 3    | @Id        | **엔티티 클래스의 필드를 테이블의 PK로 매핑한다**. @Id 가 사용된 필드를 식별자 필드라고 한다. |
| 4    | @Column    | 필드를 컬럼에 매핑한다.                                      |

아래 예제는 MEMBER 테이블을 member class에 매핑한 엔티티 클래스이다. 식별자 필드는 id이며 userName은 `@Column`을 사용해서 명시적으로 MEMBER.NAME으로 매핑하였고 age는 자동매핑이 되었다. 단 대소문자를 구분하는 DB일 경우 필드명 그대로 매핑되므로 주의가 필요하다.

# 2. JPA 설정

Spring을 사용하지 않을 경우 `META-INF/persistence.xml`에서 JPA 설정 정보를 관리한다. 여기서 사용하는 JDBC 설정 속성은 다음과 같다.

```
javax.persistence.jdbc.driver - JDBC드라이버
javax.persistence.jdbc.user - DB 접속 아이디
javax.persistence.jdbc.password - DB 접속 비밀번호
javax.persistence.jdbc.url - DB 접속 URL
```

# 3. Spring JPA DATA : 환경 설정

Spring Data JPA를 설정하는 방법을 알아본다. Spring Data JPA 을 사용한다면 `application.properties`에서 JPA의 속성을 정의할 수 있다.

- JPA : DB CONNECTION 
  - DB 연결 설정
- JPA : NAMING STRATEGY (Option)
  - JPA는 엔티티 클래스를 동일한 이름을 가진 테이블로 매핑하도록 하는 기본 전략을 가진다. 이 전략을 변경하고 싶을 때 사용한다.
    - Logical naming strategy
      - 명시적 명명 전략
        - @Table, @Column annotation으로 지정한 이름으로 직접 매핑
      - 암시적 명명 전략
        - 명시적 명명 전략을 사용하지 않았을 때 사용한다. 
        - 이 규칙을 직접 구현해서 사용해도 된다.
    - Physical naming strategy
  - [참고](https://docs.spring.io/spring-boot/docs/2.1.13.RELEASE/reference/html/howto-data-access.html#howto-configure-hibernate-naming-strategy)
- JPA : DIALECT
  - DB dialect 설정
  - Mysql 8은 org.hibernate.dialect.MySQL8Dialect를 사용

```properties
# PROFILE 설정
env.status=local

# JPA : DB CONNECTION
spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver
spring.datasource.username=DEV
spring.datasource.password=1q2w3e4r
spring.datasource.url=jdbc:mysql://127.0.0.1:3306/world

# JPA : NAMING STRATEGY
spring.jpa.hibernate.naming.physical-strategy=org.hibernate.boot.model.naming.PhysicalNamingStrategyStandardImpl

# JPA : DIALECT
spring.jpa.database-platform=org.hibernate.dialect.MySQL8Dialect# 3
```

이제 `@EnableJpaRepositoreis`를 사용해서 레포지토리를 검색할 페키지 위치를 적으면 기초적인 설정은 모두 끝이 난다.

```java
package com.jpa.config;

import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@EnableJpaRepositories( basePackages = "com.jpa" )
public class AppConfig {}
```

# 4. Spring JPA Data 공통 인터페이스

**Spring Boot 는 Hibernate 를 기본 JPA 공급자로 구성하므로 사용자 정의하지 않는 한** *entityManagerFactory* bean 을 더 이상 정의할 필요가 없다.  **Spring Boot는 또한 우리가 사용하는 데이터베이스에 따라 dataSource bean을 자동으로 구성할 수 있습니다.** *H2* , *HSQLDB* 및 *Apache Derby* 유형의 메모리 내 데이터베이스의 경우 해당 데이터베이스 종속성이 클래스 경로에 있으면 Boot가 자동으로 *DataSource 를 구성합니다.*

Spring Data Jpa는 간단한 CRUD 기능을 공통으로 처리하는 `JpaRepository` 인터페이스를 제공한다. Spring Data JPA는 이 인터페이스를 상속받아 사용함으로써 가장 간단하게 사용할 수 있다. Spring은 이 interface를 찾아서 동적으로 구현 후 bean을 등록하므로 직접 구현 클래스를 만들지 않아도 된다.

1. JpaReporitory 내부

   ```java
   public interface JpaRepository<T, ID> extends PagingAndSortingRepository<T, ID>, QueryByExampleExecutor<T> 
   ```

2. JpaRepository를 상속받아 구현 : JpaRepository의 제너릭은 엔티티 클래스와 엔티티 클래스의 식별자 필드로 지정

   ```java
   package com.jpa.member.repository;
   
   import org.springframework.data.jpa.repository.JpaRepository;
   import com.jpa.member.vo.Member;
   public interface MemberRepository extends JpaRepository<Member, String> {}
   ```

3. TEST 

   ```java
   package com.jpa;
   
   import com.jpa.config.StandardSpringTest;
   import com.jpa.member.repository.MemberRepository;
   import com.jpa.member.vo.Member;
   import org.junit.jupiter.api.Assertions;
   import org.junit.jupiter.api.DisplayName;
   import org.junit.jupiter.api.Test;
   import org.springframework.beans.factory.annotation.Autowired;
   import org.springframework.data.jpa.repository.JpaRepository;
   
   import java.util.List;
   
   class JPAConnectionTest extends StandardSpringTest {
   		
   		@Autowired
   		MemberRepository memberRepository;
   		
   		@Test
   		@DisplayName( "JPA 연결이 잘 되는지 테스트" )
   		public void JPA_CONNECTION_TEST() {
   				
   				List<Member> testDataList = memberRepository.findAll();
   				Member testData = testDataList.get( 0 );
   				
   				System.out.println( "JPA로 가져온 DB 데이터!!!!" + testData.getUserName() );
   				
   				Assertions.assertEquals( testData.getUserName() , "AN" , ()->{
   						
   						if ( testDataList.size() <= 0 ) {
   								
   								return "테스트 데이터가 비어있습니다. DB CONNECTION이 정상이라면 JPA 설정에 문제가 존재합니다.";
   						}
   						else if ( !testData.getUserName().equals( "AN" ) ) {
   								return "DB 값이 바뀌어서 실패한 경우 입니다. 정상적인 결과입니다. \n값 : " + testData.getUserName() ;
   						}
   						
   						
   						return  "";
   				});
   				
   		}
   }
   ```

## 4 - 1. 추가

Spring Data JPA도 일반 hibernate, jpa와 동일한 개념으로 작동한다. JpaRepository를 구현한 SimpleJpaRepository를 살펴보면 EntiryManager를 그대로 사용하고 있음을 알 수 있다.

```java
public class SimpleJpaRepository<T, ID> implements JpaRepositoryImplementation<T, ID> {
        private static final String ID_MUST_NOT_BE_NULL = "The given id must not be null!";
        private final JpaEntityInformation<T, ?> entityInformation;
        private final EntityManager em;
        private final PersistenceProvider provider;
        @Nullable
        private CrudMethodMetadata metadata;
        private EscapeCharacter escapeCharacter;

        public SimpleJpaRepository(JpaEntityInformation<T, ?> entityInformation, EntityManager entityManager) {
                this.escapeCharacter = EscapeCharacter.DEFAULT;
                Assert.notNull(entityInformation, "JpaEntityInformation must not be null!");
                Assert.notNull(entityManager, "EntityManager must not be null!");
                this.entityInformation = entityInformation;
                this.em = entityManager;
                this.provider = PersistenceProvider.fromEntityManager(entityManager);
        }
}
```

또한 JpaRepository에서 기본적으로 제공하는 save()를 살펴보면 실제로 내부에서 entityManager.persist()를 사용하고 있음 을 알 수 있다.

```java
@Transactional
        public <S extends T> S save(S entity) {
                Assert.notNull(entity, "Entity must not be null.");
                if (this.entityInformation.isNew(entity)) {
                        this.em.persist(entity);
                        return entity;
                } else {
                        return this.em.merge(entity);
                }
        }
```

