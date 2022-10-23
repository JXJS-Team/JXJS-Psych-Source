package;

import flixel.*;
import Alphabet;
import flixel.util.*;
import flixel.group.*;
import flixel.effects.*;
import flixel.tweens.*;

class MainMenuState extends FlxState {
	
	public var options = [
		"Story Mode",
		"Freeplay",
		#if desktop "Awards", #end
		"Credits",
		#if desktop "Addons", #end
		"Settings",
		#if desktop "Donate", #end
		#if desktop
		"Toolbox"
		#end
	];


	public static var psychEngineVersion = "0.1";
	
	public var curSelected = 1;

	public var timeBy = 0;

	public var id = 1;

	public var menuItems = new FlxSpriteGroup();

	public function loadStateShit() {
        menuItems.forEach(function(spr:FlxSprite) {
            if (spr.ID == curSelected) {
                FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker){
                    FlxG.sound.play(Paths.sound('confirmMenu'));
                    loadState();
                });
            } else {
                spr.kill();
            }
        });
    }

	public function returnToState() {
		FlxG.switchState(new MainMenuState());
	}

    public function loadState() {
        var daChoice = options[curSelected-1];

        switch(daChoice) {
			case "Story Mode":
				FlxG.switchState(new StoryMenuState());
			case "Freeplay":
				FlxG.switchState(new FreeplayState());
			case "Awards":
				FlxG.switchState(new AchievementsMenuState());
			case "Credits":
				FlxG.switchState(new CreditsState());
			case "Addons":
				FlxG.switchState(new ModsMenuState());
			case "Settings":
				FlxG.switchState(new options.OptionsState());
			case "Donate":
				#if linux
                Sys.command('/usr/bin/xdg-open', ["https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game", "&"]);
                #else
                FlxG.openURL('https://www.kickstarter.com/projects/funkin/friday-night-funkin-the-full-ass-game');
                #end
			case "Toolbox":
				FlxG.switchState(new editors.MasterEditorMenu());
			

        }
    }



	override public function create() {
		super.create();
		var yScroll:Float = Math.max(0.25 - (0.05 * (options.length - 4)), 0.1);

		FlxG.camera.zoom = 1.2;

		var bg = new FlxSprite().loadGraphic(Paths.image("menuBG"));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		for (i in options) {
			if (id == 1) {
				var Option = new Alphabet(13, 40, i,true);
				Option.color = FlxColor.GREEN;
				add(Option);
                // FlxTween.tween(Option, {x: 100}, 0.45, {ease: FlxEase.quadOut});
				Option.ID = id;
				menuItems.add(Option);

				id++;
				timeBy++;
			} else {
				var Option = new Alphabet(13, 40+60*timeBy, i,true);
				Option.color = FlxColor.WHITE;
				add(Option);
                // FlxTween.tween(Option, {x: 100}, 0.45, {ease: FlxEase.quadOut});
				Option.ID = id;
				menuItems.add(Option);

				id++;
				timeBy++;
			}
		}

		menuItems.forEach(function(spr:FlxSprite) {
            if (spr.ID == curSelected) {
                // FlxTween.tween(spr, {x: 100}, 0.45, {ease: FlxEase.quadOut});
				FlxG.camera.follow(spr, null, 1);
                spr.color = FlxColor.GREEN;
            } else {
                // FlxTween.tween(spr, {x: 13}, 0.45, {ease: FlxEase.quadIn});
                spr.color = FlxColor.WHITE;
            }
        });
	}



	override public function update(elapsed) {
        super.update(elapsed);

		menuItems.screenCenter();
        if (FlxG.keys.justPressed.DOWN) {
            changeItem("D");
        }

        if (FlxG.keys.justPressed.UP) {
            changeItem("U");
        }

        if (FlxG.keys.justPressed.ENTER) {
            loadStateShit();
        }
    }

    public function changeItem(way:String) {
        way = way.toLowerCase();

        FlxG.sound.play(Paths.sound('scrollMenu'));

        if (way == "d") {

			if (curSelected == options.length) {
                curSelected = 1;
            } else {
                curSelected++;
            }
        } 

        if (way == "u") {
			if (curSelected == 1) {
                curSelected = options.length;
            } else {
                curSelected = curSelected - 1;
            }

		
        }

        menuItems.forEach(function(spr:FlxSprite) {
			if (spr.ID == curSelected) {
				FlxG.camera.follow(spr, null, 1);
                // FlxTween.tween(spr, {x: 100}, 0.45, {ease: FlxEase.quadOut});
                spr.color = FlxColor.GREEN;
            } else {
                // FlxTween.tween(spr, {x: 13}, 0.45, {ease: FlxEase.quadIn});
                spr.color = FlxColor.WHITE;
            }
        });
	}
}