@isTest
public class AgreementDetailsHandlerTestClass {
    static testMethod void insertAgreementDetail(){
        
        // Define Custom Setting
        EA_Settings__c eaSett = EA_Settings__c.getInstance();

        if(eaSett == null) {
            eaSett = new EA_Settings__c();
        }
        eaSett.Enable_Agreement_Details_Delete__c = true;
        upsert eaSett;
        
        Account acc = new Account(Name = 'TestAcc');
        insert acc;
        
        //Create Agreement Record
        TSGADX__Agreements__c agreement = new TSGADX__Agreements__c(TSGADX__Leased_Amount__c = 1200);
        insert agreement;
        
        TSGADX__Equipment__c equip = new TSGADX__Equipment__c (RecordTypeId = '012A0000000scSEIAY',TSGADX__Business__c = acc.Id);
        insert equip;
        
        //Create AgreementDetail Record
        Agreement_Detail__c agrmntDetl = new Agreement_Detail__c(Agreement__c = agreement.Id,Equipment__c = equip.Id,EA_Delete_Agreement_Detail__c = false);
        insert agrmntDetl;
        
        Test.startTest();
        
        agrmntDetl.EA_Delete_Agreement_Detail__c = true;
        update agrmntDetl;
        
        Test.stopTest();
    }
}