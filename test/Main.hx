package ;

import haxe.unit.TestRunner;

/**
	Created by Alexander "fzzr" Kozlovskij
	Date: 24.9.14
 **/
class Main
{
	//----------- properties, fields ------------//


	//--------------- constructor ---------------//
	public static function main():Void
	{
		var runner = new TestRunner();
		runner.add(new SignalTest());
		runner.add(new ExistingTest());

		var success = runner.run();

		#if sys
		Sys.exit(success ? 0 : 1);
		#end
	}

	public function new(){}


	//--------------- initialize ----------------//

	//---------------- control ------------------//

	//----------- handlers, callbacks -----------//

	//--------------- accessors -----------------//
}