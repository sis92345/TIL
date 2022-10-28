package design.pattern.decorator.Beverage;

/**
 * 음료수 클래스
 *
 * 사실 데코레이터 패턴에서 상속은 같은 인터페이스를 맞추는데 핵심이기 때문에 인터페이스로 하는게 좋지만, 같은 코드 구현을 피하기 위해서는 적절히 추상 클래스를 사용하는 것 도 좋다.
 * */
public abstract class Beverage {
		
		public static enum Size { TALL, GRANDE, VENTI };
		protected String description = "제목 없음";		// 음료 설명
		protected Size size = Size.TALL;
		
		public String getDescription() {
				return this.description;
		}
		
		public void setSize( Size size ) {
				this.size = size;
		}
		
		public Size getSize() {
				return size;
		}
		
		// 음료수의 가격을 결정합니다.
		public abstract double cost();
}
