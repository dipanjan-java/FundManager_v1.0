package event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.*;
	
	import mx.formatters.DateFormatter;
	
	[Event(name="add credit",type="event.MyEvent")]
	[Event(name="open file",type="event.MyEvent")]	
	[Event(name="close file",type="event.MyEvent")]
	[Event(name="add to list",type="event.MyEvent")]
	[Event(name="clear log",type="event.MyEvent")]
	
 
	[Bindable]
	public class MyEventDispatcher extends EventDispatcher
	{
		private static var stream:FileStream;
		private static var datafile:File = File.applicationStorageDirectory.resolvePath("userdatas/userdata.xml");
		private static var sysdatafile:File = File.applicationStorageDirectory.resolvePath("userdatas/SystemUserData.xml");
		private static var historyFile:File;
		public static var userdata:XML;
		public static var sysuserdata:XML;
		public static var sysBalance:Number = 0;
		public static var amount:Number = new Number();
		public static var desc:String = new String();
		public static var user:String = new String();
		public static var ctrlpressed:Boolean = false;
		public static var shiftpressed:Boolean = false;
		public static var creditflag:Boolean = false;
		public static var debitflag:Boolean = false;
		public static var clearflag:Boolean = false;
		public static var diffflag:Boolean = false;
		public static var sysuserflag:Boolean = false;
		public static var selecteduserlist:Array = new Array();
		public static var transSelectedUserList:Array = new Array();
		public static var logstream:Array = new Array();
	  	public static var lastIndex:int = -1;
	  	public static var newIndex:int;
	  	public static var userFrom:String = null;
	  	public static var userTo:String = null;
	  	public static var wantToSaveLog:Boolean = false;
	  	
		
				
		public function creditUsers():void{
	  			
	  				var tempuserlist:Array = new Array();
	  				var systotal:Number= 0;
	  				var indAmount:Number;
	  				if(diffflag){
	  					indAmount = amount/userdata.user.length();
	  				}
	  				else{
	  					for(var j:int =0; j< transSelectedUserList.length ; j++){
	  						tempuserlist.push(transSelectedUserList[j]);
	  					}
	  					indAmount = amount/(tempuserlist.length);
	  				}
	  				indAmount=Number((int)(indAmount*100))/100;
	  				var cleartotal:Number = new Number();
	  				if(creditflag){
	  					if(!diffflag){
	  						sysuserdata.bal = String(Math.round((Number(sysuserdata.bal) + amount)*100)/100);
	  						logstream.System.writeUTFBytes( "\n\n" + getDate() +"     User : System     Credit = " + amount + " INR     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  					}
	  					else{
	  						logstream.System.writeUTFBytes( "\n\n" + getDate() +"     User : System     Credit     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  					}
	  				}
	  				else if (debitflag){
	  					if(!diffflag){
	  						if(userFrom == "System"){
	  							sysuserdata.bal = String(Math.round((Number(sysuserdata.bal) - amount)*100)/100);
	  							logstream.System.writeUTFBytes("\n\n" + getDate() +"     User : System     Expence Amount = " + amount + " INR		Paid by : " + userFrom +"     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  						}
	  						else{
	  							var zzzz:String = userdata.user.(name==userFrom).bal;
	  							zzzz = String(Math.round((Number(userdata.user.(name==userFrom).bal) + amount)*100)/100);
	  							userdata.user.(name==userFrom).bal=String(Math.round((Number(userdata.user.(name==userFrom).bal) + amount)*100)/100);
								logstream.System.writeUTFBytes("\n\n" + getDate() +"     User : System     Expence Amount = " + amount + " INR		Paid by : " + userFrom +"     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  							logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + userFrom + "     Credit = " + amount + " INR     Balance = " + userdata.user.(name==userFrom).bal) + " INR";
	  							logstream[userFrom].writeUTFBytes("\n" + getDate() +"     Credit : " + amount + " Balance = " + userdata.user.(name==userFrom).bal + " INR     Description : " + desc + " (Repaying you the total expence amount)");
	  								
	  						}
	  						
	  					}
	  					else
	  						logstream.System.writeUTFBytes( "\n\n" + getDate() +"     User : System     Debit     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  				}
	  				else if (clearflag){
	  					logstream.System.writeUTFBytes("\n\n" + getDate() +"     User : System     Clearing Fund(s) for the following user(s)");
	  				}
	  				for each(var node:XML in userdata.user){
	  					var balance:Number = Number(node.bal);
	  					var userfound:Boolean = false;
	  					for(var i:int =0; i< tempuserlist.length ; i++){
	  							if(node.name.toString() == tempuserlist[i]){
	  								userfound=true;
	  								tempuserlist.splice(i,1);
	  								break;
	  							}
	  					}
	  					if(userfound || diffflag){
	  							if(creditflag){
	  								userdata.user.(name==node.name).bal=String(Math.round((balance+indAmount)*100)/100);
	  								if(!diffflag){
		  								logstream[node.name].writeUTFBytes("\n" + getDate() +"     Credit = " + indAmount + " INR		Balance = " + userdata.user.(name==node.name).bal + " INR     Description : " + desc);
		  								logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + node.name + "     Credit = " + indAmount + " INR     Balance = " + userdata.user.(name==node.name).bal)+ " INR";
	  								}
	  							}
	  							else if(debitflag){
	  								userdata.user.(name==node.name).bal=String(Math.round((balance-indAmount)*100)/100);
	  								if(!diffflag){
	  									logstream[node.name].writeUTFBytes("\n" + getDate() +"     Debit : " + indAmount + " Balance = " + userdata.user.(name==node.name).bal + " INR     Description : " + desc);
	  									logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + node.name + "     Debit = " + indAmount + " INR     Balance = " + userdata.user.(name==node.name).bal) + " INR";
	  								}
	  							}
	  							else if(clearflag){
	  								if(balance==0){
	  									continue;
	  								}
	  								userdata.user.(name==node.name).bal=String(Math.round((balance-balance)*100)/100);
	  								cleartotal+=balance;
	  								logstream[node.name].writeUTFBytes("\n" + getDate() +"     Debit = " + balance + " INR		Balance = " + userdata.user.(name==node.name).bal + " INR     Description : Cleared Fund");
	  								logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + node.name + "     Debit = " + balance + " INR     Balance = " + userdata.user.(name==node.name).bal) + " INR";
	  							}
	  					}
	  					systotal+=Number(userdata.user.(name==node.name).bal);
	  					
	  				}
	  				if (clearflag){
	  					if(cleartotal!=0){
	  						cleartotal=Math.round(cleartotal*100)/100;
	  						sysuserdata.bal = String(Math.round((Number(sysuserdata.bal) - cleartotal)*100)/100);
	  						logstream.System.writeUTFBytes("\n" + getDate() +"     User : System     Debit = " + cleartotal + " INR     System Balance = " + sysuserdata.bal + " INR     Description : Cleared Fund for the users");
	  					}
	  					else{
	  						logstream.System.writeUTFBytes("\n" + getDate() +"     User : System     Description : Clearing Failed! Selected user(s) has zero balance ");
	  					}
	  				}
	  				clearflag=false;
	  				creditflag=false;
	  				debitflag=false;
	  				diffflag=false;
	  				var diff:Number = sysuserdata.bal-systotal;
	  				if(diff>=0.06){
	  					creditflag=true;
	  					diffflag=true;
	  					desc= "Balancing System";
	  					amount=diff-(diff%0.06);
	  					creditUsers();
	  				}
	  				else if(diff<=-0.06){
	  					debitflag=true;
	  					diffflag=true;
	  					desc= "Balancing System";
	  					amount=diff-(diff%.06);
	  					amount= 0- amount;
	  					creditUsers();
	  				}
	  				stream= new FileStream();
					stream.open(datafile, FileMode.WRITE);
					var tempxml:String = "<?xml version=\"1.0\"?>\n";
					tempxml= tempxml +userdata.toXMLString();
					stream.writeUTFBytes(tempxml);
					stream.close();
					
					stream.open(sysdatafile, FileMode.WRITE);
					tempxml = "<?xml version=\"1.0\"?>\n";
					tempxml= tempxml + sysuserdata.toXMLString();
					stream.writeUTFBytes(tempxml);
					stream.close();
	 	}
	 	public function openfile():void{
	 			if(!datafile.exists){ // for the first time the app runs in a system, or the userdata files are deleted manually 
	 				var tempfile:File = File.applicationStorageDirectory.resolvePath("userdatas");
	 				tempfile.createDirectory();
	 				var userfiles:File = new File(tempfile.nativePath + "/userdata.xml");
	 				var appdir:File = File.applicationDirectory.resolvePath("userdatas/userdata.xml");
	 				appdir.copyTo(userfiles);
	 				datafile = userfiles;
	 				
	 				userfiles = new File(tempfile.nativePath + "/SystemUserData.xml");
	 				appdir = File.applicationDirectory.resolvePath("userdatas/SystemUserData.xml");
	 				appdir.copyTo(userfiles);
	 				sysdatafile = userfiles;
	 			}
	 			stream= new FileStream();
				stream.open(datafile, FileMode.READ);
				userdata = XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
				
				stream= new FileStream();
				stream.open(sysdatafile, FileMode.READ);
				sysuserdata = XML(stream.readUTFBytes(stream.bytesAvailable));
				stream.close();
				
				//for transition from version 1.0 to 2.0
				// can remove this after 2.0 release
				//if(sysuserdata.name().toString().match(/(system)/i) != null)
					sysuserdata.setName("user");
				
				var temp:File = File.applicationStorageDirectory.resolvePath("userdatas/SystemLog.txt");
				var tempstream:FileStream = new FileStream();
				tempstream.open(temp, FileMode.APPEND);
	  			logstream["System"]= tempstream;
				for each( var tempuser:XML in userdata.user){
	  					temp = File.applicationStorageDirectory.resolvePath("userdatas/log_" + tempuser.name + ".txt");
	  					tempstream = new FileStream();
	  					tempstream.open(temp, FileMode.APPEND);
	  					logstream[tempuser.name.toString()]= tempstream;
	  				}
	  			
				
	 	}
	 	
	 	public function closefile():void{
			stream= new FileStream();
			stream.open(datafile, FileMode.WRITE);
			var tempxml:String = "<?xml version=\"1.0\"?>\n";
			tempxml= tempxml +userdata.toXMLString();
			stream.writeUTFBytes(tempxml);
			stream.close();
			
			stream.open(sysdatafile, FileMode.WRITE);
			tempxml = "<?xml version=\"1.0\"?>\n";
			tempxml= tempxml + sysuserdata.toXMLString();
			stream.writeUTFBytes(tempxml);
			stream.close();
			
			stream= FileStream(logstream["System"]);
			stream.close();
			for each( var tempuser:XML in userdata.user){
				stream = FileStream(logstream[tempuser.name.toString()]);
	  			stream.close();
			}
			logstream.splice(0,logstream.length);
	 	}
	 	
	 	public function addtolist() :void{
		        
	  			if(!ctrlpressed && !shiftpressed){
	  				selecteduserlist= new Array();
	  				selecteduserlist.push(String(userdata.user[newIndex].name));
	  			}
	  			else if(shiftpressed && lastIndex!=newIndex){
	  				selecteduserlist = new Array();
	  				selecteduserlist.push(String(userdata.user[newIndex].name));
	  					for(var index:int = lastIndex; index>newIndex; index--){
	  						selecteduserlist.push(String(userdata.user[index].name));
	  					}
	  					for(index= lastIndex; index<newIndex; index++){
	  						selecteduserlist.push(String(userdata.user[index].name));
	  					}
	  			}
	  			else if (ctrlpressed){
	  				var userfound:int= -1;
	  				for(var i:int =0; i<selecteduserlist.length ; i++){
	  					if(user== selecteduserlist[i]){
	  						userfound=i;
	  						break;
	  					}
	  				}
	  				if(userfound>=0)
	  					selecteduserlist.splice(userfound,1);
	  				else
	  					selecteduserlist.push(String(userdata.user[newIndex].name));
	  			}
	  			if(!shiftpressed)
	  				lastIndex=newIndex;
	  	}
	  	
	 	
	 	public function getDate():String{
	 		var currentDate:Date = new Date();
	 		var dateFormatter:DateFormatter = new DateFormatter();
	 		dateFormatter.formatString = "MM/DD/YY LL:NN:SS A";
	 		var dateString:String = dateFormatter.format(currentDate);
	 		return dateString;
	 	}
	 	
	 	public function clearLog():void{
	 		closefile();  // closing the file-streams before clearing
	 		var logfile:File;
	 		var tempstream:FileStream =new FileStream();
			if(MyEventDispatcher.sysuserflag){
	 			logfile = File.applicationStorageDirectory.resolvePath("userdatas/SystemLog.txt");
	 			historyFile = File.applicationStorageDirectory.resolvePath("userdatas/SystemLog_history.txt");
	 		}
	 		else{
				logfile = File.applicationStorageDirectory.resolvePath("userdatas/log_" + selecteduserlist[0] + ".txt");
				historyFile = File.applicationStorageDirectory.resolvePath("userdatas/log_" + selecteduserlist[0] + "_history.txt");
	  		}
	  		//check if the log is blank
	  		tempstream.open(logfile, FileMode.READ);
			if(tempstream.bytesAvailable <= 0){
				tempstream.close();
				return;
			}
			tempstream.close();
	  		//saving a copy of the log before deleting
	  		if(historyFile.exists){
	  			historyFile.deleteFile();
	  		}
	  		logfile.copyTo(historyFile);
	  		
	  		if(wantToSaveLog){
	  			var saveFile:File;
	  			var currentDate:Date = new Date();
	 			var dateFormatter:DateFormatter = new DateFormatter();
	 			dateFormatter.formatString = "MM_DD_YY";
	 			var dateString:String = dateFormatter.format(currentDate);
	  			if(MyEventDispatcher.sysuserflag)
	  				saveFile = File.desktopDirectory.resolvePath("SystemLog[" + dateString + "].txt");
	  			else
	  				saveFile = File.desktopDirectory.resolvePath("log_" + selecteduserlist[0] + "[" + dateString + "].txt");
	  			saveFile.addEventListener(Event.SELECT, onBrowse); 
	  			saveFile.browseForSave("Select a location to save the log");
	  		}	  		
	  		//clearing the contents of the log 
	 		tempstream.open(logfile, FileMode.WRITE);
			tempstream.close();
	 		openfile();//reopeming the file-streams
	 	}
	 	
	 	private function onBrowse(e:Event):void{
	 		var saveFile:File = File(e.target);
	 		if(saveFile != null){
	  			if(saveFile.exists)
	  				saveFile.deleteFile();
	  			historyFile.copyTo(saveFile);
	  		}
	 	}
	 	
	 	public function transfer():void{
	 		var balance:Number = userdata.user.(name==userFrom).bal;
	 		userdata.user.(name==userFrom).bal=String(Math.round((balance-amount)*100)/100);
	  		logstream[userFrom].writeUTFBytes("\n" + getDate() +"     Debit : " + amount + " Balance = " + userdata.user.(name==userFrom).bal + " INR     Description : Transfer to " + userTo + " for : " + desc);
	  		
	  		balance = userdata.user.(name==userTo).bal;
	 		userdata.user.(name==userTo).bal=String(Math.round((balance+amount)*100)/100);
			logstream[userTo].writeUTFBytes("\n" + getDate() +"     Credit : " + amount + " Balance = " + userdata.user.(name==userTo).bal + " INR     Description : Transfer from " + userFrom + " for : " + desc);
	  		
	  		logstream.System.writeUTFBytes( "\n\n" + getDate() +"     Transfer: From : " + userFrom + "  To : " + userTo + "     Amount = " + amount + " INR     System Balance = " + sysuserdata.bal + " INR     Description : " + desc);
	  		logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + userFrom + "     Debit = " + amount + " INR     Balance = " + userdata.user.(name==userFrom).bal)+ " INR";
	  		logstream.System.writeUTFBytes("\n" + getDate() +"          User : " + userTo + "     Credit = " + amount + " INR     Balance = " + userdata.user.(name==userTo).bal)+ " INR";
	  		
	  		stream= new FileStream();
			stream.open(datafile, FileMode.WRITE);
			var tempxml:String = "<?xml version=\"1.0\"?>\n";
			tempxml= tempxml +userdata.toXMLString();
			stream.writeUTFBytes(tempxml);
			stream.close();
			
			stream.open(sysdatafile, FileMode.WRITE);
			tempxml = "<?xml version=\"1.0\"?>\n";
			tempxml= tempxml + sysuserdata.toXMLString();
			stream.writeUTFBytes(tempxml);
			stream.close();
	 	}
	 	
		public function MyEventDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}