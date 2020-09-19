JDBC
==========

> JDBC의 개념
>
> JDBC 순서
>
> JDBC API
>
> PreparedStatement

> JDBC 활용

### 1. JDBC의 개념

---------------

- **JDBC(Java Database Connectivity)**
- 개념: 자바에서 데이터베이스에 접속할 수 있도록 하는 자바 API
  - JDBC는 데이터베이스에서 자료를 쿼리하거나 업데이트하는 방법을 제공한다.
  - JDBC를 사용하는 이유
    - 데이터를 파일이 아닌 Database에 저장하고 불러오기 위함
    - 데이터의 처리를 Database에서 하는게 아닌 Java의 클래스와 메소드로 처리하기 위함
      - 데이터의 처리를 DB에서 할 것 인지, Java에서 할 것 인지는 개발자의 선택이다.
      - 만약 Java에서 처리하고자 한다면 Database에서 모든 데이터를 문자열 데이터로 형변환 한 후 가져오는 것이 편하다.
- *JDBC에서 SELECT, DML 주의점*
  - SELECT는 PreparedStatement/Statement **executeQuery()**를 사용
    - 1 ~ 7단계 진행
  - DML은 PreparedStatement/Statement **executeUpdate()**를 사용
    - **6단계 생략**

### 2. JDBC  순서

------

- JDBC를 사용하기 위해서는 다음과 같이 선언해야한다.

- **순서**

  - **0단계: ojdbc8.jar를 클래스 패스에 추가한다.**

    - 오라클에서 다운받거나 오라클 DB 폴더의 jdbc\lib에서 찾는다.

  - **1단계: import java.sql.***

  - **2단계: oracle driver Loading한다**.

    - Class.forName() 사용

      - `Class.forName(Driver)`를 사용하여 DB 드라이버를 로드한다.

        ```
        -Class.forName()이란
        Class.forName()이란 Java Reflection API의 일부이다. 자바 리플렉션 API는 구체적인 클래스의 타입을 알지 못해도 클래스의 변수 및 메소드 등에 접급하게 해주는 API이다. forName()은 Class 클래스에 속해있는데 Class 클래스는 JVM에서 동작할 클래스의 정보를 묘사하는 메타 클래스이다. 
        즉 클래스의 정보를 얻어오는 클래스이다. 
        IN APIDOC: Returns the Class object associated with the class orinterface with the given string name. Invoking this method isequivalent to
        forName()은 파라메터로 들어간 클래스의 객체를 반환한다.
        ```

      - JDBC로 오라클 DB 드라이브를 등록하려면 다음과 같이 작성하면 된다.

        ```java
        Class.forName("oracle.jdbc.driver.OracleDriver");
        ```

      - `Class.forName("oracle.jdbc.driver.OracleDriver")`만 입력하면 자동으로 객체가 생성되고 DriverManager에 등록된다.

      - <u>JDBC API 4.0 이상 부터는 JDBC 드라이브를 자동으로 로드하도록 DriverManager.getConnection 메서드가 개선되었다.</u>

    - DriverManager.registerDriver(Driver arg0)를 사용 

      - Driver arg0: 드라이버 객체
        - 오라클: new OracleDriver()

  - **3단계: Database에 connection**

    - `DriverManager.getConnection("url",계정 이름, 계정 비밀번호)`를 Connection 타입 변수에 저장
      - url은 jdbc:oracle:thin:@localhost:1521:orcl과 같은 것을 말함
        - jdbc:벤더:클라이언트 유형:내 머신 이름: 포트번호: 오라클 버전

  - **4단계: 문장객체(Statement) 생성한다.**

    - Statement 또는 PreparedStatement
    - PreparedStatement는 SQL문을 캐시를 이용하여 저장한다. 즉 Statement는 컴파일 할 때 마다 SQL문을 실행하지만 PreparedStatement는 재활용이 가능하다. 성능상의 우위가 존재
      - Statement: Connection 타입 변수.createStatement();를 이용
    - PreparedStatement: Connection 타입 변수.preparedStatement();를 이용

  - **5단계: QL 문장을 실행한다.** 

    - **SELECT문의 경우: executeQurey()**
      - Statement executeQurey(sql);
      - PreparedStatement executeQurey(); 파라미터에 sql문을 넣지 않는다.
    - **DML: executeUpdate()**
      - Statement executeUpdate(sql);
      - PreparedStatement executeUpdate(); 파라미터에 sql문을 넣지 않는다.

  - **6단계: SELECT문일 경우에만 ResultSet이라는 가상테이블을 처리한다.** 

    - 데이터를 실제로 처리하는 단계

  - **7단계: ResultSet, Statement, Connection 모두 close한다.**

    - 연 순서 반대로 닫는다. 즉 ResultSet -> Statement -> Connection

