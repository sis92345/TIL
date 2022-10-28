package design.pattern.decorator.decorator;

import design.pattern.decorator.Beverage.Beverage;

/**
 * 데코레이터 : 두유
 * */
public class Soy extends Condiment{
		
		public Soy( Beverage beverage ) {
				super( beverage );
		}
		
		@Override
		public double cost() {
				return beverage.cost() + .32;
		}
		
		@Override
		public String getDescription() {
				return beverage.getDescription() + "두유";
		}
}
