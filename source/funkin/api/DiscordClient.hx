package funkin.api;

#if DISCORD_ALLOWED
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import sys.thread.Thread;

#if LUA_ALLOWED
import llua.Lua;
import llua.State;
#end

class DiscordClient
{
	public static final clientID:String = '1276234319852994754';

	public static var discordPresences:Array<String> = [
		'Pegging Aren\'t I funny',
		'Pegging Aren\'t I funny 2',
		'The Green Peg from Peggle Song',
		'VS The Orange One',
		'B\'jornin\'',
		'Tickle Party (Freeplay)',
		'Finale (2026 remaster)',
		'Top 5',
		'Impostor Incident',
		'Trolla Baby',
		'Oversight',
		'Dripcore',
		'Monotone Attack 2: "That\'s Right You Have To Play Another Inside Joke Song To 100% The Mod"',
		'Legacy Moogus',
		'Overworld - HP: 400 - Mana: 200',
		'the guy from esculent\'s funeral',
		'DAREDEVIL',
		'Too-Slow',
		'Red vs. Afton',
		'Daddy Queerest',
		'Mongy Monday',
		'Tomongus Tuesday',
		'White Boy Wednesday',
		'Tomongus Tuesday 2: Thursday',
		'TERRARIA IS A BETTER GAME THAN PALWORLD IF YOU\'RE READING THIS AND DISAGREE FUCK YOU',
		'Boing Resussed',
		'Aaaaaaaand it\'s inappropriate',
		'Hopefully a good song',
		'Probably one of the bad songs',
		'Another song with that pizzicato voice. Great.'
	];

	public static var isInitialized(default, null):Bool = false;

	public static function initialize()
	{
		trace("[DISCORD] Discord Client starting...");

		var handlers:DiscordEventHandlers = new DiscordEventHandlers();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);

		Discord.Initialize(clientID, cpp.RawPointer.addressOf(handlers), true, null);
		Thread.create(discordRPCUpdate);

		isInitialized = true;
		trace("[DISCORD] Discord Client started.");
	}

	static function discordRPCUpdate()
	{
		while (true)
		{
			#if DISCORD_DISABLE_IO_THREAD
			Discord.UpdateConnection();
			#end

			Discord.RunCallbacks();
			Sys.sleep(2);
		}
	}

	public static function shutdown()
	{
		Discord.Shutdown();
	}

	public static function clearPresence()
	{
		Discord.ClearPresence();
	}

	static function onReady(request:cpp.RawConstPointer<DiscordUser>)
	{
		changePresence("mod");
	}

	static function onError(code:Int, message:cpp.ConstCharStar)
	{
		trace('[DISCORD] Error! $code : ${cast (message, String)}');
	}

	static function onDisconnected(code:Int, message:cpp.ConstCharStar)
	{
		trace('[DISCORD] Disconnected! $code : ${cast (message, String)}');
	}

	public static function changePresence(details:String, ?state:String, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float)
	{
		var startTimestamp:Float = hasStartTimestamp ? Date.now().getTime() : 0;

		if (endTimestamp > 0)
		{
			endTimestamp = startTimestamp + endTimestamp;
		}

		var presence:DiscordRichPresence = new DiscordRichPresence();

		presence.details = details;
		presence.state = state ?? '';

		presence.type = DiscordActivityType.DiscordActivityType_Playing;

		presence.smallImageKey = smallImageKey;
		presence.largeImageKey = 'icon';
		presence.largeImageText = 'Engine Version: ${Main.NM_VERSION}';

		presence.startTimestamp = Std.int(startTimestamp / 1000);
		presence.endTimestamp = Std.int(endTimestamp / 1000);

		Discord.UpdatePresence(cpp.RawConstPointer.addressOf(presence));

		// trace('Discord RPC Updated. Arguments: $details, $state, $smallImageKey, $hasStartTimestamp, $endTimestamp');
	}

	#if LUA_ALLOWED
	public static function addLuaCallbacks(lua:State)
	{
		Lua_helper.add_callback(lua, "changePresence", function(details:String, state:Null<String>, ?smallImageKey:String, ?hasStartTimestamp:Bool, ?endTimestamp:Float) {
			changePresence(details, state, smallImageKey, hasStartTimestamp, endTimestamp);
		});
	}
	#end
}
#end
