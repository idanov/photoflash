package me.danov.photoflash.utils {
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLRequestMethod;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class MultipartFormDataBuilder {

    private var _boundary:String = "------FlashFormBoundary";
    private var _data:ByteArray = new ByteArray();
    private var _finished:Boolean = false;

    public function MultipartFormDataBuilder() {
        for (var i:int = 0; i < 16; i++ ) {
            var base:int = 0x40 + int(Math.floor(Math.random() * 2) * 0x20);
            _boundary += String.fromCharCode(base + int(Math.floor(Math.random() * 25) + 1));
        }
        _data.endian = Endian.BIG_ENDIAN;

    }

    public function build(url:String = null):URLRequest {
        _finished = true;
        _data.writeUTFBytes("--");
        _data.writeUTFBytes(_boundary);
        _data.writeUTFBytes("--");

        var urlRequest:URLRequest = new URLRequest();
        if(url != null) {
            urlRequest.url = url;
        }
        urlRequest.contentType = 'multipart/form-data; boundary=' + _boundary;
        urlRequest.method = URLRequestMethod.POST;
        urlRequest.data = _data;
        urlRequest.requestHeaders.push(new URLRequestHeader('Cache-Control', 'no-cache'));
        return urlRequest;
    }

    public function addParam(paramName:String, paramValue: String):MultipartFormDataBuilder {
        if(_finished) throw new Error("URLRequest has been already built");
        _data.writeUTFBytes("--");
        _data.writeUTFBytes(_boundary);
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes('Content-Disposition: form-data; name="' + paramName + '"');
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes(paramValue);
        _data.writeUTFBytes("\r\n");
        return this;
    }

    public function attachFile(paramName:String, fileName: String, fileData:ByteArray, contentType:String = "application/octet-stream"):MultipartFormDataBuilder {
        if(_finished) throw new Error("URLRequest has been already built");
        _data.writeUTFBytes("--");
        _data.writeUTFBytes(_boundary);
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes('Content-Disposition: form-data; name="' + paramName + '"; filename="' + fileName + '"');
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes('Content-Type: ' + contentType);
        _data.writeUTFBytes("\r\n");
        _data.writeUTFBytes("\r\n");
        _data.writeBytes(fileData, 0, fileData.length);
        _data.writeUTFBytes("\r\n");
        return this;
    }

}
}