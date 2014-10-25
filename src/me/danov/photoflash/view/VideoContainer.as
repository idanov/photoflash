package me.danov.photoflash.view {
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.geom.Matrix;
import flash.media.Video;

import me.danov.photoflash.model.AppModel;
import me.danov.photoflash.model.Config;

public class VideoContainer extends View {
    protected var _myVid:Video;
    protected var _thumb:Bitmap;
    protected var _stillImage:BitmapData;

    protected var _model:AppModel;

    public function VideoContainer(parent:Sprite, model:AppModel) {
        super(parent);
        _model = model;

        _myVid = new Video(_model.camWidth, _model.camHeight);
        addChild(_myVid);

        _thumb = new Bitmap();
    }

    override public function update(notification:String):void {
        switch(notification) {
            case Config.EVENT_CAM_ACTIVATION:
                    if(_model.camActivated) {
                        _myVid.attachCamera(_model.cam);
                        visible = true;
                    } else {
                        _myVid.attachCamera(null);
                        visible = false;
                    }
                break;
            case Config.EVENT_CAM_STATUS:
                    if(_model.camEnabled) {
                        if(_model.camActivated) {
                            _myVid.attachCamera(_model.cam);
                            visible = true;
                        }
                    } else {
                        _myVid.attachCamera(null);
                        visible = false;
                    }
                break;
        }
    }

    override public function onResize():void {
        _myVid.width = _model.camWidth;
        _myVid.height = _model.camHeight;

        if(frozen) {
            _thumb.width = _model.camWidth;
            _thumb.height = _model.camHeight;
        }

        if (_model.mirror) {
            _myVid.x = _myVid.width;
            _myVid.scaleX = -1;
        } else {
            _myVid.x = 0;
            _myVid.scaleX = 1;
        }

        this.width = _parent.stage.stageWidth;
        this.height = _parent.stage.stageHeight;
    }

    public function get snapshot():BitmapData {
        if(!frozen) {
            frozen = true;
        }
        return _stillImage;
    }

    public function get frozen():Boolean {
        return _stillImage != null;
    }

    public function set frozen(v:Boolean):void {
        if(frozen != v) {
            if(v) {
                _stillImage = new BitmapData(_myVid.width, _myVid.height);

                var horizontalMatrix:Matrix = new Matrix();
                horizontalMatrix.scale( -1, 1);
                horizontalMatrix.translate(_stillImage.width, 0);
                _stillImage.draw(_myVid, _model.mirror ? horizontalMatrix : null);

                _thumb.bitmapData = _stillImage.clone();
                removeChild(_myVid);
                addChild(_thumb);
            } else {
                removeChild(_thumb);
                addChild(_myVid);

                _thumb.bitmapData.dispose();
                _thumb.bitmapData = null;

                _stillImage.dispose();
                _stillImage = null;
            }
            notifyObservers(Config.EVENT_RESIZE);
        }
    }

}
}
