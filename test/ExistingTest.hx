package ;

import fzzr.event.Signal;
import haxe.unit.TestCase;

/**
	Created by Alexander "fzzr" Kozlovskij
 **/
class ExistingTest extends TestCase
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

	public function testAdd()
	{
		function handler()
		{};
		signal0.add(handler);
		assertTrue(signal0.has(handler));
	}

	public function testAddRemove()
	{
		function handler()
		{};

		signal0.add(handler);
		signal0.remove(handler);
		assertFalse(signal0.has(handler));
	}

	public function testAddRemoveDouble()
	{
		function handler()
		{};

		signal0.add(handler);
		assertTrue(signal0.has(handler));
		signal0.add(handler);
		assertTrue(signal0.has(handler));

		signal0.remove(handler);
		assertFalse(signal0.has(handler));
	}


	public function testAddOnce()
	{
		function handler()
		{};

		signal0.addOnce(handler);
		assertTrue(signal0.has(handler));

		signal0.dispatch();
		assertFalse(signal0.has(handler));
	}


	public function testAddOnceRemove()
	{
		function handler()
		{};

		signal0.addOnce(handler);
		signal0.remove(handler);
		assertFalse(signal0.has(handler));
	}

	public function testAddOnceRemoveDouble()
	{
		function handler()
		{};

		signal0.addOnce(handler);
		signal0.addOnce(handler);
		signal0.dispatch();
		assertFalse(signal0.has(handler));

		signal0.addOnce(handler);
		signal0.addOnce(handler);
		signal0.remove(handler);
		assertFalse(signal0.has(handler));
	}

	public function testAddOnceOverride()
	{
		function handler()
		{};

		signal0.addOnce(handler);
		try
		{
			signal0.add(handler);
			assertFalse(true);

		}
		catch(error:SignalError)
		{
			assertEquals(error, SignalError.HandlerExisting);
		}
		assertTrue(signal0.has(handler));
		signal0.dispatch();
		assertFalse(signal0.has(handler));


		signal0.add(handler);
		try
		{
			signal0.addOnce(handler);
			assertFalse(true);

		}
		catch(error:SignalError)
		{
			assertEquals(error, SignalError.HandlerExisting);
		}
		assertTrue(signal0.has(handler));
		signal0.dispatch();
		signal0.dispatch();
		assertTrue(signal0.has(handler));

		signal0.remove(handler);
		assertFalse(signal0.has(handler));
	}
}
