/**
    Test for Lease_Credit_Application.trigger
 */
@isTest
private class Test_Lease_Credit_Application {

    static testMethod void test_init() {
        
 // Create Account
        Account a = new Account(Name = 'Test Lease Credit',
                BillingStreet = '123 Main St.',
                BillingCity = 'My City',
                BillingState = 'XX',
                BillingPostalCode = '11111',
                TSGADX__Auto_Assign__c = False);
        insert a;
 // Create Deal
        TSGADX__Deal__c d = new TSGADX__Deal__c(Name = 'Test Lease Credit' + ' - Deal1',                             
                TSGADX__Company__c = a.Id, 
                TSGADX__Sales_Stage__c = 'Prospect');                                     
        insert d;
 // Create Lease Credit Application
        Lease_Credit_Application__c lca = new Lease_Credit_Application__c( Account__c = a.id,
                Deal__c = d.id,
                Address__c = 'Some street',
                City__c = 'New York',
                State__c = 'NY',
                Zip__c = '11111',
                Contact_First_Name__c = 'Jack',
                Contact_Last_Name__c = 'Black',
                Phone__c = '1112223355',
                Finance_Amount__c = 100.00,
                Payment_Amount__c = 20.00,
                Term__c = 10,
                Current_Status__c = 'Pre-Approval');
        insert lca;
    } 
}