package design.pattern.decorator.badcase;

/**
 * 데코레디터가 적용이 안 된 케이스
 *
 * 모든 카페의 음료수는 음료 객체를 구현해야 합니다.
 *
 * 이제 모든 카페인 음료, 디카페인 음료, 라때 음료 등등은 cost 추상 클래스를 구현해야 한다!!
 *
 * 이 클래스는 두 디자인 원칙을 어기고 있다.
 * 1. 구성보다는 상속을 사용
 * 2. 변화에 유연하지 않음 : 만약 카라멜이 추가된다면?? -> cost를 고쳐햐 함
 * 3. 슈퍼 클래스에 상속되어 있을 경우 아이스티 같이 bean이 필요 없어도 hasBean같은 쓸모 없는 메소드를 포함한다.
 * 4. 만약 더블 모카를 주문한다면???
 *
 *
 * */
public abstract class Beverage_bad {
		
		protected String description;			// 음료수에 대한 하위 설명
		
		// 왠지 아래 필드가 서브 클래스들에게 필요할 것 같습니다 : 그런데 이렇게 추가하는 방법은 좋은 방법이 아닙니다.
		protected double bean;
		protected double milk;
		protected double soy;
		protected double mocha;
		
		public String getDescription() {
				return description;
		}
		
		// 비용을 설정 합니다.
		public double cost() {
		
				double milk = hasMilk() ? this.milk : 0;
				double soy = hasSoy() ? this.soy : 0;
				double bean = hasBean() ? this.bean : 0;
				double mocha = hasMocha() ? this.mocha : 0;
				
				return milk + soy + bean + mocha;
		};
		
		public boolean hasMilk() {
				return milk > 0;
		}
		
		public boolean hasSoy() {
				return soy > 0;
		}
		
		public boolean hasBean() {
				return bean > 0;
		}
		
		public boolean hasMocha() {
				return mocha > 0;
		}
}

