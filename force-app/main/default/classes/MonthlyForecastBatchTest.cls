@isTest
public with sharing class MonthlyForecastBatchTest {
	static testmethod void ValidateMonthlyForecast(){
		Sales_Team_Setting__c sts = new Sales_Team_Setting__c();
		sts.Forecast_Category__c = 'Probable';
		sts.Sales_Team__c = 'Cincinnati;Major Accounts;MOM Columbus;DocSol;MOM Dayton;MOM Canon';
		insert sts;

		Sales_Quota__c objSQ = new Sales_Quota__c();
        objSQ.IT_Services__c = 50000;
        objSQ.MPS__c = 45000;
        objSQ.Production__c = 75000;
        objSQ.Equipment__c = 45000;
        objSQ.Rep_Name__c = UserInfo.getUserId();
        objSQ.Year__c = string.valueof(system.today().year());
        objSQ.Quarter__c  = 'Q1';
        insert objSQ;
        
        Account objAcc = new Account();
        objAcc.Name = 'Test Account';
        objAcc.Territory_Type__c = 'Named Account';
        insert objAcc;
        
        Contact objCon = new Contact();
        objCon.FirstName = 'FName';
        objCon.LastName = 'LName';
        insert objCon;
        
        List<TSGADX__Deal__c> lstDealsToInsert = new List<TSGADX__Deal__c>();
        
        TSGADX__Deal__c objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 1';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Equipment Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        insert objDeal;

		objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 1.1';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Equipment Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        insert objDeal;

		objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Production Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        objDeal.VP_Forecast__c = true;
        insert objDeal;

		objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3.1';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Production Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        objDeal.VP_Forecast__c = true;
        insert objDeal;

		objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 2';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('MPS Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        insert objDeal;

		objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 2.1';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('MPS Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today();
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        insert objDeal;

		Test.startTest(); 

		MonthlyForecastBatchHelper.callMonthlyForecastBatch();

		MonthlyForecastBatch mfbatch = new MonthlyForecastBatch(MonthlyForecastBatchHelper.findAllMonthlyDealRecords(), new list<string>()); 
		Database.executeBatch(mfbatch,100); 

		MonthlyForecastBatchHelper.forecastRevenueProcess(Database.query(MonthlyForecastBatchHelper.findAllMonthlyDealRecords()));

		MonthlyForecastBatchSchedulable sh1 = new MonthlyForecastBatchSchedulable();
		String sch = '0 0 23 * * ?'; 
		system.schedule('Test MonthlyForecastBatch', sch, sh1); 		

		Test.stopTest();
	}
}