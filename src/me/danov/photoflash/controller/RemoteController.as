package me.danov.photoflash.controller {
import flash.external.ExternalInterface;
import flash.system.Security;
import flash.system.SecurityPanel;
import flash.utils.setTimeout;

import me.danov.photoflash.model.AppModel;
import me.danov.photoflash.model.Config;
import me.danov.photoflash.observer.Observer;
import me.danov.photoflash.view.VideoContainer;
import me.danov.photoflash.view.View;

public class RemoteController implements Observer {
    private var _model:AppModel;
    private var _config: Config;
    private var _vidContainer:VideoContainer;
    private var _preLoader:View;
    private var _countdown:View;
    private var _uploadHelper:UploadHelper;

    public function RemoteController(config:Config, model:AppModel, vidContainer:VideoContainer, countdown:View, preLoader:View) {
		_config = config;
        _model = model;
        _vidContainer = vidContainer;
        _countdown = countdown;
        _preLoader = preLoader;
        initCallbacks();
    }

    private function initCallbacks():void {
        ExternalInterface.addCallback('showSandBox', showSandBox);
        ExternalInterface.addCallback('checkCamera', checkCamera);
        ExternalInterface.addCallback('activateCamera', activateCamera);
        ExternalInterface.addCallback('deactivateCamera', deactivateCamera);
        ExternalInterface.addCallback('changeCameraMode', changeCameraMode);
        ExternalInterface.addCallback('changeCameraQuality', changeCameraQuality);
        ExternalInterface.addCallback('takePhoto', takePhoto);
        ExternalInterface.addCallback('takeNow', takeNow);
        ExternalInterface.addCallback('sendPhoto', sendPhoto);
        ExternalInterface.addCallback('resetPhoto', resetPhoto);
        ExternalInterface.addCallback('useMirrorImage', useMirrorImage);
    }

    /**
     * All javascript incoming calls
     */
    public function deactivateCamera():void {
        _config.debugTrace("deactivateCamera");
        _model.camActivated = false;
    }

    public function activateCamera():void {
        _config.debugTrace("activateCamera");
        _model.camActivated = true;
    }

    public function showSandBox(val:String = SecurityPanel.PRIVACY):void {
        _config.debugTrace("showSandBox('" + val +"')");
        Security.showSettings(val);
    }

    public function checkCamera():Boolean {
        _config.debugTrace("checkCamera");
        return _model.camAvailable;
    }

    public function changeCameraMode(w:int = 640, h:int = 480, fps:int = 30):void {
        _config.debugTrace("changeCameraMode(" + w + "," + h + "," + fps + ")");
        if(_model.camActivated && _model.camEnabled) {
            _model.setCamMode(w, h, fps);
        }
    }

    public function changeCameraQuality(bw:int = 0, q:int = 100):void {
        _config.debugTrace("changeCameraQuality(" + bw + "," + q + ")");
        if(_model.camActivated && _model.camEnabled) {
            _model.setCamQuality(bw, q);
        }
    }

    public function takePhoto():void {
        _config.debugTrace("takePhoto");
        if(_model.camActivated && _model.camEnabled) {
            if (!_countdown.visible && !_vidContainer.frozen) {
                _countdown.visible = true;
                setTimeout(takePic, _config.shotDelay);
            }
        }
    }

    public function takeNow():void {
        _config.debugTrace("takeNow");
        if(_model.camActivated && _model.camEnabled) {
            if (!_countdown.visible && !_vidContainer.frozen) {
                takePic();
            }
        }
    }

    public function takePic():void {
        _config.debugTrace("takePic");
        if (_model.camActivated && _model.camEnabled) {
            _countdown.visible = false;
            if (!_vidContainer.frozen && !_model.openSandBox) {
                _vidContainer.frozen = true;
                callback('after_take');
            }
        }
    }

    public function sendPhoto():void {
        _config.debugTrace("sendPhoto");
        if (_vidContainer.frozen) {
            _preLoader.visible = true;
            _uploadHelper.sendJPG(_vidContainer.snapshot);
        }
    }

    public function resetPhoto():void {
        _config.debugTrace("resetPhoto");
        _countdown.visible = false;
        _preLoader.visible = false;
        _vidContainer.frozen = false;
        callback('after_reset');
    }

    public function useMirrorImage(v:Boolean):void {
        _config.debugTrace("useMirrorImage(" + v.toString() + ")");
        _model.mirror = v;
    }

    /**
     * Outgoing javascript calls
     */
    public function callback(event:String, typeName:String = null, data:* = null):void {
        if(_config.callback) {
            ExternalInterface.call(_config.callback, event, typeName, data);
        }
    }

    public function update(notification:String):void {
        switch(notification) {
            case Config.EVENT_SHOW_SANDBOX:
                showSandBox();
                break;
        }
    }

    public function setHelper(uploadHelper:UploadHelper):void {
        _uploadHelper = uploadHelper;
    }
}
}
