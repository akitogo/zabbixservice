/**
* 
*/
component  {
	host='';        // your Zabbix server ip goes here
	port='10051';	  
	
	ZabbixService function init(){
		return this;
	}

		
	/** 
	* Call this to log on Zabbix
  * for better performance put in thread
	*/  
	void function zabbixLogging(key,value){	
				data='{"request":"sender data",
			        "data":[{"host":"#host#","key":"#arguments.key#","value":"#arguments.value#"}]
					}';
				
				easySocket(host,port,data);
			}
	}
		
	/** 
	* Connect to sockets through your ColdFusion application.
	* original version by George Georgiou, see http://cflib.org/index.cfm?event=page.udfbyid&udfid=2001, Mods by Raymond Camden
	* Rewritten in CFscript by Akitogo
	* 
	* @param host 	 	Host to connect to. (Required)
	* @param port 		Port for connection. (Required)
	* @param message 	Message to be sent. (Required)
	* @return Returns a string. 
	* @author Akitogo Team 
	* @version 1.1, November 28, 2013 
	* 
	* @hint "Uses Java Sockets to connect to a remote socket over TCP/IP" 
	*
	*/
	string function easySocket(
		required string host='localhost'
		,required numeric port='8080'
		,required string message='') 
		output="false" {
	
	    var result = "";
	    var socket = createObject( "java", "java.net.Socket" );
	    var streamOut = "";
		var output = "";
		var input = "";
		
		// get right newline char for os
		var newline = CreateObject("java", "java.lang.System").getProperty("line.separator");
	
		try{
			socket.init(arguments.host,arguments.port);
		}catch(Object e){
			throw("Init socket failed to host #arguments.host#, port #arguments.port#.");
		}
	
		if (socket.isConnected()){
			streamOut = socket.getOutputStream();
	       
	        output = createObject("java", "java.io.PrintWriter").init(streamOut);
	        streamInput = socket.getInputStream();
	       
	        inputStreamReader= createObject( "java", "java.io.InputStreamReader").init(streamInput);
	        input = createObject( "java", "java.io.BufferedReader").init(InputStreamReader);
	        
	        output.println(arguments.message);
	        output.println(); 
	        output.flush();
	        
	        // return can be multi line
	        line = input.readLine();
	        while(structKeyExists( variables, 'line' )){
		        result=result&newline&line;
	        	line=input.readLine();
	        }
	        socket.close();
		}else{
			throw("Could not connected to host #arguments.host#, port #arguments.port#.");
		}
		return result;
	}		
}
