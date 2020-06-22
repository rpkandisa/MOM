/*
	test class to cover dealTriggerForSeparatedField trigger and dealHelperForCommaSeparatedField
*/
@isTest(SeeAllData = false) 
public class test_dealTriggerForSeparatedField {
	// Create Account
    private Static Account acc {
        get {
            if(acc == null) {
                acc = new Account(Name = 'testAccount');
                insert acc;
            }
            return acc;
        }
    }
    // Create Price Book
    private Static List<TSGCFG__Price_Book__c> pbList {
        get {
            if(pbList == null) {
                pbList = new List<TSGCFG__Price_Book__c>{ 
                    new TSGCFG__Price_Book__c(Name = 'Product1',RecordTypeId = Schema.SObjectType.TSGCFG__Price_Book__c.getRecordTypeInfosByName().get('Model').getRecordTypeId() ,TSGCFG__Cost_Price_Level_1__c = 100,TSGCFG__Cost_Price_Level_2__c = 110 ,TSGCFG__Cost_Price_Level_3__c = 150,
                                                TSGCFG__Sales_Price_Level_1__c = 110,TSGCFG__Sales_Price_Level_2__c = 120 ,
                                                TSGCFG__Sales_Price_Level_3__c = 160 , TSGCFG__Product_Code__c ='pb001', TSGCFG__Active__c = true),
                    new TSGCFG__Price_Book__c(Name = 'Product2',RecordTypeId = Schema.SObjectType.TSGCFG__Price_Book__c.getRecordTypeInfosByName().get('Model').getRecordTypeId(),TSGCFG__Cost_Price_Level_1__c = 200 ,TSGCFG__Cost_Price_Level_2__c = 150,
                                            TSGCFG__Cost_Price_Level_3__c = 200, TSGCFG__Sales_Price_Level_1__c = 220 ,
                                            TSGCFG__Sales_Price_Level_2__c = 170 ,TSGCFG__Sales_Price_Level_3__c = 205 ,TSGCFG__Product_Code__c ='pb002',TSGCFG__Active__c = true),
                    new TSGCFG__Price_Book__c(Name = 'Product3',RecordTypeId = Schema.SObjectType.TSGCFG__Price_Book__c.getRecordTypeInfosByName().get('Model').getRecordTypeId(),TSGCFG__Cost_Price_Level_1__c = 110 ,TSGCFG__Cost_Price_Level_2__c = 120 ,TSGCFG__Cost_Price_Level_3__c = 90,
                                                TSGCFG__Sales_Price_Level_1__c = 115 ,TSGCFG__Sales_Price_Level_2__c = 130 ,
                                                TSGCFG__Sales_Price_Level_3__c = 100 ,TSGCFG__Product_Code__c ='pb003', TSGCFG__Active__c = true)
                    
                };
                insert pbList;
            }
            return pbList;
        }
    }
    
    //Create Deal
    private Static TSGADX__Deal__c dlList {
        get{
            if(dlList == null) {
                dlList = new TSGADX__Deal__c(Name = 'testDeal3', TSGADX__Type__c = 'CTI', TSGADX__Deal_Assignment__c = 'Order/Installer', 
                                                    TSGADX__Company__c = acc.id,TSGADX__Price__c = 250 ,TSGADX__Product_Service__c = 'Test deal record',
                                                    TSGADX__Close_Date__c = system.today(),TSGCFG__Price_Book__c ='Standard');
                    
                
                insert dlList;
            }
            return dlList;
        }
    }
    
    
    //Create Quote
    private Static List<TSGCFG__Quote__c> qtList {
        get{
            if(qtList == null){
                qtList = new List<TSGCFG__Quote__c>{
                    new TSGCFG__Quote__c(TSGCFG__Deal__c = dlList.id, TSGCFG__Primary__c= false),
                    new TSGCFG__Quote__c(TSGCFG__Deal__c = dlList.id, TSGCFG__Primary__c= false),
                    new TSGCFG__Quote__c(TSGCFG__Deal__c = dlList.id, TSGCFG__Primary__c= true)
                };
                insert qtList;
            }
            return qtList;
        }
    }
    private Static TSGCFG__Configuration__c config {
        get {
            if(config == null) {
                config = new TSGCFG__Configuration__c(Name = 'Test Config',TSGCFG__Quote__c =qtList[0].id, TSGCFG__Total_Price__c= 200); 
                insert config;
            }
            return config;
        }
    }
    //Create Quote Line Items
    private Static List<TSGCFG__Quote_Line_Items__c> qtLnItmsLst {
        get{
            if(qtLnItmsLst == null){
                qtLnItmsLst = new List<TSGCFG__Quote_Line_Items__c>{
                    new TSGCFG__Quote_Line_Items__c(TSGCFG__Quote__c = qtList[0].id, TSGCFG__Qty__c= 2, TSGCFG__Product__c = pbList[0].Id,TSGCFG__Configuration__c = config.Id,TSGCFG__Cost__c = 20),
                    new TSGCFG__Quote_Line_Items__c(TSGCFG__Quote__c = qtList[2].id, TSGCFG__Qty__c= 1, TSGCFG__Product__c = pbList[1].Id,TSGCFG__Configuration__c = config.Id),
                    new TSGCFG__Quote_Line_Items__c(TSGCFG__Quote__c = qtList[1].id, TSGCFG__Qty__c= 1, TSGCFG__Product__c = pbList[2].Id,TSGCFG__Configuration__c = config.Id)
                };
                try{
                insert qtLnItmsLst;
                } catch(Exception e){System.debug(e);}
            }
            return qtLnItmsLst;
        }
    }
    
	// test method
	public static testMethod void dealTrigger() {
		system.assertEquals(3,qtLnItmsLst.size());
		system.assertEquals(3,qtList.size());
		system.assertEquals(3,pbList.size());
		list<TSGCFG__Quote__c> quoteList = new list<TSGCFG__Quote__c>();
		list<TSGCFG__Quote_Line_Items__c> qliList = new list<TSGCFG__Quote_Line_Items__c>();
		id quoteId;
		system.debug(dlList);
		for(TSGCFG__Quote__c quote : [select TSGCFG__Primary__c from TSGCFG__Quote__c where TSGCFG__Deal__c =: dlList.id]){
			if(!quote.TSGCFG__Primary__c){
				system.debug(quote);
				quote.TSGCFG__Primary__c = true;
				quoteList.add(quote);
				quoteId = quote.id;
				break;
			}
		}
		test.startTest();
		dealHelperForCommaSeparatedField.Execute_dealHelperForCommaSeparatedField = true;
		update quoteList;
		
		test.stopTest();
	}
}