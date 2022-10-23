package design.pattern.command.command;

import design.pattern.command.receiver.Garage;
import design.pattern.command.receiver.Light;

public class GarageUpCommand implements Command {
		
		Garage garage;
		
		public GarageUpCommand( Garage garage ) {
				this.garage = garage;
		}
		
		@Override
		public void execute() {
			garage.up();
			garage.workToGarage();
		}
}
