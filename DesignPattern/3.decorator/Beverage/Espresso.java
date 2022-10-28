package design.pattern.decorator.Beverage;

public class Espresso extends Beverage {
		
		public Espresso() {
				super.description = "에스프레소";
		}
		@Override
		public double cost() {
				return 1.99;
		}
}
