package design.pattern.decorator.decorator;

import design.pattern.decorator.Beverage.Beverage;

/**
 * 첨가물 클래스 : 데코레이터로서 동작하기 위해 Beverage Class를 상속받아 인터페이스르 맞춤
 * */
public abstract class Condiment extends Beverage {
		
		Beverage beverage;
		
		public Condiment( Beverage beverage ) {
				this.beverage = beverage;
		}
		
		public void setBeverage( Beverage beverage ) {
				this.beverage = beverage;
		}
		
		public Beverage getBeverage() {
				return this.beverage;
		}
		
		@Override
		public Size getSize() {
				return beverage.getSize();
		}
		
		public abstract String getDescription();
}
