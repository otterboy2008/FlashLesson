package model{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class UtilsPx extends ProxyMgr{		
		public static const NAME:String="UtilsPx";	
		
		public function UtilsPx(){
			super(NAME);
		}	
		public function screenShot(numFrames:int=1):void{
			var bm:Bitmap;	
			var stage:DisplayObjectContainer;
			
			stage=AssetPx(retrieveProxy(AssetPx.NAME)).stage;						
			
			bm=new Bitmap(new BitmapData(stage.width+1,stage.height+1));
			bm.bitmapData.draw(stage);
			bm.addEventListener(Event.ENTER_FRAME,enterFrame);
			stage.addChild(bm);	
			function enterFrame(e:Event):void{
				if(--numFrames){
					return;
				}
				bm.removeEventListener(Event.ENTER_FRAME,enterFrame);
				bm.bitmapData.dispose();
				stage.removeChild(bm);
			}
		}
		public function allStop(display:DisplayObject):void{
			var container:DisplayObjectContainer;
			var i:int;
			
			if(display is DisplayObjectContainer){
				if(display is MovieClip){
					MovieClip(display).stop();
				}
				container=DisplayObjectContainer(display);
				
				i=container.numChildren;
				while(i--){
					allStop(container.getChildAt(i));
				}
			}
		}
		public function commaNumber(num:Number):String{
			var str:String;			
			var result:String;			
			var i:int;
			
			str=num.toString();
			result='';
			i=str.length/3;
			while(i--){
				result+=','+str.substr(-(3+3*i),3);
			}
			i=str.length%3;	
			return i?str.substr(0, i)+result:result.substring(1);
		}
		public function percentString(num:Number):String{ 			
			num=int(num*100)/100;    	
        	return num==1?"100%":String("0"+int(num*100)).slice(-2)+"%";
        }
		public function convertToTextRank(pNumRank:Number):String{
			var numRank:Number;
			var textRank:String;
			var modulusRemainder:Number;
			
			textRank="";			
			numRank=pNumRank;
			if(numRank>10&&numRank<14){
				textRank = numRank + "th";
				return textRank;				
			}			
			modulusRemainder= numRank % 10;
			switch(modulusRemainder){
				case 1:					
					textRank = numRank + "st";
					break;	
				case 2:
					textRank = numRank + "nd";
					break;
				case 3:
					textRank = numRank + "rd";
					break;
				default:
					textRank = numRank + "th";
					break;
			}
			return textRank;
		}  
		public function getIndex(display:Object):int{
			return display.stage?RegExp(/[0-9]{1,3}/).exec(getIndexContainer(display).name):0;			
		}
		public function getIndexContainer(display:Object):DisplayObject{
			var regExp:RegExp;
			var instanceRegExp:RegExp;
			
			regExp=/[0-9]{1,3}/;			
			instanceRegExp=/instance/;
			while(instanceRegExp.exec(display.name)||!regExp.exec(display.name)){	
				display=display.parent;
			}			
			return DisplayObject(display);
		}
		private var event_added:Event=new Event(Event.ADDED,true);
		public function refreshDisplay(display:DisplayObject):void{
   			var i:int;
   			var container:DisplayObjectContainer;
   			
			if(display){
				display.dispatchEvent(event_added); 
			}   			 
   			if(display is DisplayObjectContainer){
   				container=DisplayObjectContainer(display);
   				i=container.numChildren;
   				while(i--){
					refreshDisplay(container.getChildAt(i));
   				}
   			}       			
		}
		public function formatTime(mili:int):String{
			var seconds:int;
			var minutes:int;
			var hours:int;
			
			seconds=mili/1000;			
			minutes=seconds/60;		
			seconds-=minutes*60;			
			hours=minutes/60;
			minutes-=hours*60;
			return String(hours+100).substr(1,2)+":"+String(minutes+100).substr(1,2)+":"+String(seconds+100).substr(1,2);
		}
		public function findId(lookup:String,xmlList:XMLList):XML{
    		var i:int;
			
    		i=xmlList.length();
    		while(i--){
    			if(xmlList[i].id==lookup){
    				return xmlList[i];
    			}
    		}
    		return null;
	    }		
	}		
}