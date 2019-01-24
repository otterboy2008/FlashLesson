package component
{
	import common.BaseComponent;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import model.AssetPx;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class CommentsComponent extends BaseComponent
	{
		//pi zhu 
		private var _pizhuMC:MovieClip;
		//eraser
		private var _eraserMC:MovieClip;
		//pen
		private var _mcPen:MovieClip;
		//colors
		private var _mcColors:MovieClip;
		
		private var _mcComments:MovieClip;
		private var _mcRaise:MovieClip;
		
		private var _animationFive:MovieClip;
		private var _animationFlower:MovieClip;
		private var _animationLike:MovieClip;
		
		private var _btnPen:MovieClip;
		private var _btnColor:MovieClip;
		private var _btnEraser:MovieClip;
		
		private var _btnFive:MovieClip;
		private var _btnflower:MovieClip;
		private var _btnLike:MovieClip;
		
		private var _isEraserDown:Boolean;
		private var myBD:BitmapData;
		private var myBmp:Bitmap;
		
		private var _isMouseDown:Boolean;
		private var _needPizhu:Boolean;
		
		private var _colorList:Array = [0xFFFFFF, 0xFFCC00, 0x663399, 0xFF9900, 
										0x007AFF, 0x4CD964, 0xFF291E, 0x333333];	
		
		private var _colorIndex:int;
		
		public function CommentsComponent() 
		{
			init()
		}
		
		private function init():void
		{
			_pizhuMC = new MovieClip();
			_pizhuMC.mouseEnabled = false;
			this.addChild(_pizhuMC);
			
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			
			var clsComments:Class = assetPx.getGeneralAsset("common", "MCCommentButtons");
			_mcComments = new clsComments();
			this.addChild(_mcComments);
			_mcComments.x = (1920 - _mcComments.width) / 2 + _mcComments.width;
			_mcComments.y = 50;
			_btnPen = _mcComments.getChildByName("btn_pen") as MovieClip;
			_btnPen.buttonMode = true;
			_btnPen.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			_btnColor = _mcComments.getChildByName("btn_color") as MovieClip;
			_btnColor.buttonMode = true;
			_btnColor.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			_btnEraser = _mcComments.getChildByName("btn_eraser") as MovieClip;
			_btnEraser.buttonMode = true;
			_btnEraser.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			var clsRaise:Class = assetPx.getGeneralAsset("common", "MCRaiseButtons");
			_mcRaise = new clsRaise();
			this.addChild(_mcRaise);
			_mcRaise.x = 50;
			_mcRaise.y = 1080 - _mcRaise.height - 20;
			_btnFive = _mcRaise.getChildByName("btn_five") as MovieClip;
			_btnFive.buttonMode = true;
			_btnFive.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			_btnflower = _mcRaise.getChildByName("btn_flower") as MovieClip;
			_btnflower.buttonMode = true;
			_btnflower.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			_btnLike = _mcRaise.getChildByName("btn_like") as MovieClip;
			_btnLike.buttonMode = true;
			_btnLike.addEventListener(MouseEvent.CLICK, onBtnsClick);
			
			var cls:Class = assetPx.getGeneralAsset("common", "MCErase");
			_eraserMC = new cls();
			_eraserMC.buttonMode = true;
			_eraserMC.addEventListener(MouseEvent.MOUSE_DOWN, onEraserMouseDown);
			this.addChild(_eraserMC);
			_eraserMC.x = _mcComments.x + _mcComments.width + 30;
			_eraserMC.y = _mcComments.y;
			_eraserMC.visible = false;
			
			var penCls:Class = assetPx.getGeneralAsset("common", "MCPen");
			_mcPen = new penCls();
			_mcPen.mouseEnabled = false;
			this.addChild(_mcPen);
			_mcPen.visible = false;
			
			var colorCls:Class = assetPx.getGeneralAsset("common", "MCColors");
			_mcColors = new colorCls();
			_mcColors.mouseEnabled = false;
			this.addChild(_mcColors);
			_mcColors.x = _mcComments.x + _btnColor.x - _mcColors.width / 2;
			_mcColors.y = _mcComments.height + 50;
			_mcColors.visible = false;
			
			var aniFive:Class = assetPx.getGeneralAsset("common", "MCFiveAnimation");
			_animationFive = new aniFive();
			_animationFive.gotoAndStop(1);
			_animationFive.addEventListener("AnimationEnd", onAnimationEnd);
			_animationFive.mouseChildren = false;
			
			var aniFlower:Class = assetPx.getGeneralAsset("common", "MCFlowerAnimation");
			_animationFlower = new aniFlower();
			_animationFlower.gotoAndStop(1);
			_animationFlower.addEventListener("AnimationEnd", onAnimationEnd);
			_animationFlower.mouseChildren = false;
			
			var aniLike:Class = assetPx.getGeneralAsset("common", "MCLikeAnimation");
			_animationLike = new aniLike();
			_animationLike.gotoAndStop(1);
			_animationLike.addEventListener("AnimationEnd", onAnimationEnd);
			_animationLike.mouseChildren = false;
			
			for (var i:int = 0; i < _colorList.length; i++)
			{
				var btn:MovieClip = _mcColors.getChildByName("btn_" + i) as MovieClip;
				btn.buttonMode = true;
				btn.index = i;
				btn.addEventListener(MouseEvent.CLICK, onBtnColorClick);
			}
			
			_needPizhu = true;
			
			myBD = new BitmapData(1800, 1000, true, 0);
			myBmp  = new Bitmap(); 
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStageEvent);
			
		}
		
		private function onAddToStageEvent(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddToStageEvent);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		public function reset():void
		{
			_pizhuMC.graphics.clear();
			if (myBmp.parent)
			{
				_pizhuMC.removeChild(myBmp);
			}
		}
		
		public function setNeedPizhu(need:Boolean):void
		{
			_needPizhu = need;
			_mcComments.visible = _needPizhu;
		}
		
		private function onBtnColorClick(e:MouseEvent):void
		{
			_colorIndex = e.currentTarget.index;
			_mcColors.visible = false;
		}
		
		private function onBtnsClick(e:MouseEvent):void
		{
			var names:String = e.currentTarget.name;
			switch(names)
			{
				case "btn_pen":
					_eraserMC.visible = false;
					_mcColors.visible = false;
					_mcPen.visible = !_mcPen.visible;
					if (_mcPen.visible)
					{
						_mcPen.x = mouseX;
						_mcPen.y = mouseY;
					}
					break;
				case "btn_color":
					_mcPen.visible = false;
					_eraserMC.visible = false;
					_mcColors.visible = !_mcColors.visible;
					break;
				case "btn_eraser":
					_mcPen.visible = false;
					_mcColors.visible = false;
					_eraserMC.visible = !_eraserMC.visible;
					break;
				case "btn_five":
					if (_animationFive.parent == null)
					{
						this.addChild(_animationFive);
					}
					_animationFive.gotoAndPlay(1);
					break;
				case "btn_flower":
					if (_animationFive.parent == null)
					{
						this.addChild(_animationFlower);
					}
					_animationFlower.gotoAndPlay(1);
					break;
				case "btn_like":
					if (_animationFive.parent == null)
					{
						this.addChild(_animationLike);
					}
					_animationLike.gotoAndPlay(1);
					break;
			}
		}
		
		private function onAnimationEnd(e:Event):void
		{
			var mc:MovieClip = e.currentTarget as MovieClip;
			if (mc.parent)
			{
				this.removeChild(mc);
			}
		}
		
		private function onMouseDown(e:MouseEvent):void
		{
			if (_needPizhu)
			{
				_isMouseDown = true;
				_pizhuMC.graphics.lineStyle(8, _colorList[_colorIndex]);
				_pizhuMC.graphics.moveTo(mouseX,mouseY);
			}
		}
		
		private function onMouseMove(e:MouseEvent):void
		{
			if (_mcPen.visible)
			{
				_mcPen.x = mouseX;
				_mcPen.y = mouseY;
			}
			if (_isMouseDown && !_isEraserDown && _mcPen.visible)
			{
				_pizhuMC.graphics.lineTo(mouseX, mouseY);
			}
			if (_isEraserDown)
			{
				erase();
			}
		}
		
		private function onMouseUp(e:MouseEvent):void
		{
			_isMouseDown = false;
			_isEraserDown = false;
			_eraserMC.stopDrag();
			_eraserMC.x = _mcComments.x + _mcComments.width + 30;
			_eraserMC.y = _mcComments.y;
		}
		
		private function onEraserMouseDown(event:MouseEvent):void
		{
			_isEraserDown = true;
			_eraserMC.startDrag(false);
			//mc转换为位图对象
			myBD.draw(_pizhuMC);
			myBmp.bitmapData = myBD;
			_pizhuMC.graphics.clear();
			_pizhuMC.addChild(myBmp);
			if (this.getChildIndex(_pizhuMC) > this.getChildIndex(_eraserMC)){
				this.swapChildren(_pizhuMC,_eraserMC);
			}
		}
		private function erase():void{
			//将sp所在的区域设置为透明；
			var istart:int = _eraserMC.y;
			var iend:int = _eraserMC.y + _eraserMC.height;
			var jstart:int = _eraserMC.x;
			var jend:int = _eraserMC.x + _eraserMC.width;
			for (var i:int = istart; i <= iend; i++)
			{
				if (i > 0)
				{
					for (var j:int = jstart; j <= jend; j++)
					{
						if (j > 0)
						{
							myBmp.bitmapData.setPixel32(j,i,0);
						}
					}
				}
			}
		}
	}
}