package me.danov.photoflash.model {
import flash.external.ExternalInterface;

public class Config {

    public static var EVENT_CAM_ACTIVATION:String = "cameraActivation";
    public static var EVENT_CAM_STATUS:String = "cameraStatus";
    public static var EVENT_RESIZE:String = "eventResize";
    public static var EVENT_SANDBOX_CHANGE:String = "sandboxChange";
    public static var EVENT_SHOW_SANDBOX:String = "sandboxShow";

    public function debugTrace(v:*):void {
        if(debug) {
            ExternalInterface.call('console.log', String(v));
            trace(String(v));
        }
    }

    private var _params:Object;

    public function Config(params:Object) {
        _params = params;
    }

    public function get debug():Boolean {
        return String(_params['debug']).toLowerCase() == 'true';
    }

    public function get shotDelay():Number {
        return _params['shotDelay'] ? _params['shotDelay'] : 3000;
    }

    public function get sandboxGuide():String {
        return _params['sandboxGuide'] ? _params['sandboxGuide'] : "";
    }

    public function get uploadPreloader():String {
        return _params['uploadPreloader'] ? _params['uploadPreloader'] : "";
    }

    public function get countDownAnimation():String {
        return _params['countDown'] ? _params['countDown'] : "";
    }

    public function get autoActivateCam():Boolean {
        return String(_params['autoActivate']).toLowerCase() == 'true';
    }

    public function get uploadUrl():String {
        return _params['uploadUrl'] ? _params['uploadUrl'] : 'upload.php';
    }

    public function get mirror():Boolean {
        return String(_params['real']).toLowerCase() != 'true';
    }

    public function get camWidth():Number {
        return _params['camWidth'] ? _params['camWidth'] : 640;
    }

    public function get camHeight():Number {
        return _params['camHeight'] ? _params['camHeight'] : 480;
    }

    public function get camFPS():Number {
        return _params['camFPS'] ? _params['camFPS'] : 30;
    }

    public function get camBandwidth():Number {
        return _params['camBandwidth'] ? _params['camBandwidth'] : 0;
    }

    public function get camQuality():Number {
        return _params['camQuality'] ? _params['camQuality'] : 100;
    }

    public function get callback():String {
        return _params['callback'] ? _params['callback'] : null;
    }
}
}
