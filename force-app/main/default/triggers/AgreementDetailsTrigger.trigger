trigger AgreementDetailsTrigger on Agreement_Detail__c (after insert, after update) {
    
    EA_Settings__c eaSett = EA_Settings__c.getInstance();
    
	 if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
         if(eaSett.Enable_Agreement_Details_Delete__c ){ 
         	AgreementDetailsHandler.deleteAgreementDetail(trigger.new);
         }
    }
}