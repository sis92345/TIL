package design.pattern.command.command;

import design.pattern.command.receiver.Light;

public class LightOnCommand implements Command {
		
		Light light;
		
		public LightOnCommand( Light light ) {
				this.light = light;
		}
		
		@Override
		public void execute() {
			light.on();
		}
}
