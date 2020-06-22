/* test class for qliTriggerHelper */
@isTest(seeAllData = false)
public with sharing class testQliTrigger {
    public static testmethod void testQli (){
        // Test Data
        TSGCFG__Price_Book_Field_Setting__c pricebookFieldSetting = new TSGCFG__Price_Book_Field_Setting__c(
                        Name = 'Standard', 
                        TSGCFG__Active_Price_Field_API_Name__c = 'TSGCFG__Price_Level_1_Active__c', 
                        TSGCFG__Cost_Price_Field_API_Name__c = 'TSGCFG__Cost_Price_Level_1__c', 
                        TSGCFG__Sales_Price_Field_API_Name__c = 'TSGCFG__Sales_Price_Level_1__c');
                
        insert pricebookFieldSetting;
        Account acc = new Account(Name = 'testAccount');
        insert acc;
           
        // Create Price Book
   
        TSGCFG__Price_Book__c product = new TSGCFG__Price_Book__c(Name = 'Product1',RecordTypeId = Schema.SObjectType.TSGCFG__Price_Book__c.getRecordTypeInfosByName().get('Model').getRecordTypeId() ,TSGCFG__Cost_Price_Level_1__c = 100,
        TSGCFG__Cost_Price_Level_2__c = 110,
        TSGCFG__Cost_Price_Level_3__c = 150,
        TSGCFG__Sales_Price_Level_1__c = 110,
        TSGCFG__Sales_Price_Level_2__c = 120,
        TSGCFG__Sales_Price__c = 100,
        TSGCFG__Sales_Price_Level_3__c = 160 , 
        TSGCFG__Product_Code__c ='pb001', 
        TSGCFG__Active__c = true, 
        TSGCFG__Price_Level_1_Active__c = true,
        TSGCFG__Price_Level_10_Active__c = true);
                    
        insert product;
    
        // create deal
        TSGADX__Deal__c deal = new TSGADX__Deal__c(Name = 'testDeal3', TSGADX__Type__c = 'CTI', TSGADX__Deal_Assignment__c = 'Order/Installer', 
                                                    TSGADX__Company__c = acc.id,TSGADX__Price__c = 250 ,TSGADX__Product_Service__c = 'Test deal record',
                                                    TSGADX__Close_Date__c = system.today(),TSGCFG__Price_Book__c ='Standard');
        insert deal;
        // create quote
        TSGCFG__Quote__c quote = new TSGCFG__Quote__c(TSGCFG__Deal__c = deal.id, TSGCFG__Primary__c= false, TSGCFG__Price_Book__c = 'Standard');
        insert quote;       
               
   
        TSGCFG__Configuration__c config = new TSGCFG__Configuration__c(Name = 'Test Config',TSGCFG__Quote__c =quote.id, TSGCFG__Total_Price__c= 200); 
        insert config;
           
    
        TSGCFG__Quote_Line_Items__c qli = new TSGCFG__Quote_Line_Items__c(
            TSGCFG__Quote__c = quote.id, 
            TSGCFG__Qty__c= 1, 
            TSGCFG__Product__c = product.Id,
            TSGCFG__Configuration__c = config.Id,
            TSGCFG__Sales_Price__c = 100,
            TSGCFG__Sales_Uplift__c = 25);

        insert qli;

        // test start
        test.startTest();
        TSGCFG__Quote_Line_Items__c updateQli = [select TSGCFG__Qty__c from TSGCFG__Quote_Line_Items__c where id = : qli.id];
        updateQli.TSGCFG__Qty__c = 3;
        
        update updateQli;
        delete updateQli;
        test.stopTest();
        // test stop
        
    }
}