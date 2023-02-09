package;

import openfl.utils.Assets;
import flixel.system.FlxSound;
import openfl.display.Sprite;
import openfl.Lib;
import openfl.events.Event;
import flixel.FlxG;
import openfl.display.MovieClip;

class SwfVideo extends Sprite
{
    public var finishCallback:Void->Void = null;

    public var clip:MovieClip;

    private var barLeft:Sprite;
    private var barRight:Sprite;

    public function new():Void
    {
        super();
    }
	
    // I'm sure I'll figure it out.
    public function playMovie(movieClip:String, sound:String, onComplete:Void->Void):Void
    {
        barLeft = new Sprite();
        barRight = new Sprite();

        var audio:FlxSound = new FlxSound().loadEmbedded(sound);
        Assets.loadLibrary('$movieClip').onComplete(function(_) {
            clip = Assets.getMovieClip('$movieClip:');
            addChild(clip);

            addChild(barLeft);
            addChild(barRight);
            
            audio.onComplete = function() {
                onComplete();
                removeChild(clip);
                (cast (Lib.current.getChildAt(0), Main)).removeChild(this);
            };

            if (audio != null)
                audio.play();
        });

        (cast (Lib.current.getChildAt(0), Main)).addChild(this);

        addEventListener(Event.ENTER_FRAME, onResize);
    }

    /**
     *  Partly Copied from FlxGame
     */
    function onResize(_):Void
    {
        var width:Int = FlxG.stage.stageWidth;
		var height:Int = FlxG.stage.stageHeight;

        width > height ? 
            clip.scaleX = clip.scaleY = height / 720
            : clip.scaleY = clip.scaleX = width / 1280;

        screenCenter();

        // trace('RESIZED TO ${clip.scaleX}%');
    }

    public function screenCenter()
    {
        var ratio:Float = FlxG.width / FlxG.height;
		var realRatio:Float = FlxG.stage.stageWidth / FlxG.stage.stageHeight;
        var preX:Float = 0;

        preX = Math.floor(FlxG.stage.stageHeight * ratio);

		clip.x = Math.ceil((FlxG.stage.stageWidth - preX) * 0.5);

        barLeft.graphics.clear();
        barRight.graphics.clear();
        barLeft.graphics.beginFill();
        barRight.graphics.beginFill();
        barLeft.graphics.drawRect(0, 0, clip.x, FlxG.stage.stageHeight);
        barRight.graphics.drawRect(FlxG.stage.stageWidth - clip.x, 0, clip.x, FlxG.stage.stageHeight);
    }
}