- 예

  ```java
  import java.sql.*;//1. import
  public class DB {
  	public static void main(String[] args) {
  		Connection conn = null;
  		Statement stmt = null;
  		ResultSet rs = null;
  		try {
  			//Class.forName("oracle.jdbc.driver.OracleDriver"); //2. 드라이버 로드
  			conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:orcl", "scott", "tiger");//3.Connnection
  			stmt = conn.createStatement();//4. statement 생성
  			//5.Select문의 경우 Statement의 executeQurey()로 쿼리문을 시행
  			String sql = " SELECT empno, ename, (sal * 1.1) AS \"보너스\" " + " FROM emp "; //실제 쿼리문을 작성: 쿼리문의 ;는 생략
  			rs = stmt.executeQuery(sql); //실행한 쿼리문의 결과를 ResultSet에 저장
  			//ResultSet은 일종의 가상 테이블이다.
  			//6. ResultSetd이라는 가상의 테이블을 처리한다.
  			//ResultSet next()를 사용한다. next()는 하나의 레코드를 처리한다.
  			//만약 결과가 단 하나의 행이라면 단순히 rs.next()를 사용한다.
  			//하지만 결과가 여러행이라면 while문으로 처리한다.
  			while(rs.next()) {//rs.next()가 참 일 동안 == 다음 레코드가 없는동안 루프 
  				int empno = rs.getInt("empno");
  				String ename = rs.getString(2);
  				double bonus = rs.getDouble("보너스");
  				System.out.println(empno + " , " + ename + " , " + bonus );
  			}
  		} catch (SQLException e) {
  			System.out.println("Connection Failure");
  		}
  		//7.close
  		try {
  		//연 순서의 반대로 닫는다.
  		if(rs != null) rs.close(); //ResultSet 인스턴스가 생성되지 않았다면 이 과정은 진행되지 않아야 한다.
  		if(stmt != null) stmt.close();
  		if(conn != null) conn.close();
  		}catch(SQLException e){
  			
  		}
  	}
  }
  ```

- rs.getString(int columnIndex) , rs.getDouble(int columnIndex), rs.getInt(int columnIndex) 

  - ResultSet에 저장된 데이터를 java로 추출할 때 사용하는 메소드
  - 파라메터에는 오라클 컬럼 인덱스(1부터 시작)이나 컬럼 이름을 사용해서 해당하는 컬럼의 값을 추출한다.
    - `sal * 1.1`*처럼 컬럼의 이름이 특정 이름을 가지고 있지 않을 경우 컬럼 인덱스를 넣거나 별창을 사용할 수 있다.*

### 3. JDBC API: PreparedStatement

------

