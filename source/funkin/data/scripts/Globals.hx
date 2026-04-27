package funkin.data.scripts;

import funkin.states.*;
import funkin.states.substates.*;
import openfl.display.BlendMode;
import Type.ValueType;

using StringTools;

class Globals
{
	public static var Function_Stop:Dynamic = 1;
	public static var Function_Continue:Dynamic = 0;
	public static var Function_Halt:Dynamic = 2;

	public static inline function getInstance():flixel.FlxState
	{
		return PlayState.instance.isDead ? GameOverSubstate.instance : PlayState.instance;
	}

	public static function setVarInArray(instance:Dynamic, variable:String, value:Dynamic):Any
	{
		var shit:Array<String> = variable.split('[');
		if (shit.length > 1)
		{
			var blah:Dynamic = Reflect.getProperty(instance, shit[0]);
			for (i in 1...shit.length)
			{
				var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
				if (i >= shit.length - 1) // Last array
					blah[leNum] = value;
				else // Anything else
					blah = blah[leNum];
			}
			return blah;
		}
		/*if(Std.isOfType(instance, Map))
				instance.set(variable,value);
			else */
		switch (Type.typeof(instance))
		{
			case ValueType.TClass(haxe.ds.StringMap) | ValueType.TClass(haxe.ds.ObjectMap) | ValueType.TClass(haxe.ds.IntMap) | ValueType.TClass(haxe.ds.EnumValueMap):
				instance.set(variable, value);
			default:
				Reflect.setProperty(instance, variable, value);
		};
		
		return true;
	}
	
	public static function getVarInArray(instance:Dynamic, variable:String):Any
	{
		var shit:Array<String> = variable.split('[');
		if (shit.length > 1)
		{
			var blah:Dynamic = Reflect.getProperty(instance, shit[0]);
			for (i in 1...shit.length)
			{
				var leNum:Dynamic = shit[i].substr(0, shit[i].length - 1);
				blah = blah[leNum];
			}
			return blah;
		}
		switch (Type.typeof(instance))
		{
			case ValueType.TClass(haxe.ds.StringMap) | ValueType.TClass(haxe.ds.ObjectMap) | ValueType.TClass(haxe.ds.IntMap) | ValueType.TClass(haxe.ds.EnumValueMap):
				return instance.get(variable);
			default:
				return Reflect.getProperty(instance, variable);
		};
	}
	
	// Better optimized than using some getProperty shit or idk
	public static function getFlxEaseByString(?ease:String = '')
	{
		switch (ease.toLowerCase().trim())
		{
			case 'backin':
				return FlxEase.backIn;
			case 'backinout':
				return FlxEase.backInOut;
			case 'backout':
				return FlxEase.backOut;
			case 'bouncein':
				return FlxEase.bounceIn;
			case 'bounceinout':
				return FlxEase.bounceInOut;
			case 'bounceout':
				return FlxEase.bounceOut;
			case 'circin':
				return FlxEase.circIn;
			case 'circinout':
				return FlxEase.circInOut;
			case 'circout':
				return FlxEase.circOut;
			case 'cubein':
				return FlxEase.cubeIn;
			case 'cubeinout':
				return FlxEase.cubeInOut;
			case 'cubeout':
				return FlxEase.cubeOut;
			case 'elasticin':
				return FlxEase.elasticIn;
			case 'elasticinout':
				return FlxEase.elasticInOut;
			case 'elasticout':
				return FlxEase.elasticOut;
			case 'expoin':
				return FlxEase.expoIn;
			case 'expoinout':
				return FlxEase.expoInOut;
			case 'expoout':
				return FlxEase.expoOut;
			case 'quadin':
				return FlxEase.quadIn;
			case 'quadinout':
				return FlxEase.quadInOut;
			case 'quadout':
				return FlxEase.quadOut;
			case 'quartin':
				return FlxEase.quartIn;
			case 'quartinout':
				return FlxEase.quartInOut;
			case 'quartout':
				return FlxEase.quartOut;
			case 'quintin':
				return FlxEase.quintIn;
			case 'quintinout':
				return FlxEase.quintInOut;
			case 'quintout':
				return FlxEase.quintOut;
			case 'sinein':
				return FlxEase.sineIn;
			case 'sineinout':
				return FlxEase.sineInOut;
			case 'sineout':
				return FlxEase.sineOut;
			case 'smoothstepin':
				return FlxEase.smoothStepIn;
			case 'smoothstepinout':
				return FlxEase.smoothStepInOut;
			case 'smoothstepout':
				return FlxEase.smoothStepInOut;
			case 'smootherstepin':
				return FlxEase.smootherStepIn;
			case 'smootherstepinout':
				return FlxEase.smootherStepInOut;
			case 'smootherstepout':
				return FlxEase.smootherStepOut;
		}
		return FlxEase.linear;
	}
	
	public static function blendModeFromString(blend:String):BlendMode
	{
		switch (blend.toLowerCase().trim())
		{
			case 'add':
				return ADD;
			case 'alpha':
				return ALPHA;
			case 'darken':
				return DARKEN;
			case 'difference':
				return DIFFERENCE;
			case 'erase':
				return ERASE;
			case 'hardlight':
				return HARDLIGHT;
			case 'invert':
				return INVERT;
			case 'layer':
				return LAYER;
			case 'lighten':
				return LIGHTEN;
			case 'multiply':
				return MULTIPLY;
			case 'overlay':
				return OVERLAY;
			case 'screen':
				return SCREEN;
			case 'shader':
				return SHADER;
			case 'subtract':
				return SUBTRACT;
		}
		return NORMAL;
	}
	
	public static function getPropertyLoopThingWhatever(killMe:Array<String>, ?checkForTextsToo:Bool = true, ?getProperty:Bool = true):Dynamic
	{
		var coverMeInPiss:Dynamic = getObjectDirectly(killMe[0], checkForTextsToo);
		var end = killMe.length;
		if (getProperty) end = killMe.length - 1;
		
		for (i in 1...end)
		{
			coverMeInPiss = getVarInArray(coverMeInPiss, killMe[i]);
		}
		return coverMeInPiss;
	}
	
	public static function getObjectDirectly(objectName:String, ?checkForTextsToo:Bool = true):Dynamic
	{
		var coverMeInPiss:Dynamic = PlayState.instance.getLuaObject(objectName, checkForTextsToo);
		if (coverMeInPiss == null) coverMeInPiss = getVarInArray(Globals.getInstance(), objectName);
		
		return coverMeInPiss;
	}
}
