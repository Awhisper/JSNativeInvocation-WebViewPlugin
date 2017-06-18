//
//     ____    _                        __     _      _____
//    / ___\  /_\     /\/\    /\ /\    /__\   /_\     \_   \
//    \ \    //_\\   /    \  / / \ \  / \//  //_\\     / /\/
//  /\_\ \  /  _  \ / /\/\ \ \ \_/ / / _  \ /  _  \ /\/ /_
//  \____/  \_/ \_/ \/    \/  \___/  \/ \_/ \_/ \_/ \____/
//
//	Copyright Samurai development team and other contributors
//
//	http://www.samurai-framework.com
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.
//

;global = this;

(function( global ){

	global.self = null;
 
	global.YES = true;
	global.NO = false;
	global.nil = null;
 
	global.includedFiles = {};
	global.importedClasses = {};

	global.classNameSeed = 0;

	function __isNone( object )
	{
		if ( _.isNaN( object ) || _.isNil( object ) || _.isNull( object ) || _.isUndefined( object ) )
		{
			return true;
		}
		else
		{
			return false;
		}
	};

	function __isPrimitive( object )
	{
		if ( _.isNumber( object ) || _.isBoolean( object ) || _.isString( object ) )
		{
			return true;
		}
		else if ( _.isDate( object ) || _.isRegExp( object ) )
		{
			return true;
		}
		else
		{
			return false;
		}
	};

	function __isArray( object )
	{
		return _.isArray( object );
	};

	function __isObject( object )
	{
		return _.isObject( object );
	};

	function __isFunction( object )
	{
		return _.isFunction( object );
	};

	function __boxObject( object )
	{
		if ( __isNone( object ) )
		{
			return object;
		}
		else if ( __isPrimitive( object ) )
		{
			return object;
		}
		else if ( __isFunction( object ) )
		{
			return object;
		}
		else if ( __isArray( object ) )
		{
			var array = [];

			for ( var index in object )
			{
				array.push( __boxObject( object[index] ) );
			}

			return array;
		}
		else if ( __isObject( object ) )
		{
			if ( object['__nil__'] )
			{
				return null;
			}
			else if ( object['__obj__'] )
			{
				var className = object['__cls__'];
				if ( __isNone( className ) )
					return null;

				var unboxedObject = object['__obj__'];
				if ( __isNone( unboxedObject ) )
					return null;

				var nativeObject = new BoxedObject( unboxedObject, className );
				if ( __isNone(nativeObject) )
					return null;

				return nativeObject;
			}
			else
			{
				var dictionary = {};

				for ( var key in object )
				{
					dictionary[key] = __boxObject( object[key] );
				}

				return dictionary;
			}
		}
		else
		{
			return object;
		}
	};

	function __unboxObject( object )
	{
		if ( __isNone( object ) )
		{
			return object;
		}
		else if ( __isPrimitive( object ) )
		{
			return object;
		}
		else if ( __isFunction( object ) )
		{
			return { '__func__' : object, '__args__' : object.length };
		}
		else if ( __isArray( object ) )
		{
			var array = [];

			for ( var index in object )
			{
				array.push( __unboxObject( object[index] ) );
			}

			return array;
		}
		else if ( __isObject( object ) )
		{
			if ( object instanceof BoxedObject )
			{
			//	return object._object;
				return { '__obj__' : object._object };
			}
			else if ( object instanceof BoxedClass )
			{
			//	return object._class;
				return { '__obj__' : object._class };
			}
			else
			{
				if ( object['__nil__'] )
				{
					return null;
				}
				else if ( object['__obj__'] )
				{
					return object['__obj__'];
				}
				else
				{
					var dictionary = {};

					for ( var key in object )
					{
						dictionary[key] = __unboxObject( object[key] );
					}

					return dictionary;
				}
			}
		}
		else
		{
			return object;
		}
	};

	function BoxedObject( object, className )
	{
		this._props = null;
		this._object = object;
		this._className = className;

		Object.defineProperty( this, 'props',
		{
			get : function()
			{
				if ( null == this._props )
				{
					this._props = __OC__getVariable( this._object, '__props__' );

					if ( __isNone( this._props ) )
					{
						this._props = {};

						var classInfo = global.importedClasses[this._className];

						if ( false == __isNone( classInfo ) )
						{
							var defaultValues = classInfo.instanceProps;

							for ( var key in defaultValues )
							{
								this._props[key] = defaultValues[key];
							}
						}

						__OC__setVariable( this._object, '__props__', this._props );
					}
				}

				return this._props;
			},
			set : function( newValue )
			{
				__OC__assert( false, 'Cannot modify .props' );
			}
		});
	};

	BoxedObject.prototype.invoke = function( methodName, methodArgs )
	{
//		if ( arguments.length == 0 )
//			return null;

		if ( __isNone( this._object ) )
			return null;

		var classInfo = global.importedClasses[this._className];
		if ( false == __isNone( classInfo ) )
		{
			var methodFunction = classInfo.instanceMethods[methodName];
			if ( false == __isNone( methodFunction ) )
			{
				var _self = global.self;
 
				global.self = this;
 
				var returnValue = methodFunction.apply( this, methodArgs );
 
				global.self = _self;
 
				return returnValue;
			}
		}

		var unboxedArgs = __isNone( methodArgs ) ? [] : __unboxObject( methodArgs );
		var returnValue = __OC__invokeMethod( this._object, methodName, unboxedArgs );
		if ( __isNone( returnValue ) )
			return null;

		return __boxObject( returnValue );
	};

	BoxedObject.prototype.retain = function()
	{
		__OC__retain( this._object );
	}

	BoxedObject.prototype.release = function()
	{
		__OC__release( this._object );
	}

	function BoxedClass( object, className )
	{
		this._class = object;
		this._className = className;
	};

	BoxedClass.prototype.invoke = function( methodName, methodArgs )
	{
//		if ( arguments.length == 0 )
//			return null;

		if ( __isNone( this._class ) )
			return null;

		var unboxedArgs = __isNone( methodArgs ) ? [] : __unboxObject( methodArgs );
		var returnValue = __OC__invokeMethod( this._class, methodName, unboxedArgs );
		if ( __isNone( returnValue ) )
			return null;

		return __boxObject( returnValue );
	};

	global.requireClass = function( className )
	{
		var classInfo = global.importedClasses[className];

		if ( __isNone( classInfo ) )
		{
			var nativeClass = __OC__getClass( className );
			if ( __isNone( nativeClass ) )
				return null;

			var classObject = new BoxedClass( nativeClass, className );
			if ( __isNone( classObject ) )
				return null;

			global.importedClasses[className] =
			{
				className: 			className,
				classObject: 		classObject,
				instanceProps: 		{},
				instanceMethods: 	{},
				methodForwards: 	{}
			};

			global[className] = classObject;

			return classObject;
		}
		else
		{
			return classInfo.classObject;
		}
	};

	global.defineClass = function( className, superClassName, protocols, instanceProps, instanceMethods )
	{
		if ( false == __isNone( global[className] ) )
		{
			console.log( "'global." + className + "' already exists" );
			return null;
		}

		var classInfo = global.importedClasses[className];

		if ( __isNone( classObject ) )
		{
            var methodNames = [];
            var methodForwards = {};

            for ( var methodName in instanceMethods )
            {
            	if ( methodName.slice(0,1) === "@" )
            	{
            		var signalParts = methodName.slice( 1, methodName.length );
            		var signalMethod = 'handleSignal____' + signalParts.split( '.' ).join( '____' ) + ':';

            		methodForwards[signalMethod] = methodName;
            		methodNames.push( signalMethod );
            	}
            	else
            	{
                	methodNames.push( methodName );
            	}
            }

			var nativeClass = __OC__createClass( className, superClassName, protocols, methodNames );
			if ( __isNone( nativeClass ) )
				return null;

			var classObject = new BoxedClass( nativeClass, className );
			if ( __isNone( classObject ) )
				return null;

			global.importedClasses[className] =
			{
				className: 			className,
				classObject: 		classObject,
				instanceProps: 		instanceProps,
				instanceMethods: 	instanceMethods,
				methodForwards: 	methodForwards
			};

			global[className] = classObject;

			return classObject;
		}
		else
		{
			return classInfo.classObject;
		}
	};

	global.runtimeClassCallback = function( className, method, object, args )
	{
		var classInfo = global.importedClasses[className];
		if ( __isNone( classInfo ) )
		{
			console.log( "Class '" + className + "' not found" );
			return null;
		}

		var methodForward = classInfo.methodForwards[method];
		if ( methodForward )
		{
			method = methodForward;
		}

		var methodFunction = classInfo.instanceMethods[method];
		if ( __isNone( methodFunction ) )
		{
			console.log( "Method '" + method + "' not found" );
			return null;
		}

		var boxedThis = __boxObject( object );
		var boxedArgs = __boxObject( args );

		var _self = global.self;
 
		global.self = boxedThis;
 
		var returnValue = methodFunction.apply( boxedThis, boxedArgs );
 
		global.self = _self;
 
		if ( __isNone( returnValue ) )
			return null;

		return __unboxObject( returnValue );
	};

	global.runtimeFunctionCallback = function( func, args )
	{
		var boxedThis = null;
		var boxedArgs = __boxObject( args );

		var returnValue = func.apply( boxedThis, boxedArgs );
		if ( __isNone( returnValue ) )
			return null;

		return __unboxObject( returnValue );
	};
	
	global.include = function( path )
	{
		if ( !global.includedFiles[path] )
		{
			global.includedFiles[path] = __OC__include( path );
		}

		return global.includedFiles[path];
	};
 
	global.require = function()
	{
		if ( arguments.length == 0 )
			return;

		for ( var i = 0; i < arguments.length; ++i )
		{
			global.requireClass( arguments[i] );
		}
	};

	global.assert = function( expr, text )
	{
		__OC__assert( expr, text );
	};

	global.console = {};
	global.console.log = function( text )
	{
		__OC__log( text );
	}

})( global );
