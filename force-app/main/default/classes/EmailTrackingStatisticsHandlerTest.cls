@isTest
private class EmailTrackingStatisticsHandlerTest {

	private static testMethod void test() {
        test.startTest();
        List<wbsendit__Campaign_Activity__c> emailCampaignList = new List<wbsendit__Campaign_Activity__c>();
        
        Account testAccount = new Account(Name = 'test account');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'test Fname', LastName = 'test Lname', AccountId = testAccount.Id);
        insert testContact;
        
        wbsendit__Campaign_Activity__c emailCampaign1 = new wbsendit__Campaign_Activity__c();
        emailCampaign1.Name = 'Test';
        emailCampaign1.wbsendit__Contact__c = testContact.Id;
        emailCampaign1.wbsendit__Activity__c = 'Opened';
        emailCampaignList.add(emailCampaign1);
        
        
        wbsendit__Campaign_Activity__c emailCampaign2 = new wbsendit__Campaign_Activity__c();
        emailCampaign2.Name = 'Test';
        emailCampaign2.wbsendit__Contact__c = testContact.Id;
        emailCampaign2.wbsendit__Activity__c = 'Opened';
        emailCampaignList.add(emailCampaign2);
        
        insert emailCampaignList;
        
        List<TSGADX__Deal__c> dealList = [select Id, Prospect_Deal_Key__c from TSGADX__Deal__c where  Prospect_Deal_Key__c !=null];
        emailCampaignList.clear();
        emailCampaignList = [select Name from wbsendit__Campaign_Activity__c];
        
        if(!dealList.isEmpty() && !emailCampaignList.isEmpty()){
            string key = testContact.Id + emailCampaignList[0].Name;
            system.assertEquals( dealList[0].Prospect_Deal_Key__c, key);
        }
        
        emailCampaignList.clear();
        emailCampaignList = [select Id from wbsendit__Campaign_Activity__c];
        for(wbsendit__Campaign_Activity__c c :  emailCampaignList){
            c.Name = 'Test Mass';
            c.wbsendit__Activity__c = 'Clicked';
        }
        
        update emailCampaignList;
        
        delete emailCampaignList;
        
        unDelete emailCampaignList;
        test.stopTest();
	}

}