package rave;

import funkin.modding.module.Module;

class RaveGlobal extends Module
{
	public static var isDebugMode:Bool = false;

	override public function new()
	{
		super('RaveGlobal');
	}

    public function onCreate()
    {
        isDebugMode = funkin.util.FileUtil.directoryExists('mods/flavor-rave-v-slice/.git');
    }
}
