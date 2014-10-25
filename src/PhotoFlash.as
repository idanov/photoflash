package {
import flash.display.*;
import flash.events.*;
import flash.net.*;
import flash.system.*;
import flash.ui.*;

import me.danov.photoflash.controller.RemoteController;
import me.danov.photoflash.controller.UploadHelper;
import me.danov.photoflash.model.AppModel;
import me.danov.photoflash.model.Config;
import me.danov.photoflash.observer.Observer;
import me.danov.photoflash.view.Background;
import me.danov.photoflash.view.ImageProxy;
import me.danov.photoflash.view.VideoContainer;
import me.danov.photoflash.view.View;

public class PhotoFlash extends Sprite implements Observer {
    private var _background:View;
    private var _preLoader:View;
    private var _countdown:View;
    private var _warning:View;
    private var _vidContainer:VideoContainer;

    private var _remoteController:RemoteController;
    private var _uploadHelper:UploadHelper;
    private var _config:Config;
    private var _model:AppModel;

    public function PhotoFlash() {
        prepareFlash();
        createAll();
        registerObservers();

        stage.addEventListener(Event.RESIZE, onResize);
        onResize();

        if(_config.autoActivateCam) {
            _model.camActivated = true;
        }

        addEventListener(MouseEvent.CLICK, onClick);
    }

    private function createAll():void {
        _config = new Config(root.loaderInfo.parameters);
        _model = new AppModel(_config, root.stage);

        _background = new Background(this, 0xeeeeee);
        _background.visible = true;
        _warning = new ImageProxy(this, _config, _config.sandboxGuide);
        _preLoader = new ImageProxy(this, _config, _config.uploadPreloader);
        _countdown = new ImageProxy(this, _config, _config.countDownAnimation);
        _vidContainer = new VideoContainer(this, _model);

        _remoteController = new RemoteController(_config, _model, _vidContainer, _countdown, _preLoader);
        _uploadHelper = new UploadHelper(_config, _config.uploadUrl, _remoteController);
        _remoteController.setHelper(_uploadHelper);
    }

    private function registerObservers():void {
        _warning.registerObserver(this);
        _preLoader.registerObserver(this);
        _countdown.registerObserver(this);
        _vidContainer.registerObserver(this);
        _vidContainer.registerObserver(_remoteController);

        _model.registerObserver(this);
        _model.registerObserver(_vidContainer);
        _model.registerObserver(_remoteController);

    }

    private function onClick(e:MouseEvent):void {
        _model.camActivated = !_model.camActivated;
    }

    private function onResize(e:Event = null):void {
        _background.onResize();
        _preLoader.onResize();
        _countdown.onResize();
        _warning.onResize();
        _warning.y = stage.stageHeight / 2 + 70;
        _vidContainer.onResize();
    }

    private function prepareFlash():void {
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;

        var lc:LocalConnection = new LocalConnection();
        Security.allowDomain(lc.domain);

        var myContextMenu:ContextMenu = new ContextMenu();
        myContextMenu.hideBuiltInItems();

        var cmi:ContextMenuItem = new ContextMenuItem("Get PhotoFlash", true, true, true);
        cmi.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function (e:Event):void {
            navigateToURL(new URLRequest("https://github.com/idanov/photoflash"), "_blank");
        });
        myContextMenu.customItems.push(cmi);
        contextMenu = myContextMenu;

    }

    public function update(notification:String):void {
        switch (notification) {
            case Config.EVENT_SANDBOX_CHANGE:
                _warning.visible = _model.openSandBox;
                break;
            case Config.EVENT_RESIZE:
                onResize();
                break;
            default:
                _config.debugTrace("Non-handled event: " + notification);
                break;
        }
    }
}
}