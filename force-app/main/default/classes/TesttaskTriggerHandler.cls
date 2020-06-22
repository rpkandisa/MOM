@istest
public class TesttaskTriggerHandler
{
    static testmethod void TestTask()
    {

        Account acct = new Account(Name = 'ABC123 Company',billingcity='Gahana', billingstreet='2 Easton Oval', billingstate='OH',  billingpostalcode='43230', Billingcountry='US');
        insert acct;
        
        List<Contact> lstContact = new List<Contact>();
        contact cont = new contact(Accountid = Acct.id, LastName = 'Test', Email = 'test@test.com');
        lstContact.add( cont);
        
        contact cont2 = new contact(Accountid = Acct.id, LastName = 'Test2', Email = 'test2@test.com');
        lstContact.add( cont2);
        insert lstContact;
        
        
        
       /* TSGADX__ADX_Settings__c settings = TSGADX__ADX_Settings__c.getOrgDefaults();
        settings.Enable_Task_Trigger__c=true;
        upsert settings TSGADX__ADX_Settings__c.Id; */

        Task t = new Task( Subject = 'Test', Whoid = cont.id, Whatid = acct.id, Status = 'Completed', Type = '*RT BTR Survey Request - 0', Priority = 'Normal', Description = 'Test');
        insert t;
        
        
        t.whoId= cont2.id;
        update t; 
    }
}