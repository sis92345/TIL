package design.pattern.command.receiver;

public class Garage {
		
		public void up() {
				System.out.println( "드르륵~ 문이 올라갑니다." );
		}
		
		public void down() {
				System.out.println( "문이 내려갑니다." );
		}
		
		public void workToGarage() {
				System.out.println( "차고로 들어갑니다!" );
		}
}
