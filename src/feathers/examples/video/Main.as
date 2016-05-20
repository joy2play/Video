package feathers.examples.video
{
	import feathers.controls.Alert;
	import feathers.controls.AutoSizeMode;
	import feathers.controls.Button;
	import feathers.controls.ImageLoader;
	import feathers.controls.LayoutGroup;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;
	import feathers.layout.AnchorLayout;
	import feathers.layout.AnchorLayoutData;
	import feathers.layout.HorizontalLayoutData;
	import feathers.media.FullScreenToggleButton;
	import feathers.media.MuteToggleButton;
	import feathers.media.PlayPauseToggleButton;
	import feathers.media.SeekSlider;
	import feathers.media.TimeLabel;
	import feathers.media.VideoPlayer;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;

	public class Main extends Sprite
	{
		public function Main()
		{
			new MetalWorksMobileTheme();
			super();
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		}
		
		protected var _videoPlayer:VideoPlayer
		protected var _controls:LayoutGroup;
		protected var _playPauseButton:PlayPauseToggleButton;
		protected var _seekSlider:SeekSlider;
		protected var _muteButton:MuteToggleButton;
		protected var _fullScreenButton:FullScreenToggleButton;
		protected var _view:ImageLoader;
		
		protected var _timeLabel:TimeLabel;
		protected var _btnPlayDelay:Button;
		
		private static const TIME:int = 5;
		
		private function addedToStageHandler(event:starling.events.Event):void
		{
			this._videoPlayer = new VideoPlayer();
			this._videoPlayer.autoSizeMode = AutoSizeMode.STAGE;
			this._videoPlayer.layout = new AnchorLayout();
			this._videoPlayer.addEventListener(Event.READY, videoPlayer_readyHandler);
			this._videoPlayer.addEventListener(FeathersEventType.ERROR, videoPlayer_errorHandler);
			this.addChild(this._videoPlayer);
			
			this._view = new ImageLoader();
			this._videoPlayer.addChild(this._view);
			
			this._controls = new LayoutGroup();
			this._controls.touchable = false;
			this._controls.styleNameList.add(LayoutGroup.ALTERNATE_STYLE_NAME_TOOLBAR);
			this._videoPlayer.addChild(this._controls);
			
			this._playPauseButton = new PlayPauseToggleButton();
			this._controls.addChild(this._playPauseButton);
			
			_timeLabel = new TimeLabel();
			_timeLabel.styleNameList.add(TimeLabel.DISPLAY_MODE_CURRENT_AND_TOTAL_TIMES);
			this._controls.addChild(this._timeLabel);
			
			this._seekSlider = new SeekSlider();
			this._seekSlider.layoutData = new HorizontalLayoutData(100);
			this._controls.addChild(this._seekSlider);
			
			this._muteButton = new MuteToggleButton();
			this._controls.addChild(this._muteButton);

//			this._fullScreenButton = new FullScreenToggleButton();
//			this._controls.addChild(this._fullScreenButton);
			
			_btnPlayDelay = new Button();
			_btnPlayDelay.label="delay"+TIME+"s";
			this._controls.addChild(this._btnPlayDelay);
			_btnPlayDelay.addEventListener(Event.TRIGGERED,onPlayDelay);
			
			var controlsLayoutData:AnchorLayoutData = new AnchorLayoutData();
			controlsLayoutData.left = 0;
			controlsLayoutData.right = 0;
			controlsLayoutData.bottom = 0;
			this._controls.layoutData = controlsLayoutData;

			var viewLayoutData:AnchorLayoutData = new AnchorLayoutData(0, 0, 0, 0);
			viewLayoutData.bottomAnchorDisplayObject = this._controls;
			this._view.layoutData = viewLayoutData;
			
			//test.mp4
			_videoPlayer.videoSource = "assets/test.mp4";
		}
		
		protected function videoPlayer_readyHandler(event:Event):void
		{
			this._view.source = this._videoPlayer.texture;
			this._controls.touchable = true;
		}
		
		protected function videoPlayer_errorHandler(event:Event):void
		{
			Alert.show("Cannot play selected video.",
				"Video Error", new ListCollection([{ label: "OK" }]));
			trace("VideoPlayer Error: " + event.data);
		}
		
		private function onPlayDelay(e:Event):void
		{
			if(_videoPlayer.isPlaying==false)
				return;
			
			_videoPlayer.pause();
			
			Starling.juggler.delayCall(playaAgain,TIME);
		}
		private function playaAgain():void
		{
			_videoPlayer.play();
		}
	}
}
