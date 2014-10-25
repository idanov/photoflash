# PhotoFlash

## Introduction

PhotoFlash is a simple to use Flash webcam application, completely configurable and controllable from JavaScript.
It supports very basic functionality such as checking for existing camera, taking a photo with or without a delay and
sending it to a server-side script over an HTTP POST request as a base64-encoded JPEG image.

## Usage

A complete example for the usage of PhotoFlash can be found in the flash build result [here](../tree/master/dest).

First, include `SWFObject`

```html
<head>
    <!-- ... -->
    <script type="text/javascript" src="swfobject.js"></script>
    <!-- or -->
    <script type="text/javascript"
        src="http://ajax.googleapis.com/ajax/libs/swfobject/2.2/swfobject.js"></script>
    <!-- ... -->
<head>
```

Then find a suitable place in your HTML for the video preview and put a div there

```html
<div id="divToBeReplaced">
    <h1>No flash player installed</h1>
    <p><a href="http://www.adobe.com/go/getflashplayer">
    <img src="http://www.adobe.com/images/shared/download_buttons/get_flash_player.gif"
                alt="Get Adobe Flash player"/>
    </a>
    </p>
</div>
```

Define a helper function to access the flash object from JavaScript

```javascript
function getFlashMovieObject(movieName) {
    if (window.document[movieName]) {
        return window.document[movieName];
    }
    if (navigator.appName.indexOf("Microsoft Internet") == -1) {
        if (document.embeds && document.embeds[movieName])
            return document.embeds[movieName];
    }
    else {
        return document.getElementById(movieName);
    }
}
```

and a callback function

```javascript
function fnCallback(fn, type, txt) {
    console.log(fn + ": " + type + ", " + txt);
}
```

Set flashvars, flash object params and attributes

```javascript
// Flashvars are explained later
var flashvars = {
    sandboxGuide: "pic.jpg",
    uploadPreloader: "preLoader.swf",
    countDown: "preLoader.swf",
    shotDelay: 3000,
    callback: "fnCallback",
    uploadUrl: "upload.php",
    autoActivate: "true",
    camWidth: 640,
    camHeight: 480,
    camFPS: 30,
    camQuality: 100
};

var params = {
    quality: "high", // set the flash movie quality to high
    menu: "true", // that will enable the right-click menu on the flash object
    allowScriptAccess: "always" // this enables JavaScript-to-Flash communication
};

var attributes = {
    id: "movieName",
    name: "movieName"
};
```

Finally, embed the flash object by using `SWFObject`

```javascript
swfobject.embedSWF("photoflash.swf", // specify the path to the PhotoFlash .swf file
                "divToBeReplaced", // specify the id of the HTML element to be replaced
                "640", "480", // set the size of the preview canvas, in pixels
                "11.1.0", // set the target flash player version and
                "expressInstall.swf", // set the path to the flash installer .swf file
                flashvars, params, attributes);

```

After following these steps, PhotoFlash is ready to be used

```javascript
getFlashMovieObject('movieName').takeNow();
```

## API Reference

The app is controlled by setting flashvars and calling the exposed JavaScript methods. Here you can find explanation of 
all available parameters and methods. 

#### Flashvars

Setting the flashvars controls the initial setup of the application

- `sandboxGuide` - specifies a path to an image file (`.jpg`, `.png`) to be shown as a helping guide below the flash 
security sandbox when open *(default: empty)* 
- `uploadPreloader` - specifies a path to a `.swf` animation shown in the center of the preview canvas as a preloader,
 when uploading the taken photo *(default: empty)*
- `countDown` - specifies a path to a `.swf` animation used as a canvas centered countdown when waiting for the photo to be taken *(default: empty)*
- `shotDelay` - sets the delay in *ms* for taking a photo, when `takePhoto()` is called; this might need to be equal to
 the countdown animation duration *(default: 3000)*
- `callback` - a string specifying the name of a JavaScript function to be called in case of a series of events *(default: empty)*;
 the javascript function should have the form `callbackFn(event, typeName, data)`, where `event` could be one of the following:
    - `after_reset` - fired after preview is reset
    - `after_take` - fired after photo is taken
    - `http_status` - fired on receiving the HTTP status code; `data` contains the HTTP status
    - `error` - fired on upload error and additional information for the error is available in `typeName` and `data`
    - `upload` - fired on successful upload; `typeName` contains the flash event type and `data` is the text feedback from the POST request
- `uploadUrl` - url where the POST request should be sent; image data is sent as a POST variable `imageData`,
 which is a base64-encoded jpeg byte stream *(default: "upload.php")*
- `autoActivate` - active the camera on load, if set to `true` *(default: false)*
- `camWidth` - horizontal camera resolution; this will be the width of the uploaded photo, if supported by camera *(default: 640)*
- `camHeight` - vertical camera resolution; this will be the width of the uploaded photo, if supported by camera *(default: 480)*
- `camFPS` - sets the framerate for the video preview *(default: 30)*
- `camBandwidth` - sets the max bandwidth of the video preview in *bytes/s*, 0 is unlimited; not very relevant for photos *(default: 0)*
- `camQuality` - sets the quality of the camera from `0` to `100` *(default: 100)*
- `real` - controls whether the preview is with real or mirrored video stream from the camera *(default: false)*
- `debug` - when set to `true`, some debug info is traced in the JavaScript console *(default: false)*

#### JavaScript interface

All JavaScript calls are accessible by calling them as methods of the object `getFlashMovieObject('movieName')`

- `.showSandBox()` - shows the flash security sandbox
- `.checkCamera()` - checks whether the user has at least one connected camera
- `.activateCamera()` - activate the camera; might result into showing the flash security sandbox
- `.deactivateCamera()` - deactivate the camera
- `.changeCameraMode(width, height, fps)` - change the camera mode to **width** by **height** resolution and **fps** framerate
- `.changeCameraQuality(bandwidth, quality)` - change the bandwidth of the video stream and its quality
- `.takePhoto()` - take photo with a countdown (delay)
- `.takeNow()` - take photo immediately
- `.sendPhoto()` - send the photo to the `uploadUrl`, set as flashvar
- `.resetPhoto()` - reset the preview video canvas, after taken photo
- `.useMirrorImage(mirror)` - set whether a mirrored preview should be used or not

## Motivation

The project is a rework of one of my old freelance projects from 2009, created for the needs of a client. Though very useful
as a black-box component, it was poorly written back then. Recently I needed it for another project, so I've decided to change
it a bit and open-source it. I hope that it should be easier now to modify and/or extend it, so more people can find it useful.
This is my first open-source project and I hope that someone finds it useful.

## Contributors

You are more than welcome to contribute to the project by requesting a feature or reporting a bug
[here](../issues), [forking](../fork) the project
and/or opening a [pull request](../compare) with suggested changes.

#### Compilation instructions

TODO

## License

The classes `BitString` and `JPEGEncoder` are under *Adobe*'s license, which is included in their files.
The class `Base64` is licensed by *Jean-Philippe Auclair* under the [MIT License](http://opensource.org/licenses/MIT).
`SWFObject` is released under the [MIT License](http://opensource.org/licenses/MIT).
The rest of the code is licensed by me under the [MIT License](../blob/master/LICENSE).