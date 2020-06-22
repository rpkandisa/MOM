/*
    Description: Test class for SalesReviewReportController1
*/
@isTest
public with sharing class SalesReviewReportController1Test {
    
    static testmethod void TestSalesForecast(){
        
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
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 2';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('IT Services').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('MPS Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Production Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        objDeal.VP_Forecast__c = true;
        lstDealsToInsert.add(objDeal);
        
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
        objDeal.TSGADX__Won__c = true;
        objDeal.Manager_Forecast__c = true;
        
        lstDealsToInsert.add(objDeal);

        insert lstDealsToInsert;
        
        SalesReviewReportController1 objSRR = new SalesReviewReportController1();
        objSRR.objSalesQuote.BEQI__c = 7400;
        objSRR.UpdateQuotas();
        
        for(TSGADX__Deal__c objDealU: lstDealsToInsert){
            objDealU.TSGADX__Replacement_Date__c = system.today().addYears(1);
            objDealU.TSGADX__Proposal_Date__c = system.today().addMonths(1);
            objDealU.TSGADX__Sales_Stage__c = 'Won';
        }
        
        update lstDealsToInsert;
        
        Test.startTest();
        
        objSRR = new SalesReviewReportController1();
        objSRR.strSelectedQuarter = '1';
        objSRR.SalesViewByRep();
        //objSRR.strSelectedQuarter = '2';
        //objSRR.SalesViewByRep();
        //objSRR.strSelectedQuarter = '3';
        //objSRR.SalesViewByRep();
       // objSRR.strSelectedQuarter = '4';
      //  objSRR.SalesViewByRep();
            
        objSRR.printSalesReport();

        Test.stopTest();
        
    }

    static testmethod void TestSalesForecast2(){
        
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
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 2';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('IT Services').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('MPS Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        lstDealsToInsert.add(objDeal);
        
        objDeal = new TSGADX__Deal__c();
        objDeal.Name = 'Test Deal 3';
        objDeal.TSGADX__Company__c = objAcc.Id;
        objDeal.TSGADX__Type__c = 'New Placement';
        objDeal.TSGADX__Product_Service__c = 'Product';
        objDeal.TSGADX__Main_Contact__c = objCon.Id;
        objDeal.TSGADX__Price__c = 5000;
        objDeal.TSGADX__MPS_Revenue__c = 7500;
        objDeal.RecordTypeId = Schema.SObjectType.TSGADX__Deal__c.getRecordTypeInfosByName().get('Production Deals').getRecordTypeId();
        objDeal.TSGADX__Close_Date__c = system.today().addDays(5);
        objDeal.TSGADX__Sales_Stage__c = 'Qualify';
        objDeal.Next_Steps__c = 'Next Step';
        objDeal.VP_Forecast__c = true;
        lstDealsToInsert.add(objDeal);
        
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
        objDeal.TSGADX__Won__c = true;
        objDeal.Manager_Forecast__c = true;
        
        lstDealsToInsert.add(objDeal);

        insert lstDealsToInsert;
        
        SalesReviewReportController1 objSRR = new SalesReviewReportController1();
        objSRR.objSalesQuote.BEQI__c = 7400;
        objSRR.UpdateQuotas();
        
        for(TSGADX__Deal__c objDealU: lstDealsToInsert){
            objDealU.TSGADX__Replacement_Date__c = system.today().addYears(1);
            objDealU.TSGADX__Proposal_Date__c = system.today().addMonths(1);
            objDealU.TSGADX__Sales_Stage__c = 'Won';
        }
        
        update lstDealsToInsert;
        
        Test.startTest();
        
        objSRR = new SalesReviewReportController1();
        objSRR.strSelectedQuarter = '1';
        objSRR.strSelectedMyOrMyTeamData = '2';
        objSRR.SalesViewByRep(); 

        SalesReviewReportController1.SummaryModel objsummaryModel = new SalesReviewReportController1.SummaryModel();
        objDeal.TSGADX__Close_Date__c = system.today().AddDays(31);
        SalesReviewReportController1.Wrapperforcastpipeline objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(91);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(181);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(371);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(741);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(1181);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);

        objDeal.TSGADX__Close_Date__c = system.today().AddDays(1681);
        objpipeline = new SalesReviewReportController1.Wrapperforcastpipeline(objDeal,objsummaryModel);        

        //objSRR.strSelectedQuarter = '2';
        //objSRR.SalesViewByRep();
        //objSRR.strSelectedQuarter = '3';
        //objSRR.SalesViewByRep();
        //objSRR.strSelectedQuarter = '4';
        //objSRR.SalesViewByRep();
            
        /*objSRR.printSalesReport();

        SalesReviewReportController1.WrapperforcastTrackActivity wftaskactvity = new SalesReviewReportController1.WrapperforcastTrackActivity();
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today(), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(-8), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(65), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(185), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(367), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(735), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(1115), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(1566), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,true);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today(), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,false);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today(), Type = '*RT BTR Survey Request - 0'),wftaskactvity,false);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(-8), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,false);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addDays(-8), Type = '*RT BTR Survey Request - 0'),wftaskactvity,false);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addMonths(-1), Type = '*RT Proposal Presentation/Demo - 15'),wftaskactvity,false);
        objSRR.fnCalculateActivityDetails(new Task(ActivityDate = System.today().addMonths(-1), Type = '*RT BTR Survey Request - 0'),wftaskactvity,false);
        */
        Test.stopTest();
        
    }
}