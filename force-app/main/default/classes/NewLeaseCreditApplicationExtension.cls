public with sharing class NewLeaseCreditApplicationExtension {
    public Account account{get; set;}
    
    public NewLeaseCreditApplicationExtension(ApexPages.StandardController stdController) {
        TSGADX__Deal__c deal = (TSGADX__Deal__c)stdController.getRecord();
        
        List<Account> accountList = [SELECT Id, Name, BillingStreet, BillingCity, BillingState, 
                                     BillingPostalCode, Phone FROM Account WHERE Id =: deal.TSGADX__Company__c LIMIT 1];
        if(!accountList.isEmpty()){
            account = accountList.get(0);
        }
    }
}