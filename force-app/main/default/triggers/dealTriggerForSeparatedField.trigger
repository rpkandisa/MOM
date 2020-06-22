/*
	Trigger to populate models name from quoteLineItems on deal's hidden field
*/
trigger dealTriggerForSeparatedField on TSGADX__Deal__c (after update) {
	if(trigger.isAfter && trigger.isUpdate && dealHelperForCommaSeparatedField.Execute_dealHelperForCommaSeparatedField){
		dealHelperForCommaSeparatedField.updateDealOnUpdate(trigger.newMap, trigger.oldMap); 
	}
}