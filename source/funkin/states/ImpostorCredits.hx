package funkin.states;

#if VIDEOS_ALLOWED
import funkin.objects.video.FunkinVideoSprite;
#end

class ImpostorCredits extends MusicBeatState
{
	var infry:FlxSprite;

	#if VIDEOS_ALLOWED
	var video = new FunkinVideoSprite();
	#end
	
	override function create()
	{
		super.create();

		#if VIDEOS_ALLOWED
		add(video);
		video.load(Paths.video('VS_IMPOSTOR_WEEK_2'));
		video.onReady.add(() -> {
			video.setGraphicSize(FlxG.width);
			video.updateHitbox();
		});
		// video.playVideo();

		video.onFinish.addOnce(exit);

		infry = new FlxSprite().loadFromSheet('menu/credits/hi', 'hi', 24);
		infry.animation.curAnim.looped = false;
		infry.animation.pause();
		add(infry);
		infry.x = FlxG.width - infry.width;
		infry.y = FlxG.height;
		infry.animation.onFinish.add((anim) -> {
			FlxTween.tween(infry, {y: FlxG.height}, 1);
		});

		var ct = new FlxSprite(42.15, 668.3).loadGraphic(Paths.image('menu/common/controls_cutscene'));
		add(ct);

		FlxTimer.wait(1, () -> {
			video.playVideo();
		});
		#else
		exit();
		#end
	}

	var skipped = false;

	var holdTime = 0.0;

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		#if VIDEOS_ALLOWED
		// if (FlxG.keys.pressed.ENTER) holdTime += elapsed;
		// else holdTime = 0;
		
		holdTime += elapsed;
		
		if (holdTime > 20)
		{
			holdTime = -111111;
			infry.animation.resume();
			
			FlxTween.tween(infry, {y: FlxG.height - infry.height + 20}, 0.3);
		}
		
		if (FlxG.keys.justPressed.ENTER && !skipped)
		{
			exit();
		}
		#end
	}
	
	function exit()
	{
		skipped = true;
		
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		FlxG.sound.music.volume = 1;
		
		FlxG.switchState(() -> new TitleState());
	}
}
