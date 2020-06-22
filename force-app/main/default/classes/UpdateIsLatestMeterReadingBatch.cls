/*
  Created by Kandisa Technologies
  Description: Batch Class to update Is Latest for all equipments.

  Code to Execute the batch in Developer Console or Apex Execute
  *****
    
  // Initialize Class
  UpdateIsLatestMeterReadingBatch batchClass = new UpdateIsLatestMeterReadingBatch();

  // Add the query to select equipments for which Meter Reading needs to be updated. If you want for all, comment the below line
  batchClass.query = 'Select Id from TSGADX__Equipment__c where CreatedDate = THIS_YEAR'

  // Execute the Batch; 200 is batchsize. You can reduce it if you want.
  Id batchId = Database.executeBatch(batchClass, 200);

  *****

*/
global class UpdateIsLatestMeterReadingBatch implements Database.Batchable<sObject> {
  
  String query;
  
  global UpdateIsLatestMeterReadingBatch() {
    query = 'Select Id from TSGADX__Equipment__c';
  }
  
  global Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(query);
  }

     global void execute(Database.BatchableContext BC, List<TSGADX__Equipment__c> scope) {
    Set<Id> equipmentIds = new Set<Id>();
    for(TSGADX__Equipment__c equipment : scope) {
      equipmentIds.add(equipment.Id);
    }

    MeterReadingsHelper.updateExistingIsLatest(equipmentIds);
  }
  
  global void finish(Database.BatchableContext BC) {
    
  }
}