package event
{
	import flash.events.Event;
	public class MyEvents extends Event
	{
		
		public static const ADDCREDIT : String = "add credit";
		public static const OPENFILE :String = "open file";
		public static const CLOSEFILE :String = "close file";
		public static const ADDTOLIST :String = "add to list";
		public static const CLEARLOG :String = "clear log";
		public static const TRANSFER :String = "transfer";
		public static const POPUPCLOSE :String = "popup close";
		
		public function MyEvents(type:String, bubbles:Boolean=true, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}

	}
}