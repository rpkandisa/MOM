/*
    Description: test class for QuoteTriggerHandler
*/
@isTest
public with sharing class QuoteTriggerHandlerTest {
    
    static testmethod void TestFixRateMultiplier(){
        Account acc = new Account(Name = 'testAccount');
        insert acc;
        
        TSGADX__Deal__c deal = new TSGADX__Deal__c(Name = 'testDeal1', TSGADX__Type__c = 'CTI', TSGADX__Deal_Assignment__c = 'Order/Installer',
                                                    TSGADX__Company__c = acc.id,TSGADX__Price__c = 200 ,TSGADX__Product_Service__c = 'Test deal record',
                                                    TSGADX__Close_Date__c = system.today());
        insert deal;
        
        TSGCFG__Price_Book_Field_Setting__c pricebookFieldSetting1 = new TSGCFG__Price_Book_Field_Setting__c(Name = 'Standard', 
                                                                                                TSGCFG__Active_Price_Field_API_Name__c = 'Price_Level_1_Active__c', 
                                                                                                TSGCFG__Cost_Price_Field_API_Name__c = 'Cost_Price_Level_1__c', 
                                                                                                TSGCFG__Sales_Price_Field_API_Name__c = 'Sales_Price_Level_1__c');
                
        insert pricebookFieldSetting1;
        
        string RecordTypeId = Schema.SObjectType.TSGCFG__Price_Book__c.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        TSGCFG__Price_Book__c pb = new TSGCFG__Price_Book__c(Name = 'CPC Fix Rate Charge', RecordTypeID = RecordTypeId , TSGCFG__Sales_Price__c = 110, TSGCFG__Product_Code__c = 'pb001', TSGCFG__Active__c = true, 
                                            TSGCFG__Price_Level_1_Active__c = true, TSGCFG__Sales_Price_Level_1__c = 300, TSGCFG__Cost_Price_Level_1__c = 300, TSGCFG__Printing_Segment__c = '1',
                                            TSGCFG__Price_Level_2_Active__c = true, TSGCFG__Sales_Price_Level_2__c = 300, TSGCFG__Cost_Price_Level_2__c = 300);
        
        insert pb;
        
        TSGCFG__Price_Book__c pb1 = new TSGCFG__Price_Book__c(Name = 'CPC Service', RecordTypeID = RecordTypeId , TSGCFG__Sales_Price__c = 110, TSGCFG__Product_Code__c = 'CP1', TSGCFG__Active__c = true, 
                                            TSGCFG__Price_Level_1_Active__c = true, TSGCFG__Sales_Price_Level_1__c = 300, TSGCFG__Cost_Price_Level_1__c = 300, TSGCFG__Printing_Segment__c = '1',
                                            TSGCFG__Price_Level_2_Active__c = true, TSGCFG__Sales_Price_Level_2__c = 300, TSGCFG__Cost_Price_Level_2__c = 300);
        
        insert pb1;
        
        TSGCFG__Quote__c quote = new TSGCFG__Quote__c(TSGCFG__Deal__c = deal.id, TSGCFG__Primary__c= false,TSGCFG__Price_Book__c = 'Standard',Fixed_Rate__c = '10%',Fixed_Rate_Term__c = '3');
        insert quote;
        
        TSGCFG__Configuration__c config = new TSGCFG__Configuration__c(Name = 'Test Config',TSGCFG__Quote__c = quote.id, TSGCFG__Total_Price__c= 200);
        insert config;
        
        TSGCFG__Quote_Line_Items__c qli = new TSGCFG__Quote_Line_Items__c(TSGCFG__Quote__c = quote.id,TSGCFG__Price__c = 10, TSGCFG__Qty__c= 2, TSGCFG__Product__c = pb1.Id,TSGCFG__Total_Quantity__c=2,
                    TSGCFG__Configuration__c = config.Id);
        TSGCFG.QuoteLineItemHelper.DO_QLI_CALCULATION = false;
        TSGCFG.QuoteLineItemHelper.VERIFY_SALES_PRICE_CHANGE = false;
        insert qli;
                
        quote.Fixed_Rate__c = '5% (Gov. Only)';
        quote.Fixed_Rate_Term__c = '3';
        update quote;
        
        qli.TSGCFG__Total_Price__c = 250;
        update qli;
        
        quote.Fixed_Rate__c = '';
        quote.Fixed_Rate_Term__c = '';
        update quote;
        
        
    }
}