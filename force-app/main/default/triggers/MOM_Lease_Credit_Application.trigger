trigger MOM_Lease_Credit_Application on Lease_Credit_Application__c (after insert, before update) {
    Set<Id> setCreatedByUsers = new Set<Id>();
    Map<Id, User> mapUserId2Obj = new Map<Id, User>();
    
    for (Lease_Credit_Application__c item:trigger.new)
    {
        system.debug('-------item.CreatedById='+item.CreatedById);
        setCreatedByUsers.add(item.CreatedById);
    }
    
    if (setCreatedByUsers.size()>0)
    {
        for (User item:[Select Id, Manager.Name, Manager.Email FROM User WHERE Id IN :setCreatedByUsers])
        {
            mapUserId2Obj.put(item.Id, item);
        }
        
        if (trigger.isBefore)
        {
            for (Lease_Credit_Application__c item:trigger.new)
            {
                if (mapUserId2Obj.containsKey(item.CreatedById)) item.Manager_Email__c = mapUserId2Obj.get(item.CreatedById).Manager.Email;
                if (mapUserId2Obj.containsKey(item.CreatedById)) item.Manager_Name__c = mapUserId2Obj.get(item.CreatedById).Manager.Name;
            }
        } else {
            Set<Id> setLCAIds = new Set<Id>();
            for (Lease_Credit_Application__c item:trigger.new)
            {
                if (mapUserId2Obj.containsKey(item.CreatedById)) 
                {
                    setLCAIds.add(item.Id);
                }
            }
            if (setLCAIds.size()>0) MOM_Future_Lease_Credit_App.processManager(setLCAIds);
            
        }
    }
}