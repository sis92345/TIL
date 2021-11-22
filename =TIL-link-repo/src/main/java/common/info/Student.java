package common.info;

import lombok.Getter;
import lombok.Setter;
import lombok.experimental.Accessors;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.RandomUtils;

import java.util.ArrayList;
import java.util.List;

/**
 * 자바 공부 용 학생 객체
 * */
@Getter
@Setter
@Accessors( chain = true )
public class Student {
		
		private String studentName;		// 학생 이름
		private int score;				// 점수
		private int studentClass;		// 반
		
		private List<Student> studentList = new ArrayList();	// 학생 개수
		
		public List<Student> generateRandomStudent( int size ){
				
				
				
				for( int i = 0 ; i < size ; i++ ){
						
						Student student = new Student();
						
						String studentName = RandomStringUtils.random(3, 44032, 55203, false, false);
						int score = RandomUtils.nextInt( 0 , 101 );
						int studentClass = RandomUtils.nextInt( 1 , 11 );
						
						student.setStudentName( studentName );
						student.setScore( score );
						student.setStudentClass( studentClass );
						
						this.studentList.add( student );
				}
				
				return this.studentList;
		}
		
}
