package org.bigbluebutton.view.navigation.pages.careernews
{
	import flash.events.MouseEvent;
	
	public class CareernewsView2 extends CareernewsViewBase2 implements ICareernewsView2 
	{
		
		//private var _buttonTestSignal: Signal = new Signal();
		//public function get buttonTestSignal(): ISignal
		//{
		//	return _buttonTestSignal;
		//}
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			//this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		import spark.components.List;
		
		public function get list():List
		{
			return participantslist;
		}
		/*
		public function onClick(e:MouseEvent):void
		{
			//buttonTestSignal.dispatch();
		}
		*/
		public function dispose():void
		{

		}

		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
	}
}