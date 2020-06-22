public class AgreementDetailsHandler {
	 public static void deleteAgreementDetail(List<Agreement_Detail__c> agreementDetailList){
       set<Id> Ids = new set<Id>();
        
         for(Agreement_Detail__c aggDet : agreementDetailList) {
             if(aggDet.EA_Delete_Agreement_Detail__c){
                 Ids.add(aggDet.Id);
             }   
         }
         if(Ids.size() > 0){
         	delete[Select Id from Agreement_Detail__c where ID IN :Ids];
         } 
    }
}