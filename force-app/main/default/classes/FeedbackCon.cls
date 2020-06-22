public with sharing class FeedbackCon {
    
    public string code {get;set;}
    public Boolean displaySurvey {get;set;}  
    Public TSGADX__Deal__c deal;
    
    public Id       dealId                {get;set;}
    public String   createdDate           {get;set;}
    
    public Boolean   DCPrice               {get;set;}
    public Boolean  DCService             {get;set;}   
    public Boolean  DCQuality             {get;set;}
    public Boolean  DCRelationship        {get;set;}
    public Boolean  DCOthers              {get;set;}
    
    public String   SKOption              {get;set;}
    public String   MOOption              {get;set;}
    public String   RecommendOption       {get;set;}
    
    Public String   ProsFeedback          {get;set;} 
 
    public feedbackCon(){
       
        DCPrice          = false;
        DCService        = false;   
        DCQuality        = false;
        DCRelationship   = false; 
        DCOthers         = false;

    
        dealId      = ApexPages.currentPage().getParameters().get('id');
        createdDate = ApexPages.currentPage().getParameters().get('v');
        SKOption = null;
        MOOption = null;
        
        deal = [Select Id, CreatedDate, Decision_Criteria__c, Sales_Knowledge__c, MOM_Offerings__c, Recommend_MOM__c, Prospect_Feedback__c From TSGADX__Deal__c Where Id =: dealId ];
        
        code = String.valueOf(deal.CreatedDate);
        
        code = code+'Z';

        if(code == createdDate){

            displaySurvey = true;
            
        }else{

            displaySurvey = false;

        }
    }
    
    public List<SelectOption> getSK() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    
    public List<SelectOption> getMO() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }
    
   public List<SelectOption> getRecommend() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('Yes','Yes')); 
        options.add(new SelectOption('No','No')); 
        return options; 
    }    

    
    public pageReference submitSurvey(){
            string tempPrice         = DCPrice?'Price':'';
            string tempService       = DCService?'Service':'';
            string tempQuality       = DCQuality?'Quality':'';
            string tempRelationship  = DCRelationship?'Relationship':'';
            string tempOther         = DCOthers?'Other':'';
            
            deal.Decision_Criteria__c = tempPrice + ';' + tempService+';'+ tempQuality +';'+tempRelationship +';'+ tempOther;
            deal.Sales_Knowledge__c   = SKOption;
            deal.MOM_Offerings__c     = MOOption;
            deal.Recommend_MOM__c     = RecommendOption;
            deal.Prospect_Feedback__c = ProsFeedback;
            update deal;
            return new PageReference('/apex/ThankYou');        
    }    
}