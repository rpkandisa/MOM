/*
    Created by Kandisa technologies
    To update the fields on task from related contact, account and user.
*/
public class taskTriggerHandler{

    public void populateCustomFields(List<Task> triggerNewList, Map<id,Task> oldMap, boolean isUpdate){
        
        set<ID> whoIDs     = new set<ID>();
        set<ID> accountIds = new set<ID>();
        set<ID> ownerIDs   = new set<ID>();
        List<Task> tList  = new List<Task> ();
        
        for(task t : triggerNewList) {
            
            if(t.type.startsWithIgnoreCase('*RT BTR Survey Request'))
            {    
                if(!isUpdate)
            
                {
                    if(t.WhoID != null)
                        whoIDs.add(t.whoid);
                                          
                    if(t.OwnerId != null)
                        ownerIDs.add(t.Ownerid);
                    
                    tList.add(t);
                }
                else
                {
                    if(t.WhoID != null )
                        whoIDs.add(t.whoid);
                        
                    if(t.OwnerId != null )
                        ownerIDs.add(t.Ownerid);   
                        
                    if(t.OwnerId != oldMap.get(t.Id).OwnerId  || t.WhoID != oldMap.get(t.Id).WhoId || oldMap.get(t.Id).type!=t.type)     
                     {    
                        tList.add(t);
                     }
                    
                
                }
           }
        }
        
        
        if(tList.size()>0)
        {
            map<ID, Contact> contactMap = new map<ID,Contact>();
            map<ID, Account> accountMap = new map<ID,Account>();
            map<ID, User> UserMap = new map<ID,User>();
            
            //Populate contactMap with the contact IDs and contact record
            for (contact c : [select id, firstname,lastname,email, AccountId, Account.name, Account.billingcity, Account.billingstreet, Account.billingstate, 
                                 Account.billingpostalcode  from contact where id in : whoIDs]) {
                contactMap.put(c.id,c);
                
                }
            
            
            //Populate AccountMap with the account IDs and account record
            for (User u : [select id, firstname, lastname, email, managerid,  manager.firstname, manager.lastname, manager.email from User where id in : ownerIDs]) {
                UserMap.put(u.id,u);
            }
        
        
            for(Task t : tList)
            {
            
                if(t.whoId != null){
                    String sObjectName = Id.valueOf(t.WhoId).getSObjectType().getDescribe().getName();
                    system.debug('whoid is contact');
                    
                    if(sObjectName == 'Contact'){
                         
                         if(contactMap.containskey(t.WhoId))
                         {
                             t.Contact_First_Name__c = contactMap.get(t.WhoId).firstname;
                             t.Contact_Last_Name__c = contactMap.get(t.WhoId).lastname;
                             t.Contact_Email__c = contactMap.get(t.WhoId).email;
                             
                             
                             t.Account_Name__c = contactMap.get(t.WhoId).Account.name;
                             t.Billing_City__c = contactMap.get(t.WhoId).Account.BillingCity;
                             t.Billing_State__c = contactMap.get(t.WhoId).Account.BillingState;
                             t.Billing_Street__c = contactMap.get(t.WhoId).Account.BillingStreet;
                             t.Billing_ZIp_Code__c = contactMap.get(t.WhoId).Account.Billingpostalcode;
                             t.Business_Id__c = contactMap.get(t.WhoId).AccountId; 
                         }
                    }
                }
                
                if(userMap.containskey(t.ownerId) )
                {
                    t.Owner_First_Name__c = userMap.get(t.ownerId).firstname;
                    t.Owner_last_Name__c = userMap.get(t.ownerId).lastname;
                    t.Owner_email__c = userMap.get(t.ownerId).email;
                   
                    t.Manager_First_Name__c = userMap.get(t.ownerId).manager.firstname;
                    t.Managers_Last_Name__c = userMap.get(t.ownerId).manager.lastname;
                    t.Manager_Email__c = userMap.get(t.ownerId).manager.email;
                }
            }
        
        }
    }
}