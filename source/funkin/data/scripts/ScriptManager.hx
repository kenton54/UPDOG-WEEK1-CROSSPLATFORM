package funkin.data.scripts;

class ScriptManager extends flixel.FlxBasic
{
	public static var instance:ScriptManager;

	public function new()
	{
		super();
		this.visible = false;

		// instance = this;
	}
}
