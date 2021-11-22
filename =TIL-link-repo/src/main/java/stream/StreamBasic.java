
package stream;

import common.info.Student;
import org.apache.commons.lang3.RandomStringUtils;
import org.apache.commons.lang3.time.StopWatch;
import sun.awt.windows.ThemeReader;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Stream;

/**
 * <pre>
 *         Java Stream의 기본적인 내용을 다룹니다
 *         1. Stream 이란?
 *         2. Stream의 특징
 * </pre>
 * */
public class StreamBasic {
		
		private static List<String> testArray = new ArrayList<>();
		
		public static void main( String[] args ) {
				
				StreamBasic streamBasic = new StreamBasic();
				
				testArray = streamBasic.generateTestArray( 50000 );
				
				// 1. itrator 구현
				//streamBasic.iteratorLoop( testArray );
				
				// 2. Stream을 이용한 처리
				//streamBasic.streamLoop( testArray );
				
				streamBasic.study_Characteristic( testArray );
		}
		
		/**
		 * 메소드 측정 시간 시작
		 * @return StopWatch
		 * */
		static StopWatch getMethodProcessTime(){
				StopWatch stopWatch = new StopWatch();
				stopWatch.start();
				return stopWatch;
		}
		/**
		 * 메소드 측정 시간 끝
		 * @param stopWatch
		 * */
		static void getMethodProcessTime( StopWatch stopWatch ){
			stopWatch.stop();
			System.out.println( stopWatch.getTime( TimeUnit.MILLISECONDS ) + " MS 초" );
		}
		
		/**
		 * 테스트 용 데이터를 생성합니다.
		 * @param size
		 * @return arrayList
		 * */
		List<String> generateTestArray( int size ){
				
				List<String> tempTestArray = new ArrayList<>();
				
				for( int i = 0 ; i < size ; i++ ){
						String randomString = RandomStringUtils.random( 1 );
						tempTestArray.add( randomString );
				}
				
				return tempTestArray;
		}
		
		/**
		 * Stream 사용 전의 반복 처리 : itrator
		 * @param arrayList
		 * */
		void iteratorLoop( List<String> arrayList ){
				
				StopWatch stopWatch = StreamBasic.getMethodProcessTime();
				
				Iterator<String> iterator = arrayList.iterator();
				
				while ( iterator.hasNext() ){
						String value = iterator.next();	//next() 외부 반복자로 itrator를 반복시킨다.
						System.out.println( value );
				}
				
				StreamBasic.getMethodProcessTime( stopWatch );
				
		}
		
		/**
		 * Stream을 사용한 반복 처리 : Stream
		 * @param arrayList
		 * */
		void streamLoop( List<String> arrayList ){
				
				StopWatch stopWatch = StreamBasic.getMethodProcessTime();
				
				//결국 itrator와 stream의 차이는 속도보다는 병렬 처리나 람다식 처리 같은 코드 부분에서 많은 차이를 보인다.
				arrayList.stream().forEach( System.out::println ); // === arrayList.stream().forEach( item -> System.out.println( item ) );
				
				getMethodProcessTime( stopWatch );
				
		}
		
		/**
		 * 스트림의 특징에 대해서 알아본다,
		 **/
		private void study_Characteristic( List<String> testArray ){
				
				StopWatch stopWatch = StreamBasic.getMethodProcessTime();
				
				// 1. 람다식으로 요소 처리 코드를 제공 : 람다식이나 메소드 참조로 요소 처리 내용을 파라메터로 사용 가능
//				Stream<String> streamRambda = testArray.stream();
//
//				streamRambda.forEach( item -> System.out.println( item ) );
//
//				System.out.println( "===================================" );
//
//				Stream<String> stringMethodReference = testArray.stream();
//
//				stringMethodReference.forEach( System.out::println );
				
				
				// 2. 내부 반복자를 사용한다. 개발자는 요소 처리 코드에만 집중 + 병렬 처이 용이
				
				// 병령 처리 할 경우
				List<Student> studentList = new Student().generateRandomStudent( 5000000 );
				
				studentList.parallelStream().forEach( StreamBasic::print );
				
				
				// 병렬 처리를 하지 않을 경우
				//studentList.stream().forEach( StreamBasic::print );
				
				// 3. 중간 처리와 최종 처리를 할 수 있다.
				// 중간 처리는 매핑 , 필터링 , 집계를 수행
				// 최종 처리는 반복, 카운팅 , 평균 , 총합 등의 집계 처리를 수행
				
				//double avg = studentList.stream().mapToInt( Student::getScore ).average().getAsDouble();
				//System.out.println( avg );
				
				getMethodProcessTime( stopWatch );
		}
		
		static void print( Student student ){
				System.out.println( student.getStudentName() + "/" + student.getScore() + " : " + Thread.currentThread().getName() );
		}
}
