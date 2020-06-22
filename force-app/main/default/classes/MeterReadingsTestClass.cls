@isTest
public class MeterReadingsTestClass {
    static testMethod void insertMeterReading(){
        
        // Define Custom Setting
        EA_Settings__c eaSett = EA_Settings__c.getInstance();

        if(eaSett == null) {
            eaSett = new EA_Settings__c();
        }
        eaSett.Enable_Mark_Latest_Meter_Reading_Trigger__c = true;
        upsert eaSett;

        // Create Equipment Records
        list<TSGADX__Equipment__c> equipmentList = new List<TSGADX__Equipment__c> {
            new TSGADX__Equipment__c(EA_Equipment_Number__c = '12345'),
            new TSGADX__Equipment__c(EA_Equipment_Number__c = '67890'),
            new TSGADX__Equipment__c(EA_Equipment_Number__c = '14789')
        };

        insert equipmentList;

        Test.startTest();

        // Create Meter Reading Records
        list<Meter_Reading__c> meterReadingList1 = new list<Meter_Reading__c> {
            new Meter_Reading__c(Equipment__c = equipmentList[0].Id, Meter_Type__c = 'BW'),
            new Meter_Reading__c(Equipment__c = equipmentList[0].Id, Meter_Type__c = 'BW'),
            new Meter_Reading__c(Equipment__c = equipmentList[1].Id, Meter_Type__c = 'Color'),
            new Meter_Reading__c(Equipment__c = equipmentList[1].Id, Meter_Type__c = 'Color')
        };

        insert meterReadingList1;

        Meter_Reading__c meterReading1 = [Select Id from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[0].Id];
        Meter_Reading__c meterReading2 = [Select Id from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[1].Id];
        
        system.assertEquals(1, [Select Count() from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[0].Id]);
        system.assertEquals(1, [Select Count() from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[1].Id]);

        list<Meter_Reading__c> meterReadingList2 = new list<Meter_Reading__c> {
            new Meter_Reading__c(Equipment__c = equipmentList[0].Id, Meter_Type__c = 'BW'),
            new Meter_Reading__c(Equipment__c = equipmentList[0].Id, Meter_Type__c = 'BW'),
            new Meter_Reading__c(Equipment__c = equipmentList[1].Id, Meter_Type__c = 'Color'),
            new Meter_Reading__c(Equipment__c = equipmentList[1].Id, Meter_Type__c = 'Color')
        };

        insert meterReadingList2;

        // Check number of Mark records
        system.assertEquals(1, [Select Count() from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[0].Id]);
        system.assertEquals(1, [Select Count() from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equipmentList[1].Id]);

        system.assertEquals(FALSE, [Select Is_Latest__c from Meter_Reading__c where Id = :meterReading1.Id].Is_Latest__c);
        system.assertEquals(FALSE, [Select Is_Latest__c from Meter_Reading__c where Id = :meterReading2.Id].Is_Latest__c);

        Test.stopTest();
    }

    // Test Class for Batch Method
    static testmethod void TestMeterReadingUpdateBatch() {
        TSGADX__Equipment__c equip = new TSGADX__Equipment__c(EA_Equipment_Number__c = '12345');
        insert equip;

        // Create Meter Reading Records
        list<Meter_Reading__c> meterReadingList = new list<Meter_Reading__c> {
            new Meter_Reading__c(Equipment__c = equip.Id, Meter_Type__c = 'BW'),
            new Meter_Reading__c(Equipment__c = equip.Id, Meter_Type__c = 'BW')
        };
        insert meterReadingList;

        Test.StartTest();

        Id batchId = Database.executeBatch(new UpdateIsLatestMeterReadingBatch(), 200);

        Test.StopTest();

        System.assertEquals(1, [Select Count() from Meter_Reading__c where Is_Latest__c = true and Equipment__c = :equip.Id]);
        
    }
}