package rave.util;

import funkin.ui.transition.Transition;
import funkin.ui.transition.Transition.TransitionType;
import funkin.ui.transition.loading.LoadingState;
import funkin.ui.transition.loading.ThrobberLoadingState;
import flixel.util.typeLimit.NextState;

class CustomTransitionUtil
{
	public static function switchState(targetState:NextState, params:TransitionParams, ?loadingState:LoadingState)
	{
		if (Transition.isTransitionActive())
		{
			@:privateAccess
			if (Transition.pendingReplacement)
			{
				trace('[TRANSITION] Ignoring duplicate state transition request while a replacement is pending.');
				return;
			}

			@:privateAccess
			pendingReplacement = true;

			trace('[TRANSITION] Replacing the active transition with a new state transition.');

			@:privateAccess
			Transition.cancelActiveTransition();

			new FlxTimer().start(0, (_) ->
			{
				@:privateAccess
				pendingReplacement = false;

				switchState(targetState, params);
			});
			return;
		}

		params = Transition.validateParams(params);

		if (params.transition != TransitionType.Custom)
		{
			Transition.switchState(targetState, params);
			return;
		}

		if (loadingState == null) loadingState = new ThrobberLoadingState();

		var onTransOutDone:Void->Void = () ->
		{
			FlxStateUtil.openSubStateAtTop(loadingState);
		};

		@:privateAccess
		Transition.prepareFadeOut(fadeOut);

		@:privateAccess
		Transition.prepareFadeIn(fadeIn, onTransOutDone);
	}
}
