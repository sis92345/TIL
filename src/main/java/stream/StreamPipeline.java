package stream;

import common.info.Student;

import java.util.List;

/**
 * Stream PipeLine : 스트림 파이프 라인 -> 대량의 데이터를 가공해서 축소하는 것을 reduction이라고 하는데 데이터의 합계 , 평균값 등이 리덕션의 결과물
 * 	- 중간 처리
 * 	- 최종 처리
 * */
public class StreamPipeline {
		
		public static void main( String[] args ) {
			
			StreamPipeline streamPipeline = new StreamPipeline();
			streamPipeline.streamPipeLine( 5 );
			
		}
		
		void streamPipeLine( int selectClass ){
				
				List<Student> list = new Student().generateRandomStudent( 5000 );
				
				list.stream()																						// 오리지널 스트림
					.filter( item -> 90 < item.getScore() )															// 중간 처리
					.filter( item -> selectClass == item.getStudentClass() )										// 중간 처리
					.peek( item -> item.setStudentName( item.getStudentName() + "/" + item.getScore() ) )			// 중간 처리
					.map( Student::getStudentName )																	// 중간 처리
					.forEach( System.out::println );																// 최종 처리
				
		}
		
}