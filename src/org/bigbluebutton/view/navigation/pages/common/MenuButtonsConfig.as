package org.bigbluebutton.view.navigation.pages.common
{	
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.signalCommandMap.api.ISignalCommandMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IInjector;

	public class MenuButtonsConfig implements IConfig
	{
		[Inject]
		public var injector: IInjector;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		[Inject]
		public var signalCommandMap: ISignalCommandMap;
		
		public function configure():void
		{
			dependencies();
			mediators();
			signals();
		}
		
		/**
		 * Specifies all the dependencies for the feature
		 * that will be injected onto objects used by the
		 * application.
		 */
		private function dependencies():void
		{
			
		}
		
		/**
		 * Maps view mediators to views.
		 */
		private function mediators():void
		{
			mediatorMap.map(IMenuButtonsView).toMediator(MenuButtonsViewMediator2);
		}
		
		/**
		 * Maps signals to commands using the signalCommandMap.
		 */
		private function signals():void
		{
			
		}
	}
}