@isTest
private class TestEqMakesModels {

    static testMethod void testMe(){
        EA_Settings__c sett = EA_Settings__c.getInstance();
        sett.Enable_EQMakesModels__c = true;
        upsert sett;
        
        Account acc = new Account(Name='Test');
        insert acc;
        acc = [Select Id, Name from Account where Name = 'Test'];
        TSGADX__Equipment__c eq = new TSGADX__Equipment__c(TSGADX__Business__c = acc.id, TSGADX__Make__c = 'Allied', TSGADX__Model__c = 'A');
        TSGADX__Equipment__c eq1 = new TSGADX__Equipment__c(TSGADX__Business__c = acc.id, TSGADX__Make__c = 'Allied1', TSGADX__Model__c = 'B');
        list<TSGADX__Equipment__c> eqList = new list<TSGADX__Equipment__c>{eq,eq1};
        insert eqList;
        update eq;
        delete eq;
    }
}