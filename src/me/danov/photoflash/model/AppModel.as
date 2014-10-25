package me.danov.photoflash.model {
import flash.display.BitmapData;
import flash.display.Stage;
import flash.events.StatusEvent;
import flash.media.Camera;
import flash.utils.setInterval;

public class AppModel extends Model {
    private var _openSandBox:Boolean = false;
    private var _mirror:Boolean = false;
    private var _camActive:Boolean = false;
    private var _stage:Stage;
    private var _myCam:Camera;
    private var _config:Config;

    public function AppModel(config:Config, stage:Stage) {
        _stage = stage;
        _config = config;
        _mirror = _config.mirror;
        setInterval(securitySandBoxCheck, 100);
    }

    private function securitySandBoxCheck():void {
        var dummy:BitmapData = new BitmapData(1, 1);
        try {
            dummy.draw(_stage);
            openSandBox = false;
        } catch (e:Error) {
            openSandBox = true;
        } finally {
            dummy.dispose();
        }
    }

    public function get openSandBox():Boolean {
        return _openSandBox;
    }

    public function set openSandBox(value:Boolean):void {
        if(_openSandBox != value) {
            _openSandBox = value;
            notifyObservers(Config.EVENT_SANDBOX_CHANGE);
        }
    }

    public function get mirror():Boolean {
        return _mirror;
    }

    public function set mirror(value:Boolean):void {
        if(_mirror != value) {
            _mirror = value;
            notifyObservers(Config.EVENT_RESIZE);
        }
    }

    public function get camAvailable():Boolean {
        return Camera.names.length > 0;
    }

    public function get camWidth():Number {
        return _myCam == null ? _config.camWidth : cam.width;
    }

    public function get camHeight():Number {
        return _myCam == null ? _config.camHeight : cam.height;
    }

    public function get camFPS():Number {
        return _myCam == null ? _config.camFPS : cam.fps;
    }

    public function get camBandWidth():Number {
        return _myCam == null ? _config.camBandwidth : cam.bandwidth;
    }

    public function get camQuality():Number {
        return _myCam == null ? _config.camQuality : cam.quality;
    }

    public function get camEnabled():Boolean {
        return camAvailable && !cam.muted;
    }

    public function get camActivated():Boolean {
        return _camActive;
    }

    public function set camActivated(v:Boolean):void {
        if(_camActive != v) {
            _camActive = v;
            if(!camEnabled) {
                notifyObservers(Config.EVENT_SHOW_SANDBOX);
            }
            notifyObservers(Config.EVENT_CAM_ACTIVATION);
        }
    }

    public function setCamMode(w:int = 640, h:int = 480, fps:int = 30):void {
        w = w ? w : 640;
        h = h ? h : 480;
        fps = fps ? fps : 30;
        cam.setMode(w, h, fps);
        notifyObservers(Config.EVENT_RESIZE);
    }

    public function setCamQuality(bw:int = 0, q:int = 100):void {
        bw = bw ? bw : 0;
        q = q ? q : 0;
        cam.setQuality(bw, q);
    }

    public function get cam():Camera {
        if(camAvailable && _myCam == null) {
            _myCam = Camera.getCamera();
            _myCam.addEventListener(StatusEvent.STATUS, camStatus);
            setCamMode(_config.camWidth, _config.camHeight, _config.camFPS);
            setCamQuality(_config.camBandwidth, _config.camQuality);
        }
        return _myCam;
    }

    private function camStatus(e:StatusEvent):void {
        if (e.code == "Camera.Muted" || e.code == "Camera.Unmuted") {
            notifyObservers(Config.EVENT_CAM_STATUS);
        }
    }
}
}
