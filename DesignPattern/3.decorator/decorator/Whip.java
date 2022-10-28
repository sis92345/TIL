package design.pattern.decorator.decorator;

import design.pattern.decorator.Beverage.Beverage;

/**
 * 데코레이터 : 휘핑
 * */
public class Whip extends Condiment{
		
		public Whip( Beverage beverage ) {
				super( beverage );
		}
		
		@Override
		public double cost() {
				return beverage.cost() + .50;
		}
		
		@Override
		public String getDescription() {
				return beverage.getDescription() + "휘핑";
		}
}
