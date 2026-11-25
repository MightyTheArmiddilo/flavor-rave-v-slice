package rave;

import funkin.ui.quickpanel.PanelEntry;
import funkin.ui.transition.FadeType;
import funkin.ui.transition.Transition;
import funkin.ui.transition.Transition.TransitionType;
import funkin.ui.quickpanel.QuickPanelState;
import funkin.ui.quickpanel.PanelActions;
import rave.ui.transition.RaveTransition;
import rave.ui.main.RaveMainState;

class FlavorRavePanelEntry extends PanelEntry
{
	public function new()
	{
		super('flavorrave');
	}

	override public function onAccept():Void
	{
		QuickPanelState.stopMusic();
		Transition.switchState(() -> new RaveMainState(), // at some point change this to title state
			{
				assetQuery: RaveMainState.queryAssets,
				priorityAssetQuery: RaveMainState.queryPriorityAssets,
				transition: TransitionType.Custom('rave.ui.transition.RaveTransition', FadeType.Fade("North"), FadeType.Fade("South"))
			});
	}
}
