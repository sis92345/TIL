package design.pattern.decorator.badcase;

public class DarkRoast extends Beverage_bad {
		
		public DarkRoast() {
				super.description = "에티오피아 수프리모를 로스팅한 최고의 다크 로스트 커피";
		}
		
		@Override
		public double cost() {
			
				super.milk = 300;
				super.mocha = 500;
				super.bean = 3200;
				return super.bean + super.milk + super.mocha;
		}
}