- **PreparedStatement**

  - **PreparedStatement와 Statement의 차이**

    - 일반적인 SQL Engine의 과정은 다음과 같다.
      1. *Syntax Check*
         - `SELECT job FROM emp;`에서 틀린 문장이 있는가?
      2. *Object Check*
         - `SELECT job FROM emp;`에서 emp가 실제로 존재하는가? job 컬럼이 실제로 존재하는가?
      3. *Run*
    - Statementsms는 위 3단계를 모두 수행한다.
    - PreparedStatement는 처음 한 번만 세 단계를 거친 후 캐시에 담아 재사용을 한다.
    - 만약 동일한 쿼리를 반복적으로 사용한다면 PreparedStatement가 DB에 훨씬 적은 부하를 주며, 성능도 더 좋다.
    - Statement는 중간에 변수를 사용해야 할 경우 SQL문법처럼 ' '로 둘러쌓여야 한다.
      - 즉 `String sql = "SELECT * FROM emp WHERE ename '" + this.name + "'" ;`
    - 하지만 **PreparedStatement는 ?를 사용**하므로 그럴필요가 없다.
      - 즉 `String sql = "SELECT * FROM emp WHERE ename = UPPER(?);`
        - 이를 *불완전  SQL*이라고 하며 `PreparedStatement setInt(int p, String x)`같은 것으로 *완전 SQL문*을 만들어야 한다.

  - **PreparedStatement와 Statement의 선언 차이**

    - Statement

      ```java
      String sql = "SELECT empno, dname" +
      			"FROM emp INNER JOIN dept ON emp.deptno = dept.deptno" +
      			"WHERE ename = '" + name + "'";
      Statement stmt = conn.createStatement();
      ResultSet rs = stmt.executeQuery(sql); //Statement는 executeQuery(sql)에 SQL문을 파라메터로 전달
      ```

      - Statement는 executeQuery(sql)가 실행될 때 SQL문을 전달한다. 이때 SQL문은 반드시 완성된 상태여야 한다. 
      - Statement는 SQL문을 수행하는 과정에서 매 번 컴파일을 하므로 성능상의 문제가 존재한다.

    - **PreparedStatement**

      ```java
      	String sql = " SELECT deptno, dname, loc " +
      				 " FROM dept" +
      				 " WHERE deptno = ? OR dname = UPPER(?)"; //불완전 SQL문
      	PreparedStatement pstmt = conn.prepareStatement(sql); //PreparedStatement가 SQL문을 입력하는 순간
      	//PreparedStatement는 불완전 SQL문을 완전한 SQL문으로 만들어야 한다.
      	System.out.println("검색할 부서의 번호");
      	int deptno = sc.nextInt();
      	pstmt.setInt(1, deptno);
      	System.out.println("검색할 부서의 이름");
      	String dname = sc.next();
      	pstmt.setString(2, dname);
      .
      .
      .
         ResultSet rs = pstmt.executeQuery();//PreparedStatement는 executeQuery()를 빈칸으로 둔다.
      ```

      - **PreparedStatement**는 Statement에 비해 성능성의 이점이 있다. 
      - `?`이 포함된 SQL문은 불완전 SQL문이다. 이 문장도 쿼리 문장 분석 -> 객체 체크을 한다. 
      - <u>**PreparedStatement**는 `?` 부분에만 계속 변환을 주어 지속적으로 SQL문을 수행할 수 있다.</u>

    - **PreparedStatement의 선언 순서**

      1.  불완전 SQL문 작성
         - `?`을 포함한 문장을 말한다.
      2. Connection prepareStatement(sql)로 prepareStatement 인스턴스 생성
      3. 완전 SQL문을 작성: set~~~을 이용
         - pstmt.setInt(int parameterIndex, String x)
           - int parameterIndex: 불완전 SQL문의 `?`인덱스 --> 1부터 시작
         - pstmt.setString(int parameterIndex, String x)
         - 그 외 등등...
      4. ResultSet 인스턴스 생성
         - `ResultSet rs = pstmt.executeQuery()`
           - 주의점: **PreparedStatement**는 executeQuery() 파라메터에 인자를 넣지 않는다.
      5. 이후 과정은 동일

    - PreparedStatement 예

      ```java
      package Run;
      
      import java.util.Scanner;
      import java.sql.*;
      import co.example.libs.*;
      
      public class asd {
      	public static void main(String[] args) throws SQLException {
      	Scanner sc = new Scanner(System.in);
      	//2,3
      	DBConnection dbconn = new DBConnection();
      	Connection conn = dbconn.getConnetion();
      	
      	//4. PreparedStatement
      	String sql = " SELECT deptno, dname, loc " +
      				 " FROM dept" +
      				 " WHERE deptno = ? OR dname = UPPER(?)"; //불완전 SQL문
      	PreparedStatement pstmt = conn.prepareStatement(sql); //PreparedStatement가 SQL문을 입력하는 순간
      	//PreparedStatement는 불완전 SQL문을 완전한 SQL문으로 만들어야 한다.
      	System.out.println("검색할 부서의 번호");
      	int deptno = sc.nextInt();
      	pstmt.setInt(1, deptno);
      	System.out.println("검색할 부서의 이름");
      	String dname = sc.next();
      	pstmt.setString(2, dname);
      	
      	
      	//5 
      	ResultSet rs = pstmt.executeQuery();//PreparedStatement는 executeQuery()를 빈칸으로 둔다.
      	//6.
      //	if(flag) {
      		while(rs.next()) {
      			String deptno1 = rs.getString(1);
      			String two = rs.getString(2);
      			String loc = rs.getString(3);
      			System.out.println(deptno1 + "\t" + two + "\t" + loc);
      		//}
      	//} else {
      	//	System.out.println("대상이 없습니다.");
      	}
      	//7.
      	DBClose.close(conn, pstmt, rs);
      	}
      }
      
      ```

      

