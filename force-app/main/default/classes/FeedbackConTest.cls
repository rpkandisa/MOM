@isTest(seeAllData = true)
public class FeedbackConTest{
    
   static testMethod void validateFeedbackCon() {
       
        TSGADX__Deal__c deal = [Select Id, CreatedDate From TSGADX__Deal__c Limit 1];
        
        Pagereference p  = Page.Feedback;
        
        ApexPages.currentPage().getParameters().put('id', deal.Id);
        ApexPages.currentPage().getParameters().put('v', String.valueOf(deal.CreatedDate));
        
        FeedbackCon  fb = new FeedbackCon();
        fb.getSK();
        fb.getMO();
        fb.getRecommend();
        fb.submitSurvey();
   }
   
}