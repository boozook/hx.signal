package ;

import haxe.ds.HashMap;
import haxe.event.Signal;
import haxe.unit.TestCase;

/**
	Created by Alexander "fzzr" Kozlovskij
 **/
class CopyPasteTest extends TestCase
{
	//----------- properties, fields ------------//

	var signal0:SignalEmpty;

	//--------------- constructor ---------------//

	public function new()
	{
		super();
	}


	//--------------- initialize ----------------//

	override public function setup():Void
	{
		signal0 = new Signal();
	}

	override public function tearDown():Void
	{
		signal0 = null;
	}

	//----------------- tests -------------------//

	public function testCopyPaste():Void
	{
		assertTrue(true);

		function handler(){};
		signal0.add
	}


	//----------------- tools -------------------//
}
