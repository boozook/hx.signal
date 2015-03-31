package haxe.event;

#if macro
import haxe.macro.Expr;
#end


/**
	Created by Alex Koz aka "fzzr".
	Inspired by FlxSignal
 **/


/*
TODO: Generate it via macro instead that:
	private class Signal1<T1> extends SignalBase<T1 -> Void>
	private class Signal2<T1, T2> extends SignalBase<T1 -> T2 -> Void>
	private class Signal3<T1, T2, T3> extends SignalBase<T1 -> T2 -> T3 -> Void>
	private class Signal4<T1, T2, T3, T4> extends SignalBase<T1 -> T2 -> T3 -> T4 -> Void>
*/


typedef SignalEmpty = Signal<Void -> Void>;

@:keep
interface ISignal<T>
{
	public var dispatch:T;
	public function add(listener:T):Void;
	public function addOnce(listener:T):Void;
	public function remove(listener:T):Void;
	public function removeAll():Void;
	public function has(listener:T):Bool;

	public function dispose():Void;
}


@:keep
@:multiType
abstract Signal<T>(ISignal<T>)
{
	public var dispatch(get, never):T;

	public function new();

	public inline function add(listener:T):Void
	{
		this.add(listener);
	}

	public inline function addOnce(listener:T):Void
	{
		this.addOnce(listener);
	}

	public inline function remove(listener:T):Void
	{
		this.remove(listener);
	}

	public inline function has(listener:T):Bool
	{
		return this.has(listener);
	}

	public inline function removeAll():Void
	{
		this.removeAll();
	}

	private inline function get_dispatch():T
	{
		return this.dispatch;
	}

	@:to
	private static inline function toSignal0(signal:ISignal<Void -> Void>):Signal0
	{
		return new Signal0();
	}

	@:to
	private static inline function toSignal1<T1>(signal:ISignal<T1 -> Void>):Signal1<T1>
	{
		return new Signal1();
	}

	@:to
	private static inline function toSignal2<T1, T2>(signal:ISignal<T1 -> T2 -> Void>):Signal2<T1, T2>
	{
		return new Signal2();
	}

	@:to
	private static inline function toSignal3<T1, T2, T3>(signal:ISignal<T1 -> T2 -> T3 -> Void>):Signal3<T1, T2, T3>
	{
		return new Signal3();
	}

	@:to
	private static inline function toSignal4<T1, T2, T3, T4>(signal:ISignal<T1 -> T2 -> T3 -> T4 -> Void>):Signal4<T1, T2, T3, T4>
	{
		return new Signal4();
	}
}

private class SignalHandler<T>
{
	public var listener:T;
	public var dispatchOnce(default, null):Bool = false;

	public function new(listener:T, dispatchOnce:Bool)
	{
		this.listener = listener;
		this.dispatchOnce = dispatchOnce;
	}

	public function dispose()
	{
		listener = null;
	}
}

private class SignalBase<T> implements ISignal<T>
{
	macro static function buildDispatch(exprs:Array<Expr>):Expr
	{
		return macro
		{
			for(handler in _handlers)
			{
				handler.listener($a{exprs});

				if(handler.dispatchOnce)
					remove(handler.listener);
			}
		}
	}

	/**
	 * Typed function reference used to dispatch this signal.
	 */
	public var dispatch:T;

	private var _handlers:Array<SignalHandler<T>>;

	public function new()
	{
		_handlers = [];
	}

	public function add(listener:T)
	{
		if(listener != null)
			registerListener(listener, false);
	}

	public function addOnce(listener:T):Void
	{
		if(listener != null)
			registerListener(listener, true);
	}

	public function remove(listener:T):Void
	{
		if(listener != null)
		{
			var handler = getHandler(listener);
			if(handler != null)
			{
				_handlers.remove(handler);
				handler.dispose();
				handler = null;
			}
		}
	}

	public function has(listener:T):Bool
	{
		if(listener == null)
			return false;
		return getHandler(listener) != null;
	}

	public inline function removeAll():Void
	{
		while(_handlers.length > 0)
		{
			var handler = _handlers.pop();
			handler.dispose();
			handler = null;
		}
	}

	public function dispose():Void
	{
		removeAll();
		_handlers = null;
	}

	private function registerListener(listener:T, dispatchOnce:Bool):SignalHandler<T>
	{
		var handler = getHandler(listener);

		if(handler == null)
		{
			handler = new SignalHandler<T>(listener, dispatchOnce);
			_handlers.push(handler);
			return handler;
		}
		else
		{
			// If the listener was previously added, definitely don't add it again.
			// But throw an exception if their once values differ.
			if(handler.dispatchOnce != dispatchOnce)
				throw SignalError.HandlerExisting;
			else
				return handler;
		}
	}

	private function getHandler(listener:T):SignalHandler<T>
	{
		for(handler in _handlers)
		{
			if(handler.listener == listener)
				// Listener was already registered.
				return handler;
		}

		// Listener not yet registered.
		return null;
	}
}

private class Signal0 extends SignalBase<Void -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch0;
	}

	private function dispatch0():Void
	{
		SignalBase.buildDispatch();
	}
}

private class Signal1<T1> extends SignalBase<T1 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch1;
	}

	private function dispatch1(value1:T1):Void
	{
		SignalBase.buildDispatch(value1);
	}
}

//TODO: remove it & gen in build-macro:
private class Signal2<T1, T2> extends SignalBase<T1 -> T2 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch2;
	}

	private function dispatch2(value1:T1, value2:T2):Void
	{
		SignalBase.buildDispatch(value1, value2);
	}
}

//TODO: remove it & gen in build-macro:
private class Signal3<T1, T2, T3> extends SignalBase<T1 -> T2 -> T3 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch3;
	}

	private function dispatch3(value1:T1, value2:T2, value3:T3):Void
	{
		SignalBase.buildDispatch(value1, value2, value3);
	}
}

//TODO: remove it & gen in build-macro:
private class Signal4<T1, T2, T3, T4> extends SignalBase<T1 -> T2 -> T3 -> T4 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch4;
	}

	private function dispatch4(value1:T1, value2:T2, value3:T3, value4:T4):Void
	{
		SignalBase.buildDispatch(value1, value2, value3, value4);
	}
}


@:enum abstract SignalError(String) from String to String
{
	var HandlerExisting:String = "You cannot addOnce() then add() the same listener without removing the relationship first.";
}