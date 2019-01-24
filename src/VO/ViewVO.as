package VO{
    public class ViewVO{
        public var display:Class;
        public var mediator:Class;
        public var layer:String;
        public function ViewVO(pDisplay:Class,pMediator:Class,pLayer:String){
        	display=pDisplay;
        	mediator=pMediator
        	layer=pLayer;           
        }
     }
}