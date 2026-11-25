package rave;

import funkin.modding.module.Module;

class RaveGlobal extends Module
{
	public static var isDebugMode(default, null):Bool = false;

	override public function new()
	{
		super('RaveGlobal');
	}

    public function create()
    {
        isDebugMode = funkin.util.FileUtil.directoryExists('mods/flavor-rave-v-slice/.git');
    }
}
