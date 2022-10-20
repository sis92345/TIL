package design.pattern.adaptor.Turkey;

public class WildTurkey implements Turkey {
		
		@Override
		public void gobble() {
				System.out.println( "골골" );
		}
		
		@Override
		public void fly() {
				System.out.println( "짧은 거리를 날고 있어요!" );
		}
}
