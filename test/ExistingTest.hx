package ;

import fzzr.event.Signal;
import haxe.unit.TestCase;

/**
	Created by Alexander "fzzr" Kozlovskij
 **/
class ExistingTest extends TestCase
{
	//----------- properties, fields ------------//

	var signal:Signal<Void -> Void>;

	//--------------- constructor ---------------//

	public function new()
	{
		super();
	}


	//--------------- initialize ----------------//

	override public function setup():Void
	{
		signal = new Signal();
	}

	override public function tearDown():Void
	{
		signal = null;
	}

	//----------------- tests -------------------//

	public function testAdd()
	{
		function handler(){};
		signal.add(handler);
		assertTrue(signal.has(handler));
	}

	public function testAddRemove()
	{
		function handler(){};

		signal.add(handler);
		signal.remove(handler);
		assertFalse(signal.has(handler));
	}

	public function testAddRemoveDouble()
	{
		function handler(){};

		signal.add(handler);
		assertTrue(signal.has(handler));
		signal.add(handler);
		assertTrue(signal.has(handler));

		signal.remove(handler);
		assertFalse(signal.has(handler));
	}


	public function testAddOnce()
	{
		function handler(){};

		signal.addOnce(handler);
		assertTrue(signal.has(handler));

		signal.dispatch();
		assertFalse(signal.has(handler));
	}


	public function testAddOnceRemove()
	{
		function handler(){};

		signal.addOnce(handler);
		signal.remove(handler);
		assertFalse(signal.has(handler));
	}

	public function testAddOnceRemoveDouble()
	{
		function handler(){};

		signal.addOnce(handler);
		signal.addOnce(handler);
		signal.dispatch();
		assertFalse(signal.has(handler));

		signal.addOnce(handler);
		signal.addOnce(handler);
		signal.remove(handler);
		assertFalse(signal.has(handler));
	}

	public function testAddOnceOverride()
	{
		function handler(){};

		signal.addOnce(handler);
		try
		{
			signal.add(handler);
			assertFalse(true);

		}
		catch(error:SignalError)
		{
			assertEquals(error, SignalError.HandlerExisting);
		}
		assertTrue(signal.has(handler));
		signal.dispatch();
		assertFalse(signal.has(handler));


		signal.add(handler);
		try
		{
			signal.addOnce(handler);
			assertFalse(true);

		}
		catch(error:SignalError)
		{
			assertEquals(error, SignalError.HandlerExisting);
		}
		assertTrue(signal.has(handler));
		signal.dispatch();
		signal.dispatch();
		assertTrue(signal.has(handler));

		signal.remove(handler);
		assertFalse(signal.has(handler));
	}
}
