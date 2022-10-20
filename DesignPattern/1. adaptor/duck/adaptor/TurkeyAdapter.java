package design.pattern.adaptor.duck.adaptor;

import design.pattern.adaptor.Turkey.Turkey;
import design.pattern.adaptor.duck.Duck;

public class TurkeyAdapter implements Duck {
		
		Turkey turkey;
		
		public TurkeyAdapter( Turkey turkey ) {
			this.turkey = turkey;
		}
		
		@Override
		public void quack() {
			turkey.gobble();
		}
		
		@Override
		public void fly() {
				
				for ( int i = 0; i < 5; i++ ) {
						turkey.fly();
				}
		}
}
