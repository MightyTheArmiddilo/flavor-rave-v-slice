package rave.ui.main;

import funkin.ui.MusicBeatState;
import funkin.assets.Assets;
import funkin.assets.Paths;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import rave.util.CoolUtil;
import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import funkin.util.InputUtil;
import funkin.group.FunkinGroup;

class RaveMainState extends MusicBeatState
{
	public static function queryAssets(type)
	{
		var ext:String = null;

		switch (type)
		{
			case 'IMAGE':
				ext = '.png';
			default:
		}

		if (ext == null) return [];

		var paths = [
			'ui/rave/main-menu',
			'ui/rave/main-menu/art',
			'ui/rave/main-menu/SynSun/scrolltext',
		];
		var results = [];

		for (path in paths) for (shit in CoolUtil.listFilesInPath(path, ext)) results.push(Paths.image('$path/$shit'));

		return results;
	}

	var backdrop:FlxBackdrop;
	var border:FlxSprite;
	var sun:FlxSprite;
	var menuArt:FlxSprite;
	var scrollText:FlxBackdrop;
	var sidebar:FlxSprite;

	override function create()
	{
		FlxG.mouse.visible = true;

		backdrop = new FlxBackdrop(Paths.image('ui/rave/main-menu/checkerboard').toString());
		backdrop.velocity.set(-40, -40);
		backdrop.antialiasing = false;
		add(backdrop);

		menuArt = new FlxSprite(1280, -56).loadGraphic(Paths.image('ui/rave/main-menu/art/story').toString()); // hook this up to curselected eventually
		menuArt.antialiasing = false;
		add(menuArt);

		scrollText = new FlxBackdrop(Paths.image('ui/rave/main-menu/SynSun/scrolltext/story').toString(), 0x01);
		scrollText.setPosition(0, 400);
		scrollText.velocity.set(-40, 0);
		scrollText.antialiasing = false;
		add(scrollText);
		FlxTween.tween(scrollText, {
			y: 329
		}, 0.5, {
			ease: FlxEase.sineOut
		});

		border = new FlxSprite().loadGraphic(Paths.image('ui/rave/main-menu/border').toString());
		border.screenCenter();
		border.antialiasing = false;
		border.alpha = 0.001;
		FlxTween.tween(border, {
			alpha: 1
		}, 0.5, {
			ease: FlxEase.sineOut
		});
		add(border);

		var scan:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/rave/main-menu/scanlines').toString());
		scan.screenCenter();
		scan.antialiasing = false;
		add(scan);

		var bg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/rave/main-menu/BG').toString());
		bg.screenCenter();
		bg.antialiasing = false;
		add(bg);

		var deskbg:FlxSprite = new FlxSprite().loadGraphic(Paths.image('ui/rave/main-menu/desk').toString());
		deskbg.screenCenter();
		deskbg.antialiasing = false;
		add(deskbg);

		var animations:Map<String, Array<Int>> = [
			'idle' => [0],
			'greeting' => CoolUtil.numberArray(36, 1),
			'think' => CoolUtil.numberArray(55, 37),
			'exhale' => CoolUtil.numberArray(74, 56),
			'excited' => CoolUtil.numberArray(93, 75),
			'determined' => CoolUtil.numberArray(112, 94),
			'nervous' => CoolUtil.numberArray(131, 113),
			'blush' => CoolUtil.numberArray(150, 132),
			'sad' => CoolUtil.numberArray(169, 151),
			'happy' => CoolUtil.numberArray(188, 170),
			'laugh' => CoolUtil.numberArray(207, 189),
			'phone' => CoolUtil.numberArray(283, 208),
			'reset' => CoolUtil.numberArray(36, 30),
		];

		var isLooping = ['idle', 'phone'];

		sun = new FlxSprite(730, -4);
		sun.frames = Assets.getSparrowAtlas(Paths.image('ui/rave/main-menu/SynSun/Sundried'));

		for (animation => indices in animations) sun.animation.addByIndices(animation, 'SD All in One', indices, '', 24, isLooping.contains(animation));

		sun.antialiasing = false;
		add(sun);

		animations = [
			"idle" => [0],
			"greeting" => CoolUtil.numberArray(56, 0),
			"idle_rand" => CoolUtil.numberArray(178, 57),
			"happy" => CoolUtil.numberArray(31, 0),
			"alert" => CoolUtil.numberArray(202, 179),
			"upset" => CoolUtil.numberArray(231, 203),
			"quiet" => CoolUtil.numberArray(269, 232),
			"confused" => CoolUtil.numberArray(293, 270),
			"hueh" => CoolUtil.numberArray(316, 294),
			"p03" => CoolUtil.numberArray(339, 317),
			"sad" => CoolUtil.numberArray(359, 340),
			"search" => CoolUtil.numberArray(379, 360),
			"Bored" => CoolUtil.numberArray(423, 380),
			"reset" => CoolUtil.numberArray(56, 33)
		];

		isLooping = ['Bored'];

		var syn = new FlxSprite(720, 133);
		syn.frames = Assets.getSparrowAtlas(Paths.image('ui/rave/main-menu/SynSun/Synthetic'));

		for (animation => indices in animations) syn.animation.addByIndices(animation, 'Syn All In One', indices, '', 24, isLooping.contains(animation));

		syn.antialiasing = false;
		add(syn);

		sidebar = new FlxSprite(-2018).loadGraphic(Paths.image('ui/rave/main-menu/sidebar_full').toString());
		sidebar.antialiasing = false;
		add(sidebar);
		FlxTween.tween(sidebar, {
			x: -1649
		}, 0.5, {
			ease: FlxEase.sineOut
		});

		var list = ['crashlog', 'mods', 'exit-mod'];

		if (RaveGlobal.isDebugMode)
		{
			list.insert(0, 'chartEditor');
			list.insert(1, 'cameraEditor');
		}

		CoolUtil.createSidebarPanelsBasedOnOGS('rave', list);
		#if FEATURE_DEBUG_MENU
		funkin.util.plugins.SidePanelPlugin.requestPanel('rave', true);
		#end
	}

	override function destroy()
	{
		super.destroy();

		CoolUtil.removeCustomSidebarPanels('rave');
	}
}

class MMenuItem extends FunkinGroup
{
	var song:String;
	var bg:FlxSprite;
	var text:FlxSprite;

	public var name:String;

	public function new(x:Float = 0, y:Float = 0, item:String)
	{
		super(x, y);

		name = item;

		bg = new FlxSprite().loadGraphic(Paths.image('ui/rave/main-menu/buttons/${item}back').toString());
		bg.antialiasing = false;
		add(bg);
	}
}
