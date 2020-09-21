JDBC
==========

> MVC의 개념
>
> MVC의 구성요소: Model, View, Controller
>
> MVC의 예
>
> PreparedStatement

> JDBC 활용

### 1. MVC의 개념

---------------

- MVC와 디자인 패턴
  - 디자인패턴이란 프로그램이나 어떤 특정한 것을 개발하는 중에 밠행했던 문제점들을 정리해서 상황에 따라 간편하게 적용해서 쓸 수 있는 것을 정리하여 특정한 규약을 통해 쉽게 쓸 수 있는 형태로 만든 것이다.
    - 즉 프로그램은 좀 더 쉽고 편리하게 개발, 유지 보수, 사용하기 위해 만든 특정한 방법이다.
  - MVC Petten
    - MVC란 Model, View, Controller의 약자이다. 
    - 이는 한 프로그램을 개발할 때 그 구성요소를 3가지로 구분한 개념이다. 
    - MVC의 작동을 간략히 설명하자면, 사용자가 Controller를 조작하면, Controller는 model을 통해 데이터를 가져오고, 그 정보를 바탕으로 시각적인 표현을 담당하는 View를 제어해서 사용자에게 전달하게 된다. 
- MVC 패턴을 사용하는 이유
  - 프로그램 개발시 효과적인 분업이 가능
  - 유지보수, 확장성, 유연성을 늘린다.

### 2.  MVC의 구성요소

------

- Model
  - APP의 정보, 데이터를 나타내며, 이러한 Data들의 가공을 책임진다.
  - Database에서 직접 데이터를 읽고, 저장하고, 수정하고, 삭제하는 역할을 수행한다.
  - 모델의 규칙
    1. 뷰나 컨트롤러에 대해 어떤 정보도 알지 말아야 한다.
       - 데이터 변경이 일어났을 시 모델에서 화면 UI를 직접 수정 할 수 있도록 뷰를 참조하는 내부 속성값을 지니면 안된다.
    2. 변경이 일어나면, 변경 통지에 대한 처리방법을 구현해야 한다.
- View
  - View는 User Interface 요소를 나타낸다. 
  - 즉 View에서는 데이터 및 객체의 입력, 출력을 담당한다. 
  - 사용자가 직접적으로 볼 수 있는 화면이다.
  - View의 규칙
    1. View는 모델이 가지고 있는 정보를 저장해서는 안된다.???
       - 데이터를 출력하기위해 모델이 가지고 있는 정보를 컨트롤러부터 전달을 받는데 이 정보를 직접 저장하고 있으면 안된다.
    2. 변경이 일어나면, 변경 통지에 대한 처리방법을 구현해야 한다.
- Controller
  - View와 Model을 연결하는 역할을 한다. 
  - 즉 사용자가 데이터를 클릭하고, 수정하는 것에 대한 이벤트를 처리하는 부분이다.
  - 컨트롤러의 규칙
    1. 모델이나 뷰를 알고 있어야 한다.

### 3.  MVC의 작동 구조

------

- MVC는 Model, View, Controller로 분리되어 있다.

  - 이는 Front-end-side인 View에서 Database에 직접 접근하는 것을 막기 위함이며, 마찬가지로 Back-end-side에서 화면 UI를 직접 수정하지 않아야 한다.
  - 따라서 Contoller는 Model과 View를 연결하는 역할을 수행한다. 
    - Controller는 사용자가 View를 통해서 이벤트를 발생시키면, 그 이벤트에 대한 처리를 수행한다.
    - 이벤트는 Contorller를 거쳐 Model에서 데이터를 직접 처리하고 이를 다시 Contorll에서 다시 넘겨받아 View로 넘긴다.

- 예로 살펴보기: 성적관리 프로그램에 데이터를 추가할때 MVC의 동작

  1. View(UI)의 실행 --> 사용자의 값을 입력받고 Controller에 넘긴다.

     - 메인 UI

       ```java
       //Package Model
       private int showMenu() { //사용자가 직접 보는 화면 
       		System.out.println("성적관리 프로그램");
       		System.out.println("---------------");
       		System.out.println("1. 전체 학생 성적 조회");
       		System.out.println("2. 학생 이름으로 검색");
       		System.out.println("3. 학생 추가");
       		System.out.println("4. 학생 삭제");
       		System.out.println("9. 종료");
       		//메뉴 추가 -->
       		System.out.print("선택 >> ");
       		return sc.nextInt(); 
       	}
       private void process(int choice) { //showMenu()로부터 choice를 파라미터로 받는다.
       		switch(choice) { 
                       //생략
       			case 3:
       				Insert insert = new Insert(sc); // 1. insert 인스턴스 생성
       				insert.insert();  // 2. insert() 실행
       				break;
                       //생략
       		}
       		
       	}
       ```

       - insert

         ```java
         //Package Model	
         	public void insert() {
                 //값을 입력받는다.
         		System.out.print("학번: "); String id = sc.next();
         		System.out.print("이름: "); String name = sc.next();
         		System.out.print("국어: "); int kor = sc.nextInt();
         		System.out.print("영어: "); int mat = sc.nextInt();
         		System.out.print("수학: "); int eng = sc.nextInt();
         		Student std = new Student(id, name, kor, mat, eng);
         		int row = this.service.add(std); //3. Controller로 데이터를 넘긴다.
         		if(row == 1) System.out.println("학생이 추가되었습니다.");
         		else System.out.println("학생을 추가 할 수 없습니다.");		
         	}
         ```

  2. Controller는 입력받은 값을 처리하기 위해 Model과 연결한다 --> 이벤트를 처리

     ```java
     //Package Controller
     	@Override
     	public int add(Student std) {
     		int row = 0;
     		try { 
     			Calc calc = new Calc();
     			calc.calc(std);
     			row = this.dao.insert(std); //4. Model로 데이터를 넘긴다.
     		} catch (SQLException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     		}
     		return row;
     	}
     ```

  3. Model에서 실제로 직접 데이터를 가공한다

  4. 처리한 데이터를 Contoller로 넘긴다.

     ```java
     //package Model
     	public int insert(Student std) throws SQLException{ //5. insert()는 실제로 DB에 데이터를 삽입한다. --> Model은 데이터를 처리한다. 
     		this.dbconn = new DBConnection(); 
     		Connection conn = dbconn.getConnection();
     		String sql = "INSERT INTO Student VALUES(?,?,?,?,?,?,?,?)";
     		PreparedStatement pstmt = conn.prepareStatement(sql); 
     		pstmt.setString(1, std.getId());
     		pstmt.setString(2, std.getName());
     		pstmt.setInt(3, std.getKor());
     		pstmt.setInt(4, std.getEng());
     		pstmt.setInt(5, std.getMat());
     		pstmt.setInt(6, std.getTot());
     		pstmt.setDouble(7, std.getAvg());
     		pstmt.setString(8, Character.toString(std.getGrade())); 
     		int row = pstmt.executeUpdate();
     		DBClose.close(conn, pstmt);
     		return row; //6. 호출한 Controller의 add()로 값을 반환한다.
     	}
     ```

  5. Controller는 Model로 부터 받은 데이터를 View로 넘긴다.

     ```java
     //Package Controller
     	@Override
     	public int add(Student std) {
     		int row = 0;
     		try { 
     			Calc calc = new Calc();
     			calc.calc(std);
     			row = this.dao.insert(std); //7. View로 데이터를 넘긴다.
     		} catch (SQLException e) {
     			// TODO Auto-generated catch block
     			e.printStackTrace();
     		}
     		return row;
     	}
     ```

  6. View는 넘겨받은 데이터의 결과를 사용자에게 반환한다.

     ```java
     //Package Model	
     	public void insert() {
     		System.out.print("학번: "); String id = sc.next();
     		System.out.print("이름: "); String name = sc.next();
     		System.out.print("국어: "); int kor = sc.nextInt();
     		System.out.print("영어: "); int mat = sc.nextInt();
     		System.out.print("수학: "); int eng = sc.nextInt();
     		Student std = new Student(id, name, kor, mat, eng);
     		int row = this.service.add(std); //8. Controller에서 받은 데이터를 UI에 표시한다.
     		if(row == 1) System.out.println("학생이 추가되었습니다.");
     		else System.out.println("학생을 추가 할 수 없습니다.");		
     	}
     ```

- 따라서 MVC의 실행 구조는 View -> Contorller -> Model <-> RDBMS

  ​																				   | -> Controller -> View

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
  
     