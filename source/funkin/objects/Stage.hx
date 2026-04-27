package funkin.objects;

import openfl.utils.Assets;
import flixel.FlxBasic;
import flixel.group.FlxGroup.FlxTypedGroup;
import funkin.data.scripts.*;
import funkin.data.StageData;

#if MODS_ALLOWED
import sys.FileSystem;
import sys.io.File;
#end

using StringTools;

class Stage extends FlxTypedGroup<FlxBasic>
{
	public var curStageScript:FunkinScript;

	public var curStage = "stage";
	public var stageData:StageFile = funkin.data.StageData.generateDefault();

	public function new(stageName:String = "stage")
	{
		super();

		curStage = stageName;

		var newStageData = StageData.getStageFile(curStage);
		if (newStageData != null) stageData = newStageData;
	}

	function setupScript(s:FunkinScript)
	{
		curStageScript = s;

		switch (s.scriptType)
		{
			case HSCRIPT:
				s.set("add", add);
				s.set("stage", this);
				s.call("onLoad");

			#if LUA_ALLOWED
			case LUA:
				s.call("onCreate", []);
			#end
		}
	}

	public function buildStage()
	{
		final baseScriptFile:String = 'stages/' + curStage;

		var scriptFile = FunkinIris.getPath(baseScriptFile);
		#if MODS_ALLOWED
		if (FileSystem.exists(scriptFile))
		{
			trace('FUCKL');
			var script = FunkinIris.fromFile(scriptFile);
			setupScript(script);
		}
		else
		#end
		if (Assets.exists(scriptFile))
		{
			var script = FunkinIris.fromString(Assets.getText(scriptFile));
			setupScript(script);
		}
		#if LUA_ALLOWED
		else if (Paths.fileExists('$baseScriptFile.lua', TEXT))
		{
			var script = new FunkinLua('$baseScriptFile.lua');
			setupScript(script);
		}
		#end
	}
}
