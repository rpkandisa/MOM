public with sharing class MOM_Future_Lease_Credit_App {
    @future
     public static void processManager(Set<Id> setLCAIds) {
        List<Lease_Credit_Application__c> lstLCA = new List<Lease_Credit_Application__c>();
        lstLCA = [Select Id FROM Lease_Credit_Application__c WHERE Id IN :setLCAIds];
        if (lstLCA.size()>0) update lstLCA;
     }
}