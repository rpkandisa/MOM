/*
    trigger for updating the deals field on changing the qty on qli
*/
trigger qliTrigger on TSGCFG__Quote_Line_Items__c (after insert, after update, before delete) {
    if(trigger.isAfter && trigger.isUpdate && dealLineItemHelper.Execute_dealLineItemHelper)
        dealLineItemHelper.updateDealOnQuantityUpdate(trigger.newMap, trigger.oldMap);
    if(trigger.isBefore && trigger.isDelete && dealLineItemHelper.Execute_dealLineItemHelper)
        dealLineItemHelper.updateDealOnQliDelete(trigger.oldMap); 
        
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate) && QuoteLineItemHandler.Execute_QuoteLineItemHandler) {
        QuoteLineItemHandler.UpateCPCFixRateCharge(trigger.new, trigger.OldMap);
    }
}