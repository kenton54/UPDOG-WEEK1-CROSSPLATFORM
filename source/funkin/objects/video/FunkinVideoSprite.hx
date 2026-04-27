package funkin.objects.video;

import flixel.util.FlxSignal;

#if html5
import funkin.backend.HTML5Video as VideoHandler;
#else
import hxvlc.util.Location;
import hxvlc.flixel.FlxVideoSprite as VideoHandler;
#end

// a little funky but thats what happens when u gotta do weird workarounds
// probably will do more iwth this later

//by data 5 for 17buckys 
//still a wip version of it tho but its better than the other ones so

/**
 * Handles video playback as a `FlxSprite`. Has additional features for ease
 * 
 * If used in `PlayState`, will autopause when the game is paused too
 * 
 * General Usage:
 * ```haxe
 * 	var video = new FunkinVideoSprite(x,y).preload(videoPath, [FunkinVideoSprite.MUTED])
 * 	add(video);
 * 	video.onReady.addOnce(()->{
 * 		video.setGraphicSize(0,FlxG.height);
 * 		video.updateHitbox();
 * 		video.screenCenter(FlxAxes.X);
 * 
 * 	});
 *	video.playVideo();

 * ```
 */
class FunkinVideoSprite extends VideoHandler
{
	public static function init()
	{
		#if hxvlc
		hxvlc.util.Handle.init(['--no-lua']);
		#end
	}
	
	public static var _videos:Array<FunkinVideoSprite> = [];
	
	/**
	 * Loading option that makes the video loop
	 */
	public static final LOOPING:String = ':input-repeat=65535';
	
	/**
	 * Loading option that mutes the video.
	 * 
	 * Use if video audio is not required.
	 */
	public static final MUTED:String = ':no-audio';
	
	/**
	 * Dispatched when the video ends.
	 * 
	 * wrapper for `bitmap.onEndReached`
	 */
	public final onFinish:FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched when the videos internal bitmap is ready.
	 * 
	 * 
	 * wrapper for `bitmap.onFormatSetup`
	 */
	public final onReady:FlxSignal = new FlxSignal();
	
	/**
	 * Dispatched when the video starts.
	 * 
	 * wrapper for `bitmap.onOpening`
	 */
	public final onStart:FlxSignal = new FlxSignal();
	
	private var wasPlaying:Bool = false;
	
	/**
	 * @param destroyOnFinish if true, will destroy itself on finish.
	 */
	public function new(x:Float = 0, y:Float = 0, destroyOnFinish:Bool = true)
	{
		super(x, y);

		if (bitmap != null)
		{
			bitmap.onFormatSetup.add(onReady.dispatch);
			bitmap.onEndReached.add(onFinish.dispatch);

			bitmap.onOpening.add(() ->
			{
				if (!_preloaded)
					onStart.dispatch(); // being real another option that is less hacky is all together ignore onStart and just do ur stuff when u call play
			});

			if (destroyOnFinish)
				bitmap.onEndReached.add(this.destroy);
		}
		_videos.push(this);
	}

	public function preload(path:String, ?options:Array<String>):FunkinVideoSprite
	{
		// if u didnt use path try to find the path and the extension
		var stringPath:String = path;
		if (!stringPath.endsWith('.mp4') && !stringPath.endsWith('.mov'))
		{
			var found = false;
			for (ext in ['mp4', 'mov'])
			{
				final fullPath = 'assets/videos/$stringPath.$ext'; 
				if (Paths.fileExists(fullPath)) {
					stringPath = fullPath;
					found = true;
					break;
				}
			}

			if (found)
				path = stringPath;
		}

		// essentially this is a workaround for hxvlc's inconsistent video playback
		// sometimes its delayed and sometimes loading,playing,stopping to try to preload causes openfl texture corruption garbage
		if (load(path, options))
		{
			_preloaded = true; // im going to play a risk and assume the video does infact play
			
			if (play())
			{
				pause();
				visible = false;
				if (bitmap != null)
					bitmap.time = 0;
			}
		}

		return this;
	}

	/**
	 * Use over `play()`.
	 */
	public function playVideo():Void
	{
		FlxTimer.wait(0, _preloaded ? _preloadPlay : play);
	}

	private var _preloaded:Bool = false;

	function _preloadPlay()
	{
		visible = true;
		resume();
		_preloaded = false;
		onStart.dispatch();
	}

	override function destroy()
	{
		if (bitmap != null)
		{
			bitmap.onEndReached.removeAll();
			bitmap.onFormatSetup.removeAll();
		}
		
		onReady.removeAll();
		onReady.destroy();
		
		onFinish.removeAll();
		onFinish.destroy();
		
		onStart.removeAll();
		onStart.destroy();
		
		_videos.remove(this);
		
		super.destroy();
	}
}
