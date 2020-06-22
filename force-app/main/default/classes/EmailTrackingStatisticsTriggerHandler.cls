public class EmailTrackingStatisticsTriggerHandler {
    List<wbsendit__Campaign_Activity__c> recordsNewList     = new List<wbsendit__Campaign_Activity__c>();
    List<wbsendit__Campaign_Activity__c> recordsOldList     = new List<wbsendit__Campaign_Activity__c>();
    Map<Id,wbsendit__Campaign_Activity__c> recordsNewMap    = new Map<Id,wbsendit__Campaign_Activity__c>();
    Map<Id,wbsendit__Campaign_Activity__c> recordsOldMap    = new Map<Id,wbsendit__Campaign_Activity__c>();
    Boolean isInsert, isUpdate, isDelete, isUndelete, isAfter, isbefore;
    
    public EmailTrackingStatisticsTriggerHandler(List<wbsendit__Campaign_Activity__c> newList, List<wbsendit__Campaign_Activity__c> oldList, Map<Id,wbsendit__Campaign_Activity__c> newMap,
                                                         Map<Id,wbsendit__Campaign_Activity__c> oldMap, Boolean isInsert, Boolean isUpdate, Boolean isDelete, Boolean isUndelete, Boolean isAfter, Boolean isBefore){
        this.recordsNewList = newList;
        this.recordsOldList = oldList;
        this.recordsNewMap  = newMap;
        this.recordsOldMap  = oldMap;
        this.isInsert       = isInsert;
        this.isUpdate       = isUpdate;
        this.isDelete       = isDelete;
        this.isUndelete     = isUndelete;
        this.isAfter        = isAfter;
        this.isbefore       = isBefore;
    }
    
    public void afterInsertEvent(){
        //Check custom settings to see if trigger is enabled or not                                                                                
        TSGADX__ADX_Settings__c adxSett = TSGADX__ADX_Settings__c.getOrgDefaults();
        //If not enabled, simply return from trigger and do nothing
        if(adxSett.Enable_Email_Tracking_Prospect_Deal_Tgr__c || Test.isRunningTest())
            processEmailTrackingStatistics();
    }
    
    public void afterUpdateEvent(){}
    public void afterDeleteEvent(){}
    public void afterUndeleteEvent(){}
    public void beforeInsertEvent(){}
    public void beforeUpdateEvent(){}
    public void beforeDeleteEvent(){}
    
    public void processEmailTrackingStatistics(){
        try{
            set<Id> contactIdSet                            = new set<Id>();
            set<string> campaignNameSet                     = new set<string>();
            set<string> contactToCampaignNameSet            = new set<string>();
            set<string> existingContactToCampaignNameSet    = new set<string>();
            set<Id> existingAccountIds                              = new set<Id>();
            
            for(wbsendit__Campaign_Activity__c e : recordsNewList){
                if(string.isNotBlank(e.wbsendit__Contact__c) && string.isNotBlank(e.Name)){
                    contactIdSet.add(e.wbsendit__Contact__c);
                    campaignNameSet.add(e.Name);
                }
            }
            
            set<wbsendit__Campaign_Activity__c> emailTrackStatsSet = new set<wbsendit__Campaign_Activity__c>([Select Id,Name,wbsendit__Activity__c,wbsendit__Contact__r.Account.Name, wbsendit__Contact__c, wbsendit__Contact__r.Account.OwnerId, wbsendit__Contact__r.AccountId  from wbsendit__Campaign_Activity__c where wbsendit__Contact__c IN :contactIdSet AND Name IN : campaignNameSet]);
            
            //Contact V/s all Email Stats
            Map<Id,set<wbsendit__Campaign_Activity__c>> contactToEmailTrackStatsMap = new Map<Id,set<wbsendit__Campaign_Activity__c>>();
            for(wbsendit__Campaign_Activity__c e: emailTrackStatsSet){
                if(string.isNotBlank(e.wbsendit__Contact__c) && string.isNotBlank(e.Name)){
                    if(contactToEmailTrackStatsMap.containsKey(e.wbsendit__Contact__c)){
                        contactToEmailTrackStatsMap.get(e.wbsendit__Contact__c).add(e);
                    }else{
                        contactToEmailTrackStatsMap.put(e.wbsendit__Contact__c,new set<wbsendit__Campaign_Activity__c>{e});
                    }
                    contactToCampaignNameSet.add(e.wbsendit__Contact__c+e.Name);
                    existingContactToCampaignNameSet.add(e.wbsendit__Contact__c+e.Name);
                    if(String.isNotBlank(e.wbsendit__Contact__r.AccountId))
                        existingAccountIds.add(e.wbsendit__Contact__r.AccountId);
                }
            }
            
            //Remove the ones which exists in Salesforce ie were created earlier.
            for(TSGADX__Deal__c deal: [Select Id,Prospect_Deal_Key__c from TSGADX__Deal__c where Prospect_Deal_Key__c IN :existingContactToCampaignNameSet and Prospect_Deal_Key__c!=null]){
                existingContactToCampaignNameSet.remove(deal.Prospect_Deal_Key__c);
            }
            
            //Remove the ones which exists in Salesforce and are not Closed
            /*
            for(TSGADX__Deal__c deal: [Select Id,TSGADX__Company__c from TSGADX__Deal__c where TSGADX__Company__c IN :existingAccountIds and TSGADX__Company__c!=null and TSGADX__Closed__c=false]){
                existingAccountIds.remove(deal.TSGADX__Company__c);
            } */           
            
            Id prospectDealRecordTypeId = [Select Id,Name From RecordType Where SobjectType = 'TSGADX__Deal__c' and DeveloperName = 'Prospect' limit 1].Id;
            User managerUser = [Select Id,FirstName, LastName,Email from User where UserRole.Name = 'Marketing' and isActive = true limit 1];

            List<task> taskToInsertList             = new List<task>();
            List<TSGADX__Deal__c> DealToInsertList  = new List<TSGADX__Deal__c>();
            
            for(Id contactId : contactToEmailTrackStatsMap.keySet()){
                integer i_Opened = 0,i_Clicked  = 0;
                for(wbsendit__Campaign_Activity__c  e : contactToEmailTrackStatsMap.get(contactId)){
                    String prospectDealKey = contactId+e.Name;
                    
                    //If Open PD already exists, then skip
                    //if(String.isNotBlank(e.wbsendit__Contact__r.AccountId) && !existingAccountIds.contains(e.wbsendit__Contact__r.AccountId)) break;
                    
                    
                    //If PD was created earlier, then skip
                    if(!existingContactToCampaignNameSet.contains(prospectDealKey)) break;
                    
                    if(string.isNotBlank(e.Name) && string.isNotBlank(e.wbsendit__Activity__c)){
                        if(contactToCampaignNameSet.contains(prospectDealKey) && e.wbsendit__Activity__c.equalsIgnoreCase('Opened')){
                            i_Opened    = i_Opened +1;
                        }
                        if(contactToCampaignNameSet.contains(prospectDealKey) && e.wbsendit__Activity__c.equalsIgnoreCase('Clicked')){
                            i_Clicked   = i_Clicked +1;
                        }
                    }
                    
                    if((!e.Name.containsIgnoreCase('Mass') && i_Opened >= 2) || (!e.Name.containsIgnoreCase('Mass') && i_Clicked >= 1)) {
                        
                        Id accOwnerID = e.wbsendit__Contact__r.Account.OwnerId;
                        
                        
                        TSGADX__Deal__c newDeal = new TSGADX__Deal__c(recordTypeId=prospectDealRecordTypeId,Name = e.wbsendit__Contact__r.Account.Name,TSGADX__Main_Contact__c = e.wbsendit__Contact__c,
                            Campaign_Name__c = e.Name,Prospect_Deal_Key__c = prospectDealKey, OwnerId = accOwnerID);
                        if(String.isNotBlank(e.wbsendit__Contact__r.AccountId)) 
                            newDeal.TSGADX__Company__c=e.wbsendit__Contact__r.AccountId;
                        DealToInsertList.add(newDeal);

                        task newTask = new task(OwnerId = accOwnerID, Manager_First_Name__c = managerUser.FirstName, Subject = 'Customer Interest', ActivityDate = system.today(),
                                                Managers_Last_Name__c = managerUser.LastName, Manager_Email__c = managerUser.Email, WhoId = e.wbsendit__Contact__c , Whatid= newDeal.Id);
                        taskToInsertList.add(newTask);
                        
                        break;
                    }
                }
            }
            
            String errorMessage = '';
            Boolean hasError = false;
            
            if(!DealToInsertList.isEmpty()){
                Database.saveResult[] dealSaveResult = Database.insert(DealToInsertList, false);
                
                for(Database.saveResult sResult : dealSaveResult) {
                    if(!sResult.isSuccess()) {
                        hasError = true;
                        for(Database.error err : sResult.getErrors()) {
                            errorMessage += 'Deal Insert Error: ' + err.getMessage() + '\n\n';
                        }
                    }
                }
            }
            
            if(!taskToInsertList.isEmpty()){
                Database.saveResult[] taskSaveResult = Database.insert(taskToInsertList, false);
                
                for(Database.saveResult sResult : taskSaveResult) {
                    if(!sResult.isSuccess()) {
                        hasError = true;
                        for(Database.error err : sResult.getErrors()) {
                            errorMessage += 'Task Insert Error: ' + err.getMessage() + '\n\n';
                        }
                    }
                }
            }
            
            
            
            // Add Logic to Email if there are error.
            if(hasError || test.isRunningTest()) {
                errorMessage = 'Following error(s) occurred during the process of Email Tracking Statistics:\n\n' + errorMessage;
                
                errorMessage += 'Other Details: \n\n';
                errorMessage += 'Is Batch: ' + System.isBatch() + '\n\n';
                errorMessage += 'Is Future: ' + System.isFuture() + '\n\n';
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[] {'charles.oliveria@thesailorgroup.com', 'rajesh.shah@thesailorgroup.com'};
                mail.setToAddresses(toAddresses);
                mail.setReplyTo('noreply@salesforce.com');
                mail.setSubject('MOM: Email Tracking Statistics trigger error. Please check.');
                mail.setPlainTextBody(errorMessage);
                mail.setHtmlBody(errorMessage);
                if(!test.isRunningTest())
                    Messaging.sendEmail(new Messaging.singleEmailMessage[]{mail});
                
            }
            
        }catch(exception ex){
            trigger.new[0].addError('Error occured while creating Deal: '+ex.getMessage()+ex.getLineNumber());
            system.debug('Error : ' + ex.getMessage());
            system.debug('Line No. : ' + ex.getLineNumber());
        }
    }
}