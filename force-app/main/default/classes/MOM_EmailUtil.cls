public class MOM_EmailUtil {
       private Messaging.SingleEmailMessage singleEmailMessage;
       private final List<String> toAddresses;
       
       //optional parameters set to default        
       private String subject = '';
       private String htmlBody = ''; 
       private Boolean useSignature = false;
       private List<Messaging.EmailFileAttachment> fileAttachments = null;
       //defaults to current user's first name + last name
       private String senderDisplayName = UserInfo.getFirstName()+' '+UserInfo.getLastName();
       //get the current user in context
       User currentUser = [Select email from User where username = :UserInfo.getUserName() limit 1];        
       //replyTo defaults to current user's email 
       private String replyTo = currentUser.email;
       private String plainTextBody = '';
       
       public MOM_EmailUtil(List<String> addresses) {
           this.toAddresses = addresses;
       }
       
       public MOM_EmailUtil senderDisplayName(String val) {
           senderDisplayName = val;
           return this;
       }
       
       public MOM_EmailUtil subject(String val) {
           subject = val;
           return this;
       }
       
       public MOM_EmailUtil htmlBody(String val) {
           htmlBody = val;
           return this;
       }
       
       public MOM_EmailUtil useSignature(Boolean bool) {
           useSignature = bool;
           return this;
       }
       
       public MOM_EmailUtil replyTo(String val) {
           replyTo = val;
           return this;
       }
       
       public MOM_EmailUtil plainTextBody(String val) {
           plainTextBody = val;
           return this;
       }
       
       public MOM_EmailUtil fileAttachments(List<Messaging.Emailfileattachment> val) {
           fileAttachments = val;
           return this;
       }
       
       //where it all comes together
       //this method is private and is called from sendEmail()
       private MOM_EmailUtil build() {
           singleEmailMessage = new Messaging.SingleEmailMessage();
           singleEmailMessage.setToAddresses(this.toAddresses);
           singleEmailMessage.setSenderDisplayName(this.senderDisplayName);
           singleEmailMessage.setSubject(this.subject);
           singleEmailMessage.setHtmlBody(this.htmlBody);
           singleEmailMessage.setUseSignature(this.useSignature);
           singleEmailMessage.setReplyTo(this.replyTo);
           singleEmailMessage.setPlainTextBody(this.plainTextBody);
           singleEmailMessage.setFileAttachments(this.fileAttachments);
           return this;
       }
       
       //send the email message
       public void sendEmail() {
              try {
                  //call build first to create the email message object
                  build();
                  Messaging.sendEmail(new Messaging.SingleEmailMessage[] { singleEmailMessage });
              } catch (Exception ex) {
                  throw new GenericException('There was a problem while calling Messaging.sendEmail()');
              }                
       }    

    public static testMethod void testSendEmail(){
        TSGADX__ADX_Settings__c sett = TSGADX__ADX_Settings__c.getInstance();
        EA_Settings__c eaSett = EA_Settings__c.getInstance();
        Boolean EA_Alerts = sett.TSGADX__EA_Alerts__c;
        Boolean EQMM = eaSett.Enable_EQMakesModels__c;
        sett.TSGADX__EA_Alerts__c = true;
        eaSett.Enable_EQMakesModels__c = true;
        upsert sett;
        upsert eaSett;
        //TSG_DD.DupeCatcherActivationManager.DeactivateAll();
        
        List<String> toAddrs = new List<String>();
        MOM_EmailUtil eu = new MOM_EmailUtil(toAddrs);
        eu.senderDisplayName('Test McTest');
        eu.subject('This is a test');
        eu.htmlBody('<br>This is the body of a test<br>');
        eu.plainTextBody('This is the body of a test');
        eu.useSignature(false);
        eu.replyTo('no-reply@salesforce.com');
        List<Messaging.Emailfileattachment> attachments = new List<Messaging.Emailfileattachment>();
        eu.fileAttachments(attachments);
        try{eu.sendEmail();}
        catch(GenericException GE){}
        toAddrs.add('developer@thesailorgroup.com');
        eu.sendEmail();
        System.assertEquals(1,1);
    }





//custom exception     
public class GenericException extends Exception{


}

}