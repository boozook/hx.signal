package ;

import fzzr.event.Signal;
import haxe.unit.TestCase;

/**
	Created by Alexander "fzzr" Kozlovskij
	Date: 24.9.14
 **/
class SignalTest extends TestCase
{
	//----------- properties, fields ------------//

	var catched:Int = 0;
	var signal0:SignalEmpty;
	var signal1:Signal<Int -> Void>;
	var signal2:Signal<Int -> Int -> Void>;
	var signal3:Signal<Int -> Int -> Int -> Void>;
	var signal4:Signal<Int -> Int -> Int -> Int -> Void>;


	//--------------- constructor ---------------//

	public function new()
	{
		super();
	}


	//--------------- initialize ----------------//

	override public function setup():Void
	{
		catched = 0;
		signal0 = new Signal();
		signal1 = new Signal();
		signal2 = new Signal();
		signal3 = new Signal();
		signal4 = new Signal();
	}

	override public function tearDown():Void
	{
		signal0 = null;
		signal1 = null;
		signal2 = null;
		signal3 = null;
		signal4 = null;
	}

	//---------------- control ------------------//

	public function testAdd0()
	{
		addTestUni(signal0, handler0);
		assertEquals(catched, 3);
	}

	public function testAddOnce0()
	{
		addOnceTestUni(signal0, handler0);
		assertEquals(catched, 1);
	}

	public function testAdd1()
	{
		addTestUni(signal1, handler1, [1], 3);
		assertEquals(catched, 3);
	}

	public function testAddOnce1()
	{
		addOnceTestUni(signal1, handler1, [1], 3);
		assertEquals(catched, 1);
	}

	public function testAdd2()
	{
		addTestUni(signal2, handler2, [1, 2], 3);
		assertEquals(catched, 3);
	}

	public function testAddOnce2()
	{
		addOnceTestUni(signal2, handler2, [1, 2], 3);
		assertEquals(catched, 1);
	}

	public function testAdd3()
	{
		addTestUni(signal3, handler3, [1, 2, 3], 3);
		assertEquals(catched, 3);
	}

	public function testAddOnce3()
	{
		addOnceTestUni(signal3, handler3, [1, 2, 3], 3);
		assertEquals(catched, 1);
	}

	public function testAdd4()
	{
		addTestUni(signal4, handler4, [1, 2, 3, 4], 3);
		assertEquals(catched, 3);
	}

	public function testAddOnce4()
	{
		addOnceTestUni(signal4, handler4, [1, 2, 3, 4], 3);
		assertEquals(catched, 1);
	}


	//--------------- tools -----------------//

	public function addTestUni(signal:Dynamic, handler:Dynamic, ?args:Array<Dynamic>, calls:Int = 3):Void
	{
		signal.add(handler);
		if(args == null)
			args = [];

		for(i in 0...calls)
			Reflect.callMethod(signal, signal.dispatch, args);
	}

	public function addOnceTestUni(signal:Dynamic, handler:Dynamic, ?args:Array<Dynamic>, calls:Int = 3)
	{
		signal.addOnce(handler);
		if(args == null)
			args = [];

		for(i in 0...calls)
			Reflect.callMethod(signal, signal.dispatch, args);
	}


	public function assertHas(handler)
	{
		assertTrue(signal0.has(handler));
	}

	private function handler0():Void
	{
		assertTrue(true);
		catched++;
	}

	private function handler1(_):Void
	{
		assertTrue(true);
		catched++;
	}

	private function handler2(_, _):Void
	{
		assertTrue(true);
		catched++;
	}

	private function handler3(_, _, _):Void
	{
		assertTrue(true);
		catched++;
	}

	private function handler4(_, _, _, _):Void
	{
		assertTrue(true);
		catched++;
	}
}