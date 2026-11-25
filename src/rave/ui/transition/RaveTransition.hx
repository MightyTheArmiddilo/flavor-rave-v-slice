package rave.ui.transition;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import funkin.ui.transition.loading.ThrobberLoadingState;
import funkin.ui.transition.progress.FunkinProgressBar;

class RaveTransition extends ThrobberLoadingState
{
	public function new(target:TransitionTarget, params:TransitionParams)
	{
		super(target, params, {
			delay: 0,
		});
	}

	var loadingText:FlxText;

	override public function buildDisplay()
	{
		super.buildDisplay();

		loadingText = new FlxText(0, 0, 0, 'Bopeebo', 38);
		loadingText.font = funkin.assets.Paths.font('ui/fonts/FunkinOptions', 'otf');
		loadingText.color = FlxColor.WHITE;
		loadingText.cameras = [throbberCamera];
		add(loadingText);

		loadingText.x = 16;
		loadingText.y = FlxG.height - loadingText.size - 16;
	}

	override function startAssetLoading()
	{
		FlxTimer.wait((RaveGlobal.isDebugMode) ? throbberParams.delay : 0, () ->
		{
			super.startAssetLoading();
		});
		// trace('do nothing cause I am an asshole');
	}

	override public function onProgress(a:Int, b:Int):Void
	{
		super.onProgress(a, b);
		updateText();
	}

	override public function onError(a:Any):Void
	{
		super.onError(a);
		updateText();
	}

	override public function onFullyComplete():Void
	{
		currentProgress = 100;
		updateText();

		super.onFullyComplete();
	}

	public function updateText()
	{
		if (loadingText != null) loadingText.text = '${FlxMath.roundDecimal(currentProgress * 100, 2)}% Complete';
	}
}
