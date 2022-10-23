package design.pattern.command;

import design.pattern.command.command.Command;
import design.pattern.command.command.NoCommand;

import java.util.Objects;

/**
 * 클라이언트
 *
 * */
public class Invoker {
		
		/**
		 * 커멘트 패턴을 사용하면 요청하는 쪽과 그 작업을 처리하는 쪽을 분리할 수 있다.
		 * Commend Object는 특정 객체에 관한 특정 작업 요청을 캡슐화 한다. 따라서 클라이언트가 Commend Object를 사용하면 특정 객체와 작업을 몰라도 된디
		 *
		 *
		 * */
		
		Command[] onCommands;
		Command[] offCommands;
		
		public Invoker() {
		
				onCommands = new Command[7];
				offCommands = new Command[7];
				
				NoCommand noCommand = new NoCommand();
				for ( int i = 0 ; i < 7 ; i++ ){
						onCommands[i] = noCommand;
						offCommands[i] = noCommand;
				}
		}
		
		public void setCommand( int slot, Command onCommand, Command offCommand ){
				
				onCommands[slot] = onCommand;
				offCommands[slot] = offCommand;
		};
		
		public void pressedOnButton( int slot ){
				
				onCommands[slot].execute();
		}
		
		public void pressedOffButton( int slot ){
				
				offCommands[slot].execute();
		}
		
		public void pressedButton( int slot, String command ) {
				
				if ( Objects.equals( command, "on" ) ) {
						onCommands[slot].execute();
				}
				else {
						offCommands[slot].execute();
				}
		}
		
		
		
		
}
