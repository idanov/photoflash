package me.danov.photoflash.model {
import me.danov.photoflash.observer.Observable;
import me.danov.photoflash.observer.Observer;

public class Model implements Observable{
    protected var _observers:Array = [];
    public function Model() {
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
}
}
