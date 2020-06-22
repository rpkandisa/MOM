/*
    Description: Controller is created for Update Fix Rate Multiplier
*/
public with sharing class UpdateFixRateMultiplier {
    
    public Id qid;
    public string pgType;
    public TSGCFG__Quote__c quote {get;set;}
    
    public UpdateFixRateMultiplier(ApexPages.StandardController controller) {
        qid = apexpages.currentpage().getparameters().get('id');
        pgType = apexpages.currentpage().getparameters().get('pgtype');
        if(!string.isblank(qid)){
            fetchQuoteDetail();
        }else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, 'Quote Id should be required.'));
        }
    }
    
    private void fetchQuoteDetail(){
        List<TSGCFG__Quote__c> lstQuote = new List<TSGCFG__Quote__c>([select id,name,Fixed_Rate__c,Fixed_Rate_Term__c,TSGCFG__Fixed_Rate_Multiplier__c 
                                                                      from TSGCFG__Quote__c where id =:qid ]);
        if(lstQuote.size()>0){
            quote = lstQuote.get(0);
        }
    }
    
    public PageReference QuoteSave(){
        try{
            update quote;
            return BackToConfigurator();
        }catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR, ex.getmessage()));
        }
        return null;
    }

    public PageReference BackToConfigurator() {
        PageReference pg;
        if(pgType == 'lightning'){
            pg = Page.tsgcfg__ManageQuoteLineItemsLDS;
        } else {
            pg = Page.tsgcfg__ManageQuoteLineItems;
        }
        pg.getparameters().put('id',qid);
        return pg;
    }
}