JDBC
==========

> JDBC의 개념
>
> JDBC 순서

> JDBC 활용

### 1. 배열의 개념

---------------

- **JDBC(Java Database Connectivity)**
- 개념: 자바에서 데이터베이스에 접속할 수 있도록 하는 자바 API
  - JDBC는 데이터베이스에서 자료를 쿼리하거나 업데이트하는 방법을 제공한다.
  - JDBC를 사용하는 이유
    - 데이터를 파일이 아닌 Database에 저장하고 불러오기 위함
    - 데이터의 처리를 Database에서 하는게 아닌 Java의 클래스와 메소드로 처리하기 위함
      - 데이터의 처리를 DB에서 할 것 인지, Java에서 할 것 인지는 개발자의 선택이다.
      - 만약 Java에서 처리하고자 한다면 Database에서 모든 데이터를 문자열 데이터로 형변환 한 후 가져오는 것이 편하다.

### 2. JDBC  순서

------

- JDBC를 사용하기 위해서는 다음과 같이 선언해야한다.

- **순서**

  - **0단계: ojdbc8.jar를 클래스 패스에 추가한다.**

    - 오라클에서 다운받거나 오라클 DB 폴더의 jdbc\lib에서 찾는다.

  - **1단계: import java.sql.***

  - **2단계: oracle driver Loading한다**.

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

  - **3단계: Database에 connection**

    - `DriverManager.getConnection("url",계정 이름, 계정 비밀번호)`를 Connection 타입 변수에 저장
      - url은 jdbc:oracle:thin:@localhost:1521:orcl과 같은 것을 말함
        - jdbc:벤더:클라이언트 유형:내 머신 이름: 포트번호: 오라클 버전

  - **4단계: 문장객체(Statement) 생성한다.**

    - Connection 타입 변수.createStatement();를 이용

  - **5단계: Select의 경우 executeQurey()를 통해 주어진 SQL 문장을 실행한다.**

    - Statement executeQurey()
    - 쿼리문 입력

  - **6단계: ResultSet이라는 가상테이블을 처리한다.** 

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

### 3. JDBC 활용

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
     		System.out.println("aa1");
     		Connection conn = dbconn.getConnetion();
     		//4 stmt
     		JDBC jdbc = new JDBC();
     		System.out.println("aa22");
     		Statement stmt = jdbc.getStatement(conn);
     		//5.executeQuery
     		System.out.println("aa333");
     		ResultSet rs = jdbc.executeQuery(stmt);
     		//6.ResultSet을 처리
     		System.out.println("aa55555");
     		jdbc.ExecuteResultSet(rs);
     		//7.
     		System.out.println("aa77");
     		DBClose.close(conn, stmt, rs);
     	}
     	
     	public Statement getStatement(Connection conn){
     		Statement stmt = null;
     		try {
     			stmt = conn.createStatement();
     		} catch (SQLException e) {
     			System.out.println("Statement Error ");
     		}
     		return stmt;
     	}
     	
     	public ResultSet executeQuery(Statement stmt) {
     		ResultSet rs = null;
     		
     		System.out.print("SELECT ");
     		String select = sc.nextLine();
     		System.out.print("\nFROM ");
     		String from = sc.nextLine();
     		System.out.print("\nWHERE ");
     		String where = sc.nextLine();
     		
     		String query = "SELECT " + select + " FROM " + from;
     		if(where == null) query = query + "WHERE" + where;
     		
     		System.out.println("Entered Query... " + query);
     		try {
     			rs = stmt.executeQuery(query);
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

     