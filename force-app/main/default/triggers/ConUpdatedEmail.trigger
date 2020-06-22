trigger ConUpdatedEmail on Contact (after update) {
    EA_Settings__c sett = EA_Settings__c.getInstance();
    TSGADX__ADX_Settings__c adxsett = TSGADX__ADX_Settings__c.getInstance();
    if(sett != null && adxsett != null && adxsett.TSGADX__EA_Alerts__c){
    try{
        Id myId = UserInfo.getUserId();
        User me = [SELECT Id, Name, Email, Profile.Id, Profile.Name FROM User WHERE Id=:myId];
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setToAddresses(new String[]{me.Email});
        if(sett.EAutomate_Admin__c != null)mail.setCcAddresses(new String[]{sett.EAutomate_Admin__c});
        mail.setSenderDisplayName('AgentDealerX Support');
        mail.setSubject('Contact changed in Salesforce.  EAutomate requires update!');
        
        String message = 'You have updated a Contact record in Salesforce.  ';
        message = message + 'This record may be overwritten by data from EAutomate.  ';
        message = message + 'Please update your Contact record in EAutomate to correspond with your Salesforce record.  ';
        
        Map<Id, Contact> cons = new Map<Id, Contact>{};
        Map<Id, Contact> oldCons = new Map<Id, Contact>{};
        for(Contact con : Trigger.new)
        {
            if(con.EA_ContactId__c != null && con.TSGADX__Business_Type__c == 'Customer') cons.put(con.id, con);
        }
        Set<Id> conids = new Set<Id>{};
        conids.addall(cons.keySet());
        for(Contact con : Trigger.old)
        {
            if(conids.contains(con.id)) oldCons.put(con.id, con);
        }
        
        
        //Set<String> fields = new Set<String>{'Name','AccountNumber','OwnerId','BillingCity','BillingState','BillingStreet','BillingPostalCode','Fax','Ownership','Phone','ShippingCity','ShippingState','ShippingStreet','ShippingPostalCode','Type','Website','TSGADX__County__c','EA_Credit_Hold__c','EA_CustomerID__c','EA_Location_Id__c','EA_Phone2__c','EA_Ship_to_Attn__c','EA_Taxable__c','TSGADX__Inactive__c','TSGADX__Inactive_Reason__c'};
        Set<String> fields = new Set<String>{};
        if(sett != null && sett.EA_Contact_Fields__c != null) fields.addAll( sett.EA_Contact_Fields__c.split(',') );
        if(sett != null && sett.EA_Contact_Fields_2__c != null) fields.addAll( sett.EA_Contact_Fields_2__c.split(',') );
        String msg = '';
        Integer changedRecords = 0;
        for( Id conid : cons.keySet() )
        {
            Integer changedFields = 0;
            msg = '';
            Contact con = cons.get(conid);
            Contact oldCon = oldCons.get(conid);
            msg = msg + '<br>';
            msg = msg + '<br>Salesforce Record: ' + '<a href="https://na7.salesforce.com/' +con.Id+ '">' +con.FirstName+ ' ' +con.LastName+ '</a>';
            msg = msg + '<br>EA Contact Number: ' + oldCon.EA_Contact_Number__c;
            msg = msg + '<br>EA Contact ID: ' + oldCon.EA_ContactId__c;
            msg = msg + '<br>------------------';
            //Would like to run through Schema.sObjectType.Account.fields.getMap() and check for tracking
            for(String field : fields)
            {
                String oldVal = '';
                String newVal = '';
                if(oldCon.get(field) != null) oldVal = '' + oldCon.get(field);
                else oldVal = 'NULL';
                if(con.get(field) != null) newVal = '' + con.get(field);
                else newVal = 'NULL';
                if( oldVal != newVal ){
                    msg = msg + '<br>' + field + ' was changed from ' + oldVal + ' to ' + newVal;
                    changedFields++;
                }
            }
            if(changedFields > 0){
                message = message + msg;
                changedRecords++;
            }
        }
        /*
        List<skyvvasolutions__Integration__c> integrations = [Select skyvvasolutions__Packet__c from skyvvasolutions__Integration__c];
        Set<Integer> packets = new Set<Integer>();
        if(integrations.size() > 0)
        {
            for(skyvvasolutions__Integration__c integration : integrations)
            {
                packets.add((Integer)integration.skyvvasolutions__Packet__c);
            }
        }
        Boolean cancel = false;
        if(packets.contains(Trigger.new.size())) cancel = true;


        datetime time60minback = datetime.now().addMinutes(-60);
        List<AccountHistory> histories = [Select OldValue, NewValue, Field, CreatedDate, AccountId
                                            FROM AccountHistory 
                                            WHERE AccountId in :accs.keySet()
                                            AND CreatedDate >= :time60minback
                                            ORDER BY CreatedDate DESC];
        for( Account acc : accs.values() )
        {
            message = message + '<br>';
            message = message + '<br>Salesforce Record: ' + '<a href="https://na7.salesforce.com/' +acc.Id+ '">' +acc.Name+ '</a>';
            message = message + '<br>EA Customer ID: ' + acc.EA_CustomerId__c;
            Set<String> fieldsListed = new Set<String>{};
            for(AccountHistory hist : histories)
            {
                if(hist.AccountId == acc.Id && !fieldsListed.contains(hist.Field))
                {
                    message = message + '<br>' + hist.Field + ' was changed from ' + hist.OldValue + ' to ' + hist.NewValue;
                    fieldsListed.add(hist.Field);
                }
            }
        
        }
        */
        
        
        
        message = message + '';
        
        mail.setHtmlBody(message);
        //if(cons.size()>0 && changedRecords >0) Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
        if(cons.size()>0 && !me.Profile.Name.contains('System Administrator') && changedRecords > 0) Messaging.sendEmail(new Messaging.SingleEmailMessage[]{mail});
    }catch(Exception e){
        TSGADX__ADX_Log__c log = new TSGADX__ADX_Log__c();
        log.TSGADX__Log__c = e.getMessage();
        insert log;
    }
    }
}