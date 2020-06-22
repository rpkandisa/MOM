public with sharing class dealLineItemHelper {
    // boolean variable to avoid recursion
    public static boolean Execute_dealLineItemHelper = true;
    // update deal on updating qli's qty
    public static void updateDealOnQuantityUpdate(map<id,TSGCFG__Quote_Line_Items__c> newMap, map<id,TSGCFG__Quote_Line_Items__c> oldMap){
        
        // set of quote id whose qli qty is changed 
        set<id> quoteId = new set<id>();
        // map of quoteId and whether its primary or not
        map<id,boolean> quotePrimaryMap = new map<id,boolean>();
        // quote Id and its corresponding qli's product name
        map<id,string> quoteIdToProductNameMap = new map<id,string>();
        // quote Id and its corresponding qli's product qty
        map<id,decimal> quoteIdToProductQtyMap = new map<id,decimal>();
        // list of deal to update
        list<TSGADX__Deal__c> dealList = new list<TSGADX__Deal__c>();
        // itrate over new qli values
        for(id qliId :  newMap.keySet()){
            // if qty changes
            if(newMap.get(qliId).TSGCFG__Qty__c != oldMap.get(qliId).TSGCFG__Qty__c){
                quoteId.add(newMap.get(qliId).TSGCFG__Quote__c);
                quoteIdToProductNameMap.put(newMap.get(qliId).TSGCFG__Quote__c, newMap.get(qliId).TSGCFG__Product__r.name);
                quoteIdToProductQtyMap.put(newMap.get(qliId).TSGCFG__Quote__c, newMap.get(qliId).TSGCFG__Qty__c);
            }
        }
        if(!quoteId.isEmpty()){
            // get the primary quotes
            for(TSGCFG__Quote__c quote :[select id,TSGCFG__Primary__c from TSGCFG__Quote__c where id in : quoteId]){
                quotePrimaryMap.put(quote.id, quote.TSGCFG__Primary__c);
            }
            // update the deal 
            for(TSGADX__Deal__c deal : [select DummyCongaDeal__c, TSGCFG__Quote__c 
                                           from TSGADX__Deal__c
                                           where TSGCFG__Quote__c in : quoteId]){
                string s = ''; 
                if(quotePrimaryMap.containsKey(deal.TSGCFG__Quote__c)){
                    if(quotePrimaryMap.get(deal.TSGCFG__Quote__c)){
                        for(string productName : deal.DummyCongaDeal__c.split(',')){
                            list<string> s1 = productName.split('-');
                            if(s1[0] == quoteIdToProductNameMap.get(deal.TSGCFG__Quote__c)){
                                s += s1[0] + '-' + quoteIdToProductQtyMap.get(deal.TSGCFG__Quote__c) +',';
                            }
                            else{
                                s += productName +',';
                            }
                        }
                    }
                    s = s.removeEnd(',');
                    deal.DummyCongaDeal__c = s;
                    dealList.add(deal);
                }
            }
        }
        // list of deal to update
        if(dealList.size() > 0){
            Execute_dealLineItemHelper = false;
            update dealList;
        }
    }
    
    public static void updateDealOnQliDelete(map<id,TSGCFG__Quote_Line_Items__c> oldMap){
        // list of deal to update
        list<TSGADX__Deal__c> dealList = new list<TSGADX__Deal__c>();
        set<id> productIds = new set<id>();
        map<id,string> idToProductNameMap = new map<id,string>();
        map<id,string> quoteIdtoProdName = new map<id,string>();
        // map of quoteId and whether its primary or not
        map<id,boolean> quotePrimaryMap = new map<id,boolean>();
        for(id qliId : oldMap.keySet()){
            quoteIdtoProdName.put(oldMap.get(qliId).TSGCFG__Quote__c, oldMap.get(qliId).TSGCFG__Product__c);
            productIds.add(oldMap.get(qliId).TSGCFG__Product__c);
        }
        if(!quoteIdtoProdName.isEmpty()){
            // get the primary quotes
            for(TSGCFG__Quote__c quote :[select id,TSGCFG__Primary__c from TSGCFG__Quote__c where id in : quoteIdtoProdName.keySet()]){
                quotePrimaryMap.put(quote.id, quote.TSGCFG__Primary__c);
            }
            for(TSGCFG__Price_Book__c product : [select id,name from TSGCFG__Price_Book__c where id in : productIds]){
                idToProductNameMap.put(product.id, product.name);
            }
            // update the deal 
            for(TSGADX__Deal__c deal : [select DummyCongaDeal__c, TSGCFG__Quote__c 
                                           from TSGADX__Deal__c
                                           where TSGCFG__Quote__c in : quoteIdtoProdName.keySet()]){
                string s = ''; 
                if(quotePrimaryMap.containsKey(deal.TSGCFG__Quote__c)){
                    if(quotePrimaryMap.get(deal.TSGCFG__Quote__c)){
                        if(string.isNotBlank(deal.DummyCongaDeal__c)){
                            for(string productName : deal.DummyCongaDeal__c.split(',')){
                                list<string> s1 = productName.split('-');
                                if(s1[0] != idToProductNameMap.get(quoteIdtoProdName.get(deal.TSGCFG__Quote__c))){
                                    s += productName +',';
                                }
                            }
                        }
                    }
                    if(string.isNotBlank(s)){
                        s = s.removeEnd(',');
                        deal.DummyCongaDeal__c = s;
                        dealList.add(deal);
                    } 
                }
            }
        }
        // list of deal to update
        if(dealList.size() > 0){
            dealHelperForCommaSeparatedField.Execute_dealHelperForCommaSeparatedField = false;
            Execute_dealLineItemHelper = false;
            update dealList;
        }
    }
}