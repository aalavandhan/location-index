(function(){

  var app = angular.module("rtBase.services")

  app.factory("rtXhrStateHandler", [ "$window", function( $window ){

      function Handler(){
        
        var instance = { }
        /*
         * Private state. Not made available outside
         * the scope
         */
           ,states = [
              { message : ""         }
             ,{ message : "Working"  }
             ,{ message : "Complete" }
             ,{ message : "Success"  }
             ,{ message : "Error"    }
             ,{ message : "Fatal"    } 
            ]
           ,currentState = states[ 0 ];
        
        function setAPIProperties(){
          
          instance.message    = currentState.message;

          instance.isIdle     = ( currentState == states[0] );
          instance.isWorking  = ( currentState == states[1] );
          instance.isComplete = ( currentState == states[2] );
          instance.isSuccess  = ( currentState == states[3] );
          instance.isError    = ( currentState == states[4] );
          instance.isFatal    = ( currentState == states[5] ); 
        }
        /*
         * Public state
         */
        instance.setAllMessages = function(messages){
           for( var i = 0; i < states.length; i++ ){
             
             if(!messages[i]){
               messages[i] = ""
             };
             
             states[i].message = messages[i]
           }
        };

         instance.setMessageForState = function(n,message){
           if(states[n]){
             states[n]["message"] = message
           }
         }

         instance.reset = function(){
           instance.idle();
         }

         instance.idle = function(){
           currentState = states[ 0 ]
           setAPIProperties()
         }
         instance.initiate = function(){
           currentState = states[ 1 ]
           setAPIProperties()
         }

         instance.complete = function(){
           currentState = states[ 2 ]
           setAPIProperties()
         }

         instance.success = function(){
           currentState = states[ 3 ]
           setAPIProperties()
         }

         //set this when some known error occurs
         //like validation failure
         instance.error = function(){
           currentState = states[ 4 ]
           setAPIProperties()
         }

         //set this when the server is unavailable
         //or some exception occured on the 
         //sever side
         instance.fatal = function(showAlert){
           currentState = states[ 5 ]
           setAPIProperties()
           if(showAlert)
             $window
               .alert("An unexpected error occurred while processing this request. Please refresh the page and try again.")
         }
         
         return instance
      }

      Handler.getInstance = function(){
        var ins = new Handler()
        ins.idle()
        return ins
      }

      return Handler

    }

  ])

}());