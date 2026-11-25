package rave.util;

import funkin.assets.Assets;
import funkin.assets.Path.AssetPath;
import funkin.assets.FunkinAssetCache;
import lime.app.Future;
import openfl.media.Sound;
import lime.app.Promises;

class RaveAssetUtil
{
	public static function cacheAllFlxGraphics(assetPaths:Array<AssetPath>, permanent:Bool = false):Future<Array<Future<String>>>
	{
		// Exclude null values, and ensure each path is only loaded once.
		var tempAssetPaths = (assetPaths ?? []);
		assetPaths = [];

		for (a in tempAssetPaths) if (a == null || tempAssetPaths.filter(b -> return b == a).length > 1) tempAssetPaths.remove(a);

        trace(assetPaths = tempAssetPaths);

		if (assetPaths.length == 0) return Future.withValue([]);

		var futures:Array<Future<String>> = [];

		for (assetPath in assetPaths) futures.push(cacheFlxGraphic(assetPath, permanent));

		return Promises.allSettled(futures);
	}

	public static function cacheFlxGraphic(assetPath:AssetPath, permanent:Bool = false):Future<String>
	{
		if (assetPath == null) throw 'Input is not a valid AssetPath, did you call Paths.image()?';

		return FunkinAssetCache.instance.cacheFlxGraphic(assetPath, permanent) ? assetPath : null;
	}
}
