package me.danov.photoflash.view {

import flash.display.Loader;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

import me.danov.photoflash.model.Config;

public class ImageProxy extends View {
    protected var _loader:Loader;
    protected var _content:MovieClip;
    protected var _config:Config;

    public function ImageProxy(parent:Sprite, config: Config, imagePath:String) {
        super(parent);
        _config = config;
        if(imagePath != null && imagePath.length > 0) {
            _loader = new Loader();
            _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoaded);
            _loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
            _loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            _loader.load(new URLRequest(imagePath));
        }
    }

    protected function onLoaded(e:Event):void {
        e.currentTarget.removeEventListener(Event.COMPLETE, onLoaded);
        if(_loader.content is MovieClip) {
            _content = _loader.content as MovieClip;
            addChild(_content);
        } else {
            addChild(_loader.content);
        }
        visible = visible;
        notifyObservers(Config.EVENT_RESIZE);
    }

    override public function set visible(v:Boolean):void {
            super.visible = v;
            if(visible) {
                if(_content) {
                    _content.gotoAndPlay(1);
                }
            } else {
                if(_content) {
                    _content.gotoAndStop(1);
                }
            }
    }

    protected function onHttpStatus(e:HTTPStatusEvent):void {
        e.currentTarget.removeEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        if(e.status < 200 || e.status > 210) {
            _config.debugTrace(e.toString());
        }
    }

    protected function onIOError(e:IOErrorEvent):void {
        e.currentTarget.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
        _config.debugTrace(e.toString());
    }
}
}
