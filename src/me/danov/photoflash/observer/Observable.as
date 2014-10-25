package me.danov.photoflash.observer {
public interface Observable {
    function registerObserver(observer:Observer):void;
    function removeObserver(observer:Observer):void;
    function removeAllObservers():void;
    function notifyObservers(notification:String):void;
}
}
