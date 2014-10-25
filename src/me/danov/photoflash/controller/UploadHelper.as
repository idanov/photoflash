package me.danov.photoflash.controller {
import com.adobe.images.JPEGEncoder;
import com.sociodox.utils.Base64;

import flash.display.BitmapData;
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

import me.danov.photoflash.model.Config;

public class UploadHelper {
    private var _remoteController:RemoteController;
    private var _uploadUrl:String;
    private var _config:Config;

    public function UploadHelper(config: Config, uploadUrl:String, remoteController:RemoteController) {
        _remoteController = remoteController;
        _uploadUrl = uploadUrl;
        _config = config;
    }

    private function onHttpStatus(e:HTTPStatusEvent):void {
        _remoteController.resetPhoto();
        _remoteController.callback('http_status', e.type, e.status.toString());
    }

    private function onIOError(e:IOErrorEvent):void {
        _remoteController.resetPhoto();
        _remoteController.callback('error', e.type, e.text);
    }

    private function uploadCompleted(e:Event):void {
        var l:URLLoader = e.target as URLLoader;
        l.removeEventListener(Event.COMPLETE, uploadCompleted);
        _remoteController.resetPhoto();
        _remoteController.callback('upload', e.type, l.data);
    }

    public function sendJPG (bmpData: BitmapData): void {
        var jpgObj: JPEGEncoder = new JPEGEncoder(100);
        var imageBytes: ByteArray = jpgObj.encode(bmpData);
        imageBytes.position = 0;
        var base64Data:String = Base64.encode(imageBytes);

        var urlRequest:URLRequest = new URLRequest(_uploadUrl);
        urlRequest.method = URLRequestMethod.POST;
        urlRequest.data = new URLVariables();
        urlRequest.data.imageData = base64Data;
        urlRequest.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));

        var loader:URLLoader = new URLLoader();
        loader.dataFormat = URLLoaderDataFormat.BINARY;
        loader.addEventListener(Event.COMPLETE, uploadCompleted);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, onHttpStatus);

        try {
            loader.load(urlRequest);
        } catch (err: Error) {
            _config.debugTrace(err.toString());
            loader.removeEventListener(Event.COMPLETE, uploadCompleted);
        }
    }
}
}
