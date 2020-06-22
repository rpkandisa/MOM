global class MOM_Lease_Credit_App_WellsFargo {

    public class JSON2Apex {
        public String request_app_no;
        public String customer_business_type;
        public String industry;
        public String lease_type;
        public String customer_name;
        public String customer_addr;
        public String customer_city;
        public String customer_state;
        public String customer_zip;
        public String customer_phone;
        public String lease_finance_amnt;
        public String lease_term;
        public String cust_contact_fname;
        public String cust_contact_lname;               
     }
    
    WebService static void build_WF_Email(string id,string content,string userEmail) { 

        JSON2Apex appContent = (JSON2Apex)JSON.deserialize(content, JSON2Apex.class);

        EA_Settings__c sett = EA_Settings__c.getInstance();  //Get Custom EA Settings    
        
        System.debug('content:>>> ' +JSON.serialize(content));  
           
        string htmlBody = '<HTML><BODY><h3>';
        string user = UserInfo.getName();
        htmlbody += 'Credit application from ' + user + ' of ' + UserInfo.getOrganizationName() + '</h3>';
      
        string htmlBodyTable1 = '<table>';
        htmlBodyTable1 +=
            '<tr><td>RequestSalesRepName</td>' 
          + '<td>' + user + '</td></tr>' 
          + '<tr><td>RequestSalesRepEmail</td>' 
          + '<td>' + userEmail + '</td></tr>'           
          + '<tr><td>SubmissionDate</td>' 
          + '<td>' + System.now().format()  + '</td></tr>'   
          + '<tr><td>RequestApplicationNo</td>' 
          + '<td>' + appContent.request_app_no + '</td></tr>'                    
          + '<tr><td>CustomerName</td>' 
          + '<td>' + appContent.customer_name + '</td></tr>'           
          + '<tr><td>BusinessType</td>' 
          + '<td>' + appContent.customer_business_type + '</td></tr>'
          + '<tr><td>BusinessDescription</td>' 
          + '<td>' + appContent.industry + '</td></tr>' 
          + '<tr><td>Address1</td>' 
          + '<td>' + appContent.customer_addr + '</td></tr>'  
          + '<tr><td>City</td>' 
          + '<td>' + appContent.customer_city + '</td></tr>'  
          + '<tr><td>State</td>' 
          + '<td>' + appContent.customer_state + '</td></tr>'  
          + '<tr><td>Zip</td>' 
          + '<td>' + appContent.customer_zip + '</td></tr>'  
          + '<tr><td>CustomerContactPhone</td>' 
          + '<td>' + appContent.customer_phone + '</td></tr>'  
          + '<tr><td>FirstName</td>' 
          + '<td>' + appContent.cust_contact_fname + '</td></tr>'   
          + '<tr><td>LasttName</td>' 
          + '<td>' + appContent.cust_contact_lname + '</td></tr>'                       
          + '<tr><td>ProductTotalAmt</td>' 
          + '<td>' + appContent.lease_finance_amnt + '</td></tr>'  
          + '<tr><td>RequestPurchaseOption</td>' 
          + '<td>' + appContent.lease_type + '</td></tr>'                               
          + '<tr><td>LeaseTerm</td>' 
          + '<td>' + appContent.lease_term + '</td></tr>'          
  
          +'</table>';

         htmlBodyTable1 += '</Table>';
             
        List<String> toAddresses = new List<String> {sett.Wells_Fargo_Email__c};

        String replyToAddress = sett.Lease_Email__c;             
       
        MOM_EmailUtil emailUtil = new MOM_EmailUtil(toAddresses);
      
        emailUtil = new MOM_EmailUtil(toAddresses);
        emailUtil.htmlBody(htmlBody + htmlBodyTable1)
              .senderDisplayName(UserInfo.getName())
              .subject('Credit application for ' +  + id)
              .useSignature(true)
              .replyTo(replyToAddress)
              .sendEmail();        
    }
}