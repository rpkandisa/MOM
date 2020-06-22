/*
    Description: Test class for Update Fix Rate Multiplier
*/
@isTest
public with sharing class UpdateFixRateMultiplierTest {
    
    static testmethod void TestUpdateFixRateMultiplier() {
        Account acc = new Account(Name = 'testAccount');
        insert acc;
        
        TSGADX__Deal__c deal = new TSGADX__Deal__c(Name = 'testDeal1', TSGADX__Type__c = 'CTI', TSGADX__Deal_Assignment__c = 'Order/Installer',
                                                    TSGADX__Company__c = acc.id,TSGADX__Price__c = 200 ,TSGADX__Product_Service__c = 'Test deal record',
                                                    TSGADX__Close_Date__c = system.today());
        insert deal;
        
        TSGCFG__Quote__c quote = new TSGCFG__Quote__c(TSGCFG__Deal__c = deal.id, TSGCFG__Primary__c= false,TSGCFG__Price_Book__c = 'Standard',Fixed_Rate__c = '10%',Fixed_Rate_Term__c = '3');
        insert quote;
        
        apexpages.currentpage().getparameters().put('id',quote.id);
        UpdateFixRateMultiplier updatefrm = new UpdateFixRateMultiplier(new Apexpages.standardcontroller(quote));
        updatefrm.QuoteSave();
        updatefrm.BackToConfigurator();
        
    }
    
}