package;

#if !macro
// flixel
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;

#if DISCORD_ALLOWED
import funkin.api.DiscordClient;
#end

import Init;
import funkin.Paths;
import funkin.data.ClientPrefs;
import funkin.data.Conductor;
import funkin.utils.CoolUtil;
import funkin.data.Highscore;
import funkin.states.*;
import funkin.backend.MusicBeatState;

using StringTools;
#end
