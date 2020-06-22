@isTest
public class EAUpdateAlertTest{

    public static testMethod void testEmails(){
        TSGADX__ADX_Settings__c sett = TSGADX__ADX_Settings__c.getInstance();
        sett.TSGADX__EA_Alerts__c = true;
        upsert sett;
    
        Account acc = new Account(Name='Test', Type='Customer', EA_CustomerId__c='0000');
        insert acc;
        Account acc2 = [Select Id, Name from Account where EA_CustomerId__c='0000' Limit 1];
        acc2.Name='Test2';
        update acc2;
        
        Contact con = new Contact(LastName='Test', AccountId=acc2.Id, EA_ContactId__c='000');
        insert con;
        Contact con2 = [Select Id, LastName, AccountId, TSGADX__Business_Type__c, EA_ContactId__c from Contact where LastName='Test' Limit 1];
        con2.LastName='Test2';
        System.debug('AccountId: ' + con2.AccountId);
        System.debug('Business Type: ' + con2.TSGADX__Business_Type__c);
        update con2;
    }
    

}