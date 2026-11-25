package rave.ui.transition;

import flixel.text.FlxText;
import funkin.ui.transition.loading.ThrobberLoadingState;
import funkin.ui.transition.progress.FunkinProgressBar;

class RaveTransition extends ThrobberLoadingState
{
	public function new(target:TransitionTarget, params:TransitionParams)
	{
		super(target, params, {
			transparent: false,
			delay: 1
		});
	}

	var progressBar:FunkinProgressBar;
	var loadingText:FlxText;

	override public function create()
	{
		super.create();

		progressBar = new FunkinProgressBar();
		progressBar.build();
		progressBar.cameras = [throbberCamera];
		add(progressBar);
        progressBar.y = FlxG.height - progressBar.height;

		loadingText = new FlxText(0, 0, 0, 'Bopeebo');
		loadingText.setFormat(funkin.assets.Paths.font('ui/fonts/FunkinOptions', 'otf'), 38, 0xFFFFFFFF, 'left');
		add(loadingText);

        loadingText.x = loadingText.size;
		loadingText.y = progressBar.y - loadingText.height - loadingText.size;
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		progressBar.updateProgress(Std.int(this.currentProgress * 10), 10);
	}
}
