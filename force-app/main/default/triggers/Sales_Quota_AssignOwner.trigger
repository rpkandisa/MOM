trigger Sales_Quota_AssignOwner on Sales_Quota__c (before insert, before update) {
    
    if(Trigger.isBefore) {
    
        if(Trigger.isInsert  ) {
            
            for(Sales_Quota__c s: Trigger.New) {
            
                if(s.Rep_Name__c != null) {
                
                   s.OwnerId = s.Rep_Name__c;    
                }                 
                
            }
            
        }
       /* else if(Trigger.isUpdate) {
            
            for(Sales_Quota__c r: Trigger.New) {
            
                if(r.Rep_Name__c != Trigger.oldMap.get(r.id).Rep_Name__c) {
                    
                    r.adderror('You are not allowed to change the Rep Name');
                        
                }
            }
            
        } */
        
    }
    
    
    
}