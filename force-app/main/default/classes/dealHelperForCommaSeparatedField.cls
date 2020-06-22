public with sharing class dealHelperForCommaSeparatedField {
    public static boolean Execute_dealHelperForCommaSeparatedField = true;
    // on update populate the deal's field
    public static void updateDealOnUpdate(map<id,TSGADX__Deal__c> dealNewMap, map<id,TSGADX__Deal__c> dealOldMap){
        // map to hold quoteid and its corresponding modelname string
        map<id,string> quoteIdToModelString = new map<id,string>();
        // set of primary quoteIds 
        set<id> quoteId = new set<id>();
        // map of dealId to quote
        map<id,id> dealIdToQuoteMap = new map<id,id>();
        // list of deal to update  
        list<TSGADX__Deal__c> dealList = new list<TSGADX__Deal__c>();
        set<id> dealIdWithNoPrimaryQuote = new set<id>();
        map<id,boolean> quotePrimaryMap = new map<id,boolean>();
        for(TSGCFG__Quote__c quote : [select id,TSGCFG__Primary__c from TSGCFG__Quote__c where TSGCFG__Deal__c in : dealNewMap.keySet()]){
            quotePrimaryMap.put(quote.id, quote.TSGCFG__Primary__c);
        }
        // itrate over new deal Values
        for(id dealId : dealNewMap.keySet()){
            // change on primary quote 
            if(dealNewMap.get(dealId).TSGCFG__Quote__c != null && quotePrimaryMap != null && quotePrimaryMap.containskey(dealNewMap.get(dealId).TSGCFG__Quote__c)
                        && quotePrimaryMap.get(dealNewMap.get(dealId).TSGCFG__Quote__c)){
                    quoteId.add(dealNewMap.get(dealId).TSGCFG__Quote__c);
                    dealIdToQuoteMap.put(dealId, dealNewMap.get(dealId).TSGCFG__Quote__c);
            }
        }   
        // fetch all the quoteLineItems for the quote and get the string for all models
        for(TSGCFG__Quote_Line_Items__c quoteLineItem : [select TSGCFG__Product__r.name, TSGCFG__Qty__c, TSGCFG__Product_Type__c, TSGCFG__Quote__c
                                                                 from TSGCFG__Quote_Line_Items__c 
                                                                 where TSGCFG__Quote__c in : quoteId]){
             if(quoteLineItem.TSGCFG__Product_Type__c == 'Model'){
                if(quoteIdToModelString.containsKey(quoteLineItem.TSGCFG__Quote__c)){
                    string modelString = quoteIdToModelString.get(quoteLineItem.TSGCFG__Quote__c);
                    modelString += ',' + quoteLineItem.TSGCFG__Product__r.name + '-' +quoteLineItem.TSGCFG__Qty__c;
                    quoteIdToModelString.put(quoteLineItem.TSGCFG__Quote__c, modelString);
                }
                else{
                     quoteIdToModelString.put(quoteLineItem.TSGCFG__Quote__c, quoteLineItem.TSGCFG__Product__r.name+ '-' +quoteLineItem.TSGCFG__Qty__c);
                } 
             }      
                                                             
        }
        // update the field on deal
        for(TSGADX__Deal__c deal : [select DummyCongaDeal__c  
                                           from TSGADX__Deal__c
                                           where id in : dealIdToQuoteMap.keySet()]){
            deal.DummyCongaDeal__c = quoteIdToModelString.get(dealIdToQuoteMap.get(deal.id));
            dealList.add(deal);
        }
        if(dealList.size() > 0){
            dealHelperForCommaSeparatedField.Execute_dealHelperForCommaSeparatedField = false;
            update dealList;
        }
    }
}