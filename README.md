Simple crosspaltform useful implementation of Signals in one file.

### Compatibility

Compatible with targets:

* Flash
* Java
* Neko
* C++
* PHP
* JS
* Python

In the future: C#.



### Install:

```bash
mkdir ~/temp_for_install; cd ~/temp_for_install; \
wget https://bitbucket.org/fzzr/hx.signal/get/develop.zip; haxelib local develop.zip; \
rm -r ~/temp_for_install
```



### Usage:

See test for examples.

````haxe
var signal:Signal<Int -> Void>;

signal = new Signal();
signal.addOnce(
	function(value:Int):Void
	{
		trace('value "$value" from signal');
	});
signal.dispatch(1); // trace: value "1" from signal
signal.dispatch(1);
````