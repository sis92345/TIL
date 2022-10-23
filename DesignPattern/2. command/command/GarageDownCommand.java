package design.pattern.command.command;

import design.pattern.command.receiver.Garage;

public class GarageDownCommand implements Command {
		
		Garage garage;
		
		public GarageDownCommand( Garage garage ) {
				this.garage = garage;
		}
		
		@Override
		public void execute() {
				garage.down();
		}
}
