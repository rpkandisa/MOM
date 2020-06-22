trigger taskTrigger on Task (before insert, before update) {

    TSGADX__ADX_Settings__c settings = TSGADX__ADX_Settings__c.getOrgDefaults();
    taskTriggerHandler TriggerHandler = new taskTriggerHandler();
    
       if(settings.Enable_Task_Trigger__c || Test.isRunningTest()){
       
           if(Trigger.IsBefore && Trigger.IsInsert){
           
               
               TriggerHandler.populateCustomFields(Trigger.New, null, Trigger.Isupdate);             
           
           }
           else
               
               if(Trigger.IsBefore && Trigger.Isupdate)
                   {
                       TriggerHandler.populateCustomFields(Trigger.New, trigger.oldmap, Trigger.Isupdate);  
                   
                   }
   
       }

}