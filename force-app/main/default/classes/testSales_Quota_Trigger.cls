@isTest(seeAlldata = false)
public class testSales_Quota_Trigger{

    public testmethod static void  Test(){
    
    
    Sales_Quota__c s = new Sales_Quota__c(Rep_Name__c=userinfo.getuserid(), Year__c = '2018', Name= 'Test');
    
    insert s;
    
    
    }
       
    }