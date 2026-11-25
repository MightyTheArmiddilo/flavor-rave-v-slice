package rave.ui.transition;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.util.FlxTimer;
import flixel.math.FlxMath;
import funkin.ui.transition.loading.ThrobberLoadingState;
import funkin.ui.transition.progress.FunkinProgressBar;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import funkin.assets.Assets;
import funkin.assets.FunkinAssetCache;
import lime.app.Future;
import openfl.media.Sound;
import lime.app.Promises;

import rave.util.RaveAssetUtil;

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
		updateText();

		super.onFullyComplete();
	}

	public function updateText()
	{
		// if (loadingText != null) loadingText.text = '${FlxMath.roundDecimal(currentProgress * 100, 2)}% Complete';
	}

	override function loadGraphics():Void
	{
		if (transitionCancelled) return;
		trace('[LOADING] Loading graphics...');

		// Get the list of assets needed for this state,
		// plus the assets that should always stay loaded across states.
		var graphicsToLoad:Array<AssetPath> = params.assetQuery == null ? [] : params.assetQuery('IMAGE');
		if (graphicsToLoad.length == 0)
		{
			// Nothing to load!
			loadingStagesDone += 1;
			loadSounds();
			return;
		}

		// trace('[LOADING] Created promise to cache ${graphicsToLoad.length} total graphics.')
		var future:Future<Array<Future<String>>> = RaveAssetUtil.cacheAllFlxGraphics(graphicsToLoad);

		future.onProgress(this.onProgress);
		future.onError(this.onError);
		future.onComplete((loadedGraphics:Array<Future<String>>) ->
		{
			if (transitionCancelled) return;
			// trace('[LOADING] Finished loading graphics, counting results...')
			var success:Int = 0;
			var error:Int = 0;
			for (loadedGraphic in loadedGraphics)
			{
				if (loadedGraphic.isError)
				{
					trace('[LOADING] Error loading graphic: ${loadedGraphic.error}');
					error++;
				}
				else if (!loadedGraphic.isComplete)
				{
					trace('HUH? Asset loading is not complete...');
				}
				else
				{
					success++;
				}

				trace(loadedGraphic.value);
			}

			trace('[LOADING] Finished loading ${success}/${success + error} graphics.');

			loadingStagesDone += 1;
			loadSounds();
		});
	}
}
