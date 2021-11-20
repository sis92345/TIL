package stream;

import common.info.Student;

import java.util.List;

/**
 * Stream Filter : 중간 처리 , 요소를 걸러내는 역할
 * */
public class StreamFilter {
		
		public static void main( String[] args ) {
				
				StreamFilter streamFilter = new StreamFilter();
				
				// 1. distinct
				streamFilter.streamDistinct();
				
				// 2. filter
				streamFilter.streamFilter();
				
				
		}
		
		/**
		 * Stream distinct : 중복 제거
		 * */
		void streamDistinct(){
				
				List<Student> list = new Student().generateRandomStudent( 50 );
				
				list.stream().mapToInt( Student::getStudentClass )
							 .distinct()
							 .sorted()
							 .forEach( System.out::println );
				
		}
		
		/**
		 * Stream Filter : 파라메터로 주어진 Predicate가 true인 값만 반환
		 * */
		void streamFilter(){
				
				List<Student> list = new Student().generateRandomStudent( 500 );
				
				list.stream().filter( item -> {
								return 100 == item.getScore();
							} )
							.map( item -> item.getStudentName() + "/" + item.getScore() )
							.forEach( System.out::println );
				
		}
}