### 4 JDBC 활용

------

- Properties 파일을 활용하여 3단계 까지 필요한 인자를 재활용

- 3단계 까지 과정을 다른 클래스로 분리

  1. dbinfo.properties

     ```properties
     DBDRIVER=oracle.jdbc.driver.OracleDriver
     DBURL=jdbc:oracle:thin:@localhost:1521:orcl
     DBUSER=scott
     DBPASSWD=tiger
     ```

  2. co.example.libs: DBConnection.java, DBClose.java, <u>JDBC.java.java</u>

     ```java
     package co.example.libs;
     import java.io.File;
     import java.io.FileInputStream;
     import java.io.FileNotFoundException;
     import java.io.IOException;
     import java.sql.Connection;
     import java.sql.DriverManager;
     import java.sql.SQLException;
     import java.util.Properties;
     public class DBConnection {
     	private Properties p;
     	DBConnection(){
     		//생성자 dbinfo.properties를 properties로 저장
     		p = new Properties();
     		File file = new File("./dbinfo.properties");
     		//this.p.load(new FileInputStream(file));로 dbinfo.properties에 저장한 정보를 불러온다.
     		try {
     			this.p.load(new FileInputStream(file));
     		} catch (FileNotFoundException e) {
     			System.out.println("File Not Found");
     		} catch (IOException e) {
     			System.out.println("Wrong Input");
     		}
     	}
     	public Connection getConnetion() {
     		Connection conn = null;
     		//2. 드라이버 로드: JDBC 4.0 부터는 필요 없음
     		try {
     			Class.forName(this.p.getProperty("DBDRIVER"));
     			//3. connection 
     			conn = DriverManager.getConnection(this.p.getProperty("DBURL"),this.p.getProperty("DBUSER"),this.p.getProperty("DBPASSWD"));
     		} catch (ClassNotFoundException e) {
     			System.out.println("Driver Not Found");
     ```

     ```java
     package co.example.libs;
     
     import java.sql.Connection;
     import java.sql.ResultSet;
     import java.sql.SQLException;
     import java.sql.Statement;
     
     public class DBClose {
     	public static void close(Connection conn) {
     			try {
     				if(conn != null)conn.close();
     			} catch (SQLException e) {
     				// TODO Auto-generated catch block
     				e.printStackTrace();
     			}
     	}
     	
     	public static void close(Connection conn, Statement stmt) {
     		if(conn != null)
     			try {
     				if(stmt != null) stmt.close();
     				if(conn != null) conn.close();
     			} catch (SQLException e) {
     				// TODO Auto-generated catch block
     				e.printStackTrace();
     			}
     	}
     	
     	public static void close(Connection conn, Statement stmt, ResultSet rs) {
     		if(conn != null)
     			try {
     				if(rs != null) rs.close();
     				if(stmt != null) stmt.close();
     				if(conn != null) conn.close();
     			} catch (SQLException e) {
     				// TODO Auto-generated catch block
     				e.printStackTrace();
     			}
     	}
     }
     ```

     ```java
     package co.example.libs;
     //1
     import java.sql.Connection;
     import java.sql.PreparedStatement;
     import java.sql.ResultSet;
     import java.sql.ResultSetMetaData;
     import java.sql.SQLException;
     import java.sql.Statement;
     import java.util.Date;
     import java.util.Scanner;
     public class JDBC {
     	private Scanner sc;
     	public JDBC(){
     		sc = new Scanner(System.in);
     	}
     	public void runJDBC() {
     		//2,3
     		DBConnection dbconn = new DBConnection();
     		Connection conn = dbconn.getConnetion();
     		//4 pstmt
     		JDBC jdbc = new JDBC();
     		String sql = jdbc.enterSql();
     		Statement stmt = jdbc.getStatement(conn);	
     		//5.executeQuery
     		ResultSet rs = jdbc.executeQuery(stmt, sql);
     		//6.ResultSet을 처리
     		jdbc.ExecuteResultSet(rs);
     		//7.
     		DBClose.close(conn, stmt, rs);
     	}
     	public String enterSql() {
     		System.out.println("ENTER SQL: ");
     		String query = "";
     		int i=1;
     		while(true) {
     			System.out.print(i + ": ");
     			query = query + " " + sc.nextLine();
     			i++;
     			if(query.charAt(query.length() -1) == ';') {
     				query = query.substring(0, query.length()-1);
     				break;
     			}
     		}	
     		System.out.println("Entered Query... " + query);
     		return query;
     	}
     	
     	public Statement getStatement(Connection conn){
     		Statement stmt = null;
     		try {
     			stmt = conn.createStatement();		
     		} catch (SQLException e) {
     			System.out.println("Syntax Error ");
     		}
     		return stmt;
     	}
     	
     	public ResultSet executeQuery(Statement stmt, String sql) {
     		ResultSet rs = null;
     		try {
     			rs = stmt.executeQuery(sql);
     			System.out.println("SQL Injection Success");
     		} catch (SQLException e) {
     			System.out.println("Yon Entered a Wrong SQL");
     		}
     		return rs;
     	}
     	
     	public void ExecuteResultSet(ResultSet rs) {
     		ResultSetMetaData rsmd = null;
     		String[] columnName = new String[20];
     		String[] columnType = new String[20];
     		try {
     			rsmd = rs.getMetaData();
     			for(int i=1;i<=rsmd.getColumnCount();i++) {
     				columnName[i-1] = rsmd.getColumnName(i);
     				columnType[i-1] = rsmd.getColumnTypeName(i);
     			}
     		} catch (SQLException e) {
     			System.out.println("Column name");
     		}
     		
     		try {
     			int i=0;
     			while(rs.next()) {
     				while(columnType[i] == "NUMBER") {
     					int one = rs.getInt(columnName[i]);
     					System.out.print(one + ",");
     					i++;
     				}
     				while(columnType[i] == "VARCHAR2") {
     					String two = rs.getString(columnName[i]);
     					System.out.print(two+ ",");
     					i++;
     				}
     				while(columnType[i] == "DATE") {
     					Date d = rs.getDate(columnName[i]);
     					System.out.print(","+ d);
     					i++;
     				}
     				System.out.println();
     				i = 0;
     			}
     		} catch (SQLException e) {
     			System.out.println("Cannot find Column name");
     		}		
     	}
   }
     
     ```
   ```
  
   
  
  3. Run: main.java
  
     ```java
     package Run;
     import co.example.libs.*;
     public class main {
     	public static void main(String[] args) {
     		JDBC j = new JDBC();
     		j.runJDBC();
   	}
     }
   ```
  
     