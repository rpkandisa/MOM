trigger QuoteTrigger on TSGCFG__Quote__c (after update) {
    QuoteTriggerHandler.CreateCPCFixRateCharge(Trigger.New, Trigger.OldMap);
}