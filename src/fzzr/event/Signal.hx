package fzzr.event;

import haxe.Constraints.Function in Method;


#if macro
import haxe.macro.Printer;
import haxe.macro.Context;
import haxe.macro.Expr;
#end


/**
	Created by Alex Koz aka "fzzr".
 **/
private interface ISignal<T:Method>
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
@:forward(add, addOnce, remove, removeAll, has)
#if !macro
@:build(fzzr.event.Signal.Builder.build()) #end
abstract Signal<T:Method>(ISignal<T>)
{
	public var dispatch(get, never):T;

	public function new();

	private inline function get_dispatch():T
		return this.dispatch;

	@:to
	private static inline function toSignal0(signal:ISignal<Void -> Void>):Signal0
		return new Signal0();

	@:to
	private static inline function toSignal1<T1>(signal:ISignal<T1 -> Void>):Signal1<T1>
		return new Signal1();

	@:to
	private static inline function toSignal2<T1, T2>(signal:ISignal<T1 -> T2 -> Void>):Signal2<T1, T2>
		return new Signal2();

	@:to
	private static inline function toSignal3<T1, T2, T3>(signal:ISignal<T1 -> T2 -> T3 -> Void>):Signal3<T1, T2, T3>
		return new Signal3();

	@:to
	private static inline function toSignal4<T1, T2, T3, T4>(signal:ISignal<T1 -> T2 -> T3 -> T4 -> Void>):Signal4<T1, T2, T3, T4>
		return new Signal4();
}

private class Handler<T>
{
	public var listener:T;
	public var dispatchOnce(default, null):Bool = false;

	public function new(listener:T, dispatchOnce:Bool)
	{
		this.listener = listener;
		this.dispatchOnce = dispatchOnce;
	}

	public function dispose()
		listener = null;
}

#if !macro
@:autoBuild(fzzr.event.Signal.Builder.buildSignalImpl()) #end
private class Base<T:Method> implements ISignal<T>
{
	macro static function buildDispatch(exprs:Array<Expr>):Expr
	{
		return macro
		{
			for(handler in handlers)
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

	private var handlers:Array<Handler<T>>;

	public function new()
	{
		handlers = [];
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
				handlers.remove(handler);
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
		while(handlers.length > 0)
		{
			var handler = handlers.pop();
			handler.dispose();
			handler = null;
		}
	}

	public function dispose():Void
	{
		removeAll();
		handlers = null;
	}

	private function registerListener(listener:T, dispatchOnce:Bool):Handler<T>
	{
		var handler = getHandler(listener);

		if(handler == null)
		{
			handler = new Handler<T>(listener, dispatchOnce);
			handlers.push(handler);
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

	private function getHandler(listener:T):Handler<T>
	{
		for(handler in handlers)
		{
			if(handler.listener == listener)
				// Listener was already registered.
				return handler;
		}

		// Listener not yet registered.
		return null;
	}
}

private class Signal0 extends Base<Void -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch0;
	}

	private function dispatch0():Void
		Base.buildDispatch();
}

private class Signal1<T1> extends Base<T1 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch1;
	}

	private function dispatch1(value1:T1):Void
		Base.buildDispatch(value1);
}

private class Signal2<T1, T2> extends Base<T1 -> T2 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch2;
	}

	private function dispatch2(value1:T1, value2:T2):Void
		Base.buildDispatch(value1, value2);
}

private class Signal3<T1, T2, T3> extends Base<T1 -> T2 -> T3 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch3;
	}

	private function dispatch3(value1:T1, value2:T2, value3:T3):Void
		Base.buildDispatch(value1, value2, value3);
}

private class Signal4<T1, T2, T3, T4> extends Base<T1 -> T2 -> T3 -> T4 -> Void>
{
	public function new()
	{
		super();
		this.dispatch = dispatch4;
	}

	private function dispatch4(value1:T1, value2:T2, value3:T3, value4:T4):Void
		Base.buildDispatch(value1, value2, value3, value4);
}

typedef Signl<T> = Signal<T -> Void>;


@:enum abstract SignalError(String) to String
{
	var HandlerExisting = "You cannot addOnce() then add() the same listener without removing the relationship first.";
}


#if macro
class Builder
{
	public static function build()
	{
		Context.onTypeNotFound(function(s:String)
		                       {
			                       return null;
		                       });
		Context.onGenerate(function(callback:Array<haxe.macro.Type>):Void
		                   {
		                   });

		Context.onAfterGenerate(function():Void
		                        {
		                        });

		return null;
	}


	public static function buildSignalImpl():Array<Field>
	{
		var fields = Context.getBuildFields();
		return fields;
	}
}
#end