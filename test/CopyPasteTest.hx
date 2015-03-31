package ;

import fzzr.event.Signal;
import haxe.unit.TestCase;

// demo for Haxe-plugin issue #196 (https://github.com/TiVo/intellij-haxe/issues/196)
class CopyPasteTest extends TestCase
{
	var signal:SignalEmpty;

	public function new()
	{
		super();
	}

	override public function setup():Void
	{
		signal = new Signal();
	}

	override public function tearDown():Void
	{
		signal = null;
	}

	public function testCopyPaste():Void
	{
		assertTrue(true);

		function handler(){};
		signal.add

		ffffffff WTF?????
	}
}
