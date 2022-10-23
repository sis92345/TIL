package design.pattern.command.command;

import design.pattern.command.receiver.Garage;

public class NoCommand implements Command {
		
		
		@Override
		public void execute() {
				System.out.println( "명령어 없음!" );
		}
}
