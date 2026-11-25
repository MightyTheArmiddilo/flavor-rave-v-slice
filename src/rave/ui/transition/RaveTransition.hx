package rave.ui.transition;

import funkin.ui.transition.loading.ThrobberLoadingState;

class RaveTransition extends ThrobberLoadingState
{
	public function new(target:TransitionTarget, params:TransitionParams)
	{
		super(target, params, {
            transparent: false,
            delay: 0
        });
	}
}
