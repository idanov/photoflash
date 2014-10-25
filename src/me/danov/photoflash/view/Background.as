package me.danov.photoflash.view {
import flash.display.Sprite;

public class Background extends View {
    public function Background(parent:Sprite, color: uint) {
        super(parent);
        graphics.beginFill(color);
        graphics.drawRect(0,0,1,1);
        graphics.endFill();
    }

    override public function onResize():void {
		if (visible) {
			_parent.addChildAt(this, 0);
		}
        x = 0;
        y = 0;
        width = parent.stage.stageWidth;
        height = parent.stage.stageHeight;
    }
}
}
