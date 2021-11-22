package stream;

import common.info.Student;
import org.apache.commons.lang3.time.StopWatch;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.*;

/**
 * 스트림의 종류
 * 	- Stream Interface
 * 		- Stream
 * 		- IntStream
 * 		- DoubleInterface
 * 		- LongInterface
 * */
public class StreamKind {
		
		public static void main( String[] args ) {
				StreamKind streamKind = new StreamKind();
				
				//0. 컬렉션과 배열의 stream
				streamKind.getStream();
				
				// 1.기본 stream
				streamKind.stream();
				
				// 2. IntStream
				streamKind.intStream( 1 , 300 );
				
				// 3. doubleStream
				streamKind.doubleStream( 1.1 , 23.5 , 332.2 , 23.5 );
				
				// 4. LonsStream
				streamKind.longStream( 2131312, 213123123,  213113123 , 123123 );
				
				// 5. stream.mapTo*
				streamKind.getStreamByMapToMethod();
				
				// 6. reduce vs mapToint
				streamKind.boxingProblem();
		}
		
		/**
		 * BaseStream Interface
		 * 	- Stream
		 * 	- IntStream
		 * 	- LongStream
		 * 	- DoubloeStream
		 * */
		
		/**
		 * stream 컬렉션에서 얻기 + 배열에서 얻기
		 * @see java.util.Collection.stream() : https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html#stream--
		 * @see java.util.Arrays.stream( T[] array ) : https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#stream-T:A-
		 * */
		void getStream(){
			
				// 컬렉션에서
				List<String> list = new ArrayList<>();
				list.add( "1" );
				list.add( "2" );
				list.add( "3" );
				
				list.stream().forEach( System.out::println );
				
				// 배열 에서
				String[] stringArr = {"월", "화", "수", "목", "금", "토", "일"};
				
				Stream<String> stream = Arrays.stream( stringArr );
				stream.forEach( System.out::println );
				
		}
		
		/**
		 * Stream : 객체 요소를 처리하는 스트림
		 * */
		void stream(){
				
				int size = 100;
				List<Student> list = new Student().generateRandomStudent( size );
				
				Long passedStudent = list.stream().filter( item ->  50 < item.getScore() ).count();

				System.out.println( size + "명 중 시험을 통과한 사람은 " + passedStudent + "명" );
		}
		
		/**
		 * IntStream
		 * @param startInclusive
		 * @param endInclusive
		 * @see java.util.stream.IntStream.range( startInclusive , endInclusive ) https://docs.oracle.com/javase/8/docs/api/java/util/stream/IntStream.html#range-int-int-
		 * @see java.util.stream.IntStream.rangeClosed( startInclusive , endInclusive ) https://docs.oracle.com/javase/8/docs/api/java/util/stream/IntStream.html#range-int-int-
		 * */
		void intStream( int startInclusive , int endInclusive ){
				
				int sum = IntStream.rangeClosed( startInclusive, endInclusive ).sum();
				
				System.out.println( startInclusive + " 부터 " + endInclusive + "까지의 합은 "  +  sum );
		}
		
		/**
		 * doubleStream
		 * @see java.util.stream.DoubleStream.of( double ...value ) : https://docs.oracle.com/javase/8/docs/api/java/util/stream/DoubleStream.html#of-double...-
		 * */
		void doubleStream( double ...values ){
				double avg = DoubleStream.of( values ).average().getAsDouble();
				
				System.out.println( avg );
		}
		
		/**
		 * LongStream
		 * @see java.util.stream.LongStream.of( Long ...values ) https://docs.oracle.com/javase/8/docs/api/java/util/stream/LongStream.html#of-long...-
		 * */
		void longStream( long ...values ){
				
				Long sum = LongStream.of( values ).sum();
				
				System.out.println( sum );
				
		}
		
		/**
		 * stream의 mapTo*을 시용하면 각 *stream을 반환합니다.
		 * @see java.util.stream.maptToInt( ToIntFunction<? super T> mapper ) https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToInt-java.util.function.ToIntFunction-
		 * @see java.util.stream.maptToDouble( ToIntFunction<? super T> mapper ) https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToDouble-java.util.function.ToDoubleFunction-
		 * @see java.util.stream.maptToLong( ToIntFunction<? super T> mapper ) hhttps://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html#mapToLong-java.util.function.ToLongFunction-
		 * */
		void getStreamByMapToMethod(){
				
				List<Student> list = new Student().generateRandomStudent( 500 );
				
				// 1. mapToInt는 IntStream을 반환합니다.
				int sum = list.stream().map( Student::getScore ).mapToInt( i -> i ).sum();
				
				// 2. mapToDouble은 DoubleStream을 반환합니다.
				double avg = list.stream().map( Student::getScore ).mapToDouble( i -> i ).average().getAsDouble();
				
				// 3. mapToLong은 LongStream을 반환합니다,
				Long longSum = list.stream().map( Student::getScore ).mapToLong( i -> i ).sum();
				
				//4. as***Stream()도 가능
				
				System.out.println( sum );
				System.out.println( avg );
				System.out.println( longSum);
		}
		
		/**
		 * stream.reduce vs IntStream.reduce
		 * stream은 제너릭을 사용하므로 reduce 연산 시 autoboxing -> 속도 문제 가능성
		 * 따라서 경우에 따라 IntStream을 사용하거나 mapToInt로 IntStream을 전환하여 새용하여 오토 박싱을 피할 수 있다.
		 * 불필요한 오토 박싱을 피하자
		 * */
		void boxingProblem(){
				
				List<Student> list = new Student().generateRandomStudent( 9999999 );
				
				// 1. general stream
				
				
				
				// 아래는 Integer인지 체크용
//				int check = list.stream().map( Student::getScore ).reduce( ( item , arr )-> {
//						int multipleItem = item *= 2;
//						System.out.println( "reduce rambda에서 가져온 한 요소는 ..." + item.getClass().getName() );
//						return item;
//				} ).get();
				
				StopWatch stopWatch = StreamBasic.getMethodProcessTime();
				
				int sum = list.stream().map( Student::getScore ).reduce( ( item , arr )-> item *= 2 ).get();
				
				StreamBasic.getMethodProcessTime( stopWatch );
				
				// 2. general stream
				StopWatch stopWatch2 = StreamBasic.getMethodProcessTime();
				int intSum = list.stream().map( Student::getScore ).mapToInt( i -> i ).reduce( ( item , arr ) -> item *= 2  ).getAsInt();
				StreamBasic.getMethodProcessTime( stopWatch2 );
				
		}
		
		
}
