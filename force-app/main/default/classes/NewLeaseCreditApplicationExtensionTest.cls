@isTest
private class NewLeaseCreditApplicationExtensionTest {
    
    
    @isTest static void newLeaseCreditTest(){
        TSGADX__ADX_Settings__c setting = TSGADX__ADX_Settings__c.getOrgDefaults();
        setting.TSGADX__Validation_Rules__c = false;
        setting.TSGADX__Enable_AP_Rule_Triggers__c = false;
        INSERT setting;
        
        
        Account acc = new Account(
        Name = 'Abc cop', 
        Territory_Type__c ='Named Account',
        BillingStreet = 'saSA',
        BillingCity = 'asaS',
        BillingState = 'asas',
        BillingPostalCode = '12345',
        NAICS_Duns_Number__c = 'Ssasa'
        );
        
        INSERT acc;
        
        Lease_Credit_Application__c app = new Lease_Credit_Application__c();
        app.City__c = 'Bangalore'; 
        app.Current_Status__c = 'Pre-Approval';
        app.Phone__c = '(111) 121-1234';
        app.State__c = 'MD';
        app.Zip__c = '12346';
        app.Account__c = acc.Id;
        app.Address__c = 'AsAsaSas';
        app.Contact_First_Name__c = 'asaSAs';
        app.Contact_Last_Name__c = 'aSasas';
        app.Term__c = 5;
        //Deal__c = '';
		//INSERT app;
        
        
        TSGADX__Deal__c d = new TSGADX__Deal__c(Name = 'Test Lease Credit' + ' - Deal1',                             
                TSGADX__Company__c = acc.Id, 
                TSGADX__Sales_Stage__c = 'Prospect');                                     
        insert d;
 
        
        ApexPages.StandardController sc = new ApexPages.StandardController(d);
        NewLeaseCreditApplicationExtension testPlan = new NewLeaseCreditApplicationExtension(sc);
        
        PageReference pageRef = Page.NewLeaseCreditApplication;
        pageRef.getParameters().put('id', String.valueOf(d.Id));
        Test.setCurrentPage(pageRef);
    }
    
}