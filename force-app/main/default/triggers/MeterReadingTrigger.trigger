/*
  Created by Kandisa Technologies
  Date: 2nd November
*/
trigger MeterReadingTrigger on Meter_Reading__c (before insert) {
    
    EA_Settings__c eaSett = EA_Settings__c.getInstance();

    if(trigger.isBefore && trigger.isInsert){
      // Run Trigger only if Custom Setting is enabled. 
      if(eaSett.Enable_Mark_Latest_Meter_Reading_Trigger__c)
          MeterReadingsHelper.updateIsLatest(trigger.new);
    }
}