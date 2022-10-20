package design.pattern.adaptor.Turkey.adaptor;

import design.pattern.adaptor.Turkey.Turkey;
import design.pattern.adaptor.duck.Duck;

public class DuckAdaptor implements Turkey {
		
		Duck duck;
		
		public DuckAdaptor ( Duck duck ) {
				this.duck = duck;
		}
		@Override public void gobble() {
			duck.quack();
		}
		
		@Override public void fly() {
			duck.fly();
		}
}
