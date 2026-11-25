package rave;

import funkin.ui.quickpanel.PanelEntry;
import funkin.ui.transition.FadeType;
import funkin.ui.transition.Transition;
import funkin.ui.transition.Transition.TransitionType;
import funkin.ui.quickpanel.QuickPanelState;
import funkin.ui.quickpanel.PanelActions;

class FlavorRavePanelEntry extends PanelEntry
{
  public function new()
  {
    super('flavorrave');
  }

  override public function onAccept():Void
  {
    QuickPanelState.stopMusic();
    Transition.switchState(() -> new rave.ui.main.RaveMainState(), // at some point change this to title state
      {
        assetQuery: rave.ui.main.RaveMainState.queryAssets,
        transition: TransitionType.Custom('RaveTransition', FadeType.Fade("North"), FadeType.Fade("South"))
      });
  }
}
