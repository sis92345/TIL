package design.pattern.decorator.decorator;

import design.pattern.decorator.Beverage.Beverage;

/**
 * 데코레이터 : 모카
 * */
public class Mocha extends Condiment{
		
		public Mocha( Beverage beverage ) {
				super( beverage );
		}
		
		@Override
		public double cost() {
				
				double cost = 0;
				
				if ( Size.TALL.equals( super.getSize() ) ) {
						cost = 0.20;
				}
				else if ( Size.GRANDE.equals( super.getSize() ) ) {
						cost = 0.25;
				}
				else if ( Size.VENTI.equals( super.getSize() ) ) {
						cost = 0.30;
				}
				
				return beverage.cost() + cost;
		}
		
		@Override
		public String getDescription() {
				return beverage.getDescription() + "모카";
		}
}
