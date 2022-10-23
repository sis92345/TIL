package design.pattern.command.receiver;

public class Light {
		
		public void on() {
				System.out.println( "불이 켜진다." );
		}
		
		public void off() {
				System.out.println( "불이 꺼진다." );
		}
}
