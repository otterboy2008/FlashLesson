package model
{
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	/**
	 * ...
	 * @author RexJiang
	 */
	public class SoundPx extends ProxyMgr
	{
		public static const NAME:String = "SoundPx";
		
		private var bgSnd:Sound;
		private var sfxSnd:Sound;
		private var bgChl:SoundChannel;
		private var sfxChl:SoundChannel;
		private var st:SoundTransform;
		
		private var _canPlaySfx:Boolean;
		
		private var _isMusicOn:Boolean;

		public function SoundPx() 
		{
			super(NAME);
		}
		
		public function initSound():void 
		{
			var assetPx:AssetPx = ApplicationFacade.getInstance().retrieveProxy(AssetPx.NAME) as AssetPx;
			var sCls:Class = assetPx.getGeneralAsset("common", "BGSound");
			bgSnd = new sCls();
			
			var sfxCls:Class = assetPx.getGeneralAsset("common", "SFXSound");
			sfxSnd = new sfxCls();
			
			bgChl = new SoundChannel();
			bgChl = bgSnd.play(0, int.MAX_VALUE);
			st = new SoundTransform();
			st.volume = 1;
			bgChl.soundTransform = st;
			
			sfxChl = new SoundChannel();
			
			_isMusicOn = true;
		}
		
		public function setBGSound():void
		{
			_isMusicOn = !_isMusicOn;
			if (_isMusicOn)
			{
				st.volume = 1;
			}
			else
			{
				st.volume = 0;
			}
			bgChl.soundTransform = st;
		}
		
		public function setSfxSound(value:Boolean):void
		{
			_canPlaySfx = value;
		}
		
		public function playSfx():void
		{
			sfxChl = sfxSnd.play();
		}
	}

}