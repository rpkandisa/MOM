global class MOM_LeaseBuyoutRequest {



  
    
    WebService static void RelatedLeases(string id,string leaseNumber,string leaseCompany,string userEmail) { 
        //string leaseNumber = '10172011-00029'; //'AFS-256410-C'; //'500-1733341';
        string ln;  
	    EA_Settings__c sett = EA_Settings__c.getInstance();  //Get Custom EA Settings    
	    if(sett.Enable_Lease_Email__c) {    // Only proceed if Enable Lease Email is turned on 
		    Pattern regex = Pattern.compile('[A-Za-z0-9](.*)-[A-Za-z0-9](.*)-?[A-Za-z0-9](.*?)');
		    Matcher regexMatcher = regex.matcher(leaseNumber);
		    if (regexMatcher.find()) {
		        ln = leaseNumber.split('\\-')[1];
		        System.debug(ln);
		        ln = '%'+ln+'%';
		        System.debug(ln);
		    } else {
		        ln = leaseNumber;
		    } 
     
    /*
    sObject c = [SELECT TSGADX__Business_Name__c,
        (Select Service_Base_Rate__c from Agreement_Details__r)
    FROM TSGADX__Agreements__c WHERE EA_Lease_Number__c = :leaseNumber];
    
    for (TSGADX__Agreements__c master : [
        SELECT Id,Name,
          TSGADX__Business_Name__c,EA_Lease_Number__c,
          (Select Service_Base_Rate__c from Agreement_Details__r)
        FROM TSGADX__Agreements__c WHERE EA_Lease_Number__c = :'500-0250892-000']) {
      System.debug('Here is an ObjectMaster record: '+master.EA_Lease_Number__c);
    for (Agreement_Detail__c detail : master.Agreement_Details__r) {
    System.debug('Here is an ObjectDetail record: '+detail);}
    }
    */
	        string htmlBody = '<HTML><BODY><h3>';
	        string user = UserInfo.getName();
	        htmlbody += 'Lease buyout request from ' + user + ' of ' + UserInfo.getOrganizationName() + '</h3>';
	    
	        string htmlBodyTable1 = '<table>';
	        htmlBodyTable1 +='<tr><td><b>Client</b></td>' 
	        + '<td>' + id + '</td></tr>' 
	        + '<tr><td><b>Assigned To</b></td>' 
	        + '<td>' + user + ' ' + userEmail + '</td></tr>'
	    /*  + '<tr><td><b>Model</b></td>' 
	        + '<td><b>' + 'Model' + '</b></td></tr>' 
	        + '<tr><td><b>Serial</b></td>' 
	        + '<td><b>' + 'Serial' + '</b></td></tr>'  
	    */    
	        + '<tr><td><b>Lease Vendor</b></td>' 
	        + '<td>' + leaseCompany + '</td></tr>'
	        + '<tr><td><b>Lease Number</b></td>' 
	        + '<td>' + leasenumber + '</td></tr>'          
	    /*  + '<tr><td><b>Service Rate</b></td>' 
	        + '<td><b>' + 'Service Rate' + '</b></td></tr>'    
	       
	        + '<tr><td><b>Freight Charge</b></td>' 
	        + '<td><b>' + 'Freight Charge' + '</b></td></tr>'  
	    */         
	        +'</table>';
	     
	        string htmlBodyTable2 = '<h3>Related Leases:</h3>'
	        + '<Table width="100%" cellspacing="0" cellpadding="5" border="1"><TR><TD width="50%"><B>Client</B></TD><TD width="20%"><B>Lease Number</B></TD><TD width="20%"><B>Serial Number</B></TD>'
	        + '<TD width="20%"><B>Equipment Number</B></TD><TD width="20%"><B>Service Rate</B></TD><TD width="20%"><B>Model</B></TD></TR>';
	    
	        for (Agreement_Detail__c master : [
	            SELECT Name,Equipment__r.TSGADX__Serial_Number__c,Agreement__r.EA_Lease_Number__c,
	            Equipment__r.EA_Equipment_Number__c,Agreement__r.TSGADX__Business_Name__r.Name,
	            Equipment__r.TSGADX__Make__c,
	            Equipment__r.TSGADX__Model__c,
	            Service_Base_Rate__c FROM Agreement_Detail__c
	            WHERE Agreement__r.EA_Lease_Number__c LIKE :(ln) ]) {
	    
	            //System.debug('Here is an ObjectMaster record: '+master.Equipment__r.TSGADX__Serial_Number__c + ' >>> ' +master.Service_Base_Rate__c);
	    
	            htmlBodyTable2 += '<TR><TD>' + master.Agreement__r.TSGADX__Business_Name__r.Name + '</TD><TD>' + master.Agreement__r.EA_Lease_Number__c + '</TD><TD>' + master.Equipment__r.TSGADX__Serial_Number__c + '</TD><TD>'
	            + master.Equipment__r.EA_Equipment_Number__c + '</TD><TD>' + master.Service_Base_Rate__c + '</TD><TD>'
	            + master.Equipment__r.TSGADX__Model__c + '</TD></TR>';
	        }    
	         
	        htmlBodyTable1 += '</Table>';
	           
	        List<String> toAddresses = new List<String> {sett.Lease_Email__c}; // Retrieve EA Custom Setting - Lease Email, previous code: {'dbandy@momnet.com'}; 'leasing@momnet.com'
	        
	        String replyToAddress = userEmail;
	    
	        MOM_EmailUtil emailUtil = new MOM_EmailUtil(toAddresses);
	    
	        emailUtil = new MOM_EmailUtil(toAddresses);
	        emailUtil.htmlBody(htmlBody + htmlBodyTable1 + htmlBodyTable2)
	            .senderDisplayName(UserInfo.getName())
	            .subject('Lease buyout request for ' +  + id)
	            .useSignature(true)
	            .replyTo(replyToAddress)
	            .sendEmail();        
        }
        //private string null2String(string s) { if (s == null) return ''; else return s; }
    }
    
    public static testMethod void testLeaseBuyoutRequest(){
        /*
        Account acc = new Account(Name='TestAccount');
        insert acc;
        TSGADX__Agreements__c lease = new TSGADX__Agreements__c(TSGADX__Status__c='Active',
                                                                EA_Lease_Number__c='000-0000000-000',
                                                                TSGADX__Business_Name__c=acc.Id,
                                                                TSGADX__Leasing_Company__c=acc.Id);
        insert lease;
        TSGADX__Equipment__c eq = new TSGADX__Equipment__c();
        insert eq;
        */
        //TSG_DD.DupeCatcherActivationManager.DeactivateAll();
        Account acc = [Select Id from Account Limit 1];
        TSGADX__Agreements__c lease = [Select Id, TSGADX__Status__c, EA_Lease_Number__c, TSGADX__Business_Name__c, TSGADX__Leasing_Company__c
                                       From TSGADX__Agreements__c Limit 1];
        lease.TSGADX__Status__c = 'Active';
        lease.EA_Lease_Number__c = '000-0000000-000';
        lease.TSGADX__Business_Name__c = acc.Id;
        lease.TSGADX__Leasing_Company__c = acc.Id;        
        TSGADX__Equipment__c eq = [Select Id from TSGADX__Equipment__c Limit 1];
        
        Agreement_Detail__c ld = new Agreement_Detail__c(Agreement__c=lease.id, Equipment__c=eq.id);
        insert ld;
        RelatedLeases(lease.TSGADX__Business_Name__c, lease.EA_Lease_Number__c, lease.TSGADX__Leasing_Company__c, 'developer@thesailorgroup.com');
        
        lease.EA_Lease_Number__c = '000';
        RelatedLeases(lease.TSGADX__Business_Name__c, lease.EA_Lease_Number__c, lease.TSGADX__Leasing_Company__c, 'developer@thesailorgroup.com');
        //TSG_DD.DupeCatcherActivationManager.ReactivateAll();
    }
}