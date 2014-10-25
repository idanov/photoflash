package me.danov.photoflash.view {
import flash.display.Sprite;

import me.danov.photoflash.model.Config;

import me.danov.photoflash.observer.Observable;
import me.danov.photoflash.observer.Observer;

public class View extends Sprite implements Observable, Observer {
    protected var _parent: Sprite;
    protected var _observers: Array = [];

    /**
     * Bind a view component to a specific parent for its lifetime
     * @param parent
     */
    public function View(parent:Sprite) {
        super();
        _parent = parent;
        visible = false;
    }

    /**
     * Default resize behaviour is to center the sprite
     */
    public function onResize():void {
        this.x = _parent.stage.stageWidth / 2 - this.width / 2;
        this.y = _parent.stage.stageHeight / 2 - this.height / 2;
    }

    /**
     * View component is responsible to adding and removing itself to the stage
     * Make sure it is added to the stage on the proper place and with a proper size
     * @param v
     */
    override public function set visible(v:Boolean):void {
        if(visible != v) {
            super.visible = v;
            if(visible) {
                _parent.addChild(this);
            } else {
                if(parent == _parent) {
                    _parent.removeChild(this);
                }
            }
            notifyObservers(Config.EVENT_RESIZE);
        }
    }

    public function registerObserver(observer:Observer):void {
        _observers.push(observer);
    }

    public function removeObserver(observer:Observer):void {
        var len:int = _observers.length;
        for(var i:int = 0; i < len; i++){
            if(observer === _observers[i]){
                _observers.splice(i, 1);
                break;
            }
        }
    }

    public function removeAllObservers():void {
        _observers = [];
    }

    public function notifyObservers(notification:String):void {
        var len:int = _observers.length;
        for(var i:int = 0; i < len; i++){
            _observers[i].update(notification);
        }
    }

    public function update(notification:String):void {
    }
}
}
