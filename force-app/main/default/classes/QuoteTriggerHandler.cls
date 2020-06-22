/*
    Description: Class is used for Quote Trigger Helper
*/
public with sharing class QuoteTriggerHandler {
    
    public static void CreateCPCFixRateCharge(List<TSGCFG__Quote__c> lstQuotes, map<Id,TSGCFG__Quote__c> mapOldQuotes){
        
        set<Id> setQuoteFixRMchanged = new set<Id>();
        set<Id> setQuoteFRMBlank = new set<Id>();
        
        for(TSGCFG__Quote__c objQuote: lstQuotes) {
            if(objQuote.Fixed_Rate_Multiplier2__c != mapOldQuotes.get(objQuote.Id).Fixed_Rate_Multiplier2__c) { 
                system.debug('objQuote.Fixed_Rate_Multiplier2__c :::: '+objQuote.Fixed_Rate_Multiplier2__c);
                if(objQuote.Fixed_Rate_Multiplier2__c != null && objQuote.Fixed_Rate_Multiplier2__c > 0) {
                    setQuoteFixRMchanged.add(objQuote.Id);
                } else if (objQuote.Fixed_Rate_Multiplier2__c <= 0) {
                    setQuoteFRMBlank.add(objQuote.Id);
                }
            }
        }
        
        
        if(setQuoteFixRMchanged.size() > 0) {
            system.debug('setQuoteFixRMchanged ::: '+setQuoteFixRMchanged);
            List<TSGCFG__Price_Book__c> lstCPCFixRatePB = new List<TSGCFG__Price_Book__c>([select Id from TSGCFG__Price_Book__c 
                        Where (Name = 'CPC Fix Rate Charge' or TSGCFG__Product_Code__c = 'CPCFixRate') and TSGCFG__Active__c = true]);
            
            if(lstCPCFixRatePB.size() > 0) {
                List<TSGCFG__Quote_Line_Items__c> lstQuoteLineItemsToDelete = new List<TSGCFG__Quote_Line_Items__c>([Select Id from TSGCFG__Quote_Line_Items__c
                         Where TSGCFG__Quote__c in: setQuoteFixRMchanged and 
                         (TSGCFG__Product_Name__c = 'CPC Fix Rate Charge' OR TSGCFG__Product__c =: lstCPCFixRatePB[0].Id)]);
                if(lstQuoteLineItemsToDelete.size() > 0){
                    delete lstQuoteLineItemsToDelete;
                }
            }
            List<TSGCFG__Quote_Line_Items__c> lstQuoteLineItemsToInsert = new List<TSGCFG__Quote_Line_Items__c>();        
            for(TSGCFG__Quote_Line_Items__c objQLIs: [select Id,Name, TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c, 
                            TSGCFG__Quote__r.Fixed_Rate__c,TSGCFG__Quote__r.Fixed_Rate_Term__c,
                            TSGCFG__Configuration__c,TSGCFG__Quote__c,TSGCFG__Qty__c,TSGCFG__Total_Quantity__c,
                            TSGCFG__Total_Price__c from TSGCFG__Quote_Line_Items__c Where TSGCFG__Quote__c in: setQuoteFixRMchanged and
                            TSGCFG__Product_Type__c = 'Service' and TSGCFG__Product_Name__c in ('CPC Service','CPC Base','CPC Base Plus','CPC Base Minimum')]){
                
                TSGCFG__Quote_Line_Items__c newQLI = new TSGCFG__Quote_Line_Items__c();
                Decimal FixedRateMultiplier = objQLIs.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c != null ? objQLIs.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c : 0;
                
                Decimal totalprice = objQLIs.TSGCFG__Total_Price__c != null ? objQLIs.TSGCFG__Total_Price__c : 0;
                Decimal costPrice = totalprice*FixedRateMultiplier;
                newQLI.TSGCFG__Product__c = lstCPCFixRatePB[0].Id;
                newQLI.TSGCFG__Quote__c = objQLIs.TSGCFG__Quote__c;
                newQLI.TSGCFG__Configuration__c = objQLIs.TSGCFG__Configuration__c;
                
                
                newQLI.TSGCFG__Price__c = (costPrice-totalprice).setScale(2);
                newQLI.TSGCFG__Cost__c = (costPrice-totalprice).setScale(2);
                newQLI.TSGCFG__Sales_Price__c = 0;
                newQLI.TSGCFG__Sales_Uplift__c = -100;
                
                newQLI.TSGCFG__Qty__c = objQLIs.TSGCFG__Qty__c;
                newQLI.TSGCFG__Total_Quantity__c = objQLIs.TSGCFG__Total_Quantity__c;
                if(newQLI.TSGCFG__Sales_Price__c != null)  
                    newQLI.TSGCFG__Sub_Total__c = (newQLI.TSGCFG__Sales_Price__c * newQLI.TSGCFG__Qty__c).setScale(2);
                if(newQLI.TSGCFG__Sales_Price__c != null)
                    newQLI.TSGCFG__Total_Price__c = (newQLI.TSGCFG__Sales_Price__c * newQLI.TSGCFG__Total_Quantity__c).setScale(2);
                
                if(newQLI.TSGCFG__Cost__c != null)
                    newQLI.TSGCFG__Total_Cost__c = newQLI.TSGCFG__Cost__c * newQLI.TSGCFG__Total_Quantity__c;                
                lstQuoteLineItemsToInsert.add(newQLI);
            }
            
            if(lstQuoteLineItemsToInsert.size() > 0) {
                System.debug('lstQuoteLineItemsToInsert ::: '+lstQuoteLineItemsToInsert);
                TSGCFG.QuoteLineItemHelper.DO_QLI_CALCULATION = false;
                TSGCFG.QuoteLineItemHelper.VERIFY_SALES_PRICE_CHANGE = false;
                insert lstQuoteLineItemsToInsert;
                
                for(TSGCFG__Quote_Line_Items__c objQLI: lstQuoteLineItemsToInsert){
                    objQLI.TSGCFG__Sales_Price__c = 0;
                    objQLI.TSGCFG__Sales_Uplift__c = -100;
                }
                update lstQuoteLineItemsToInsert;
            }
        }
        
        if(setQuoteFRMBlank.size() > 0) {
            List<TSGCFG__Price_Book__c> lstCPCFixRatePB = new List<TSGCFG__Price_Book__c>([select Id from TSGCFG__Price_Book__c 
                        Where (Name = 'CPC Fix Rate Charge' or TSGCFG__Product_Code__c = 'CPCFixRate' ) and TSGCFG__Active__c = true]);
            if(lstCPCFixRatePB.size() > 0) {
                List<TSGCFG__Quote_Line_Items__c> lstQLIs = new List<TSGCFG__Quote_Line_Items__c>([select Id from TSGCFG__Quote_Line_Items__c
                                    Where TSGCFG__Quote__c in: setQuoteFRMBlank and TSGCFG__Product__c =: lstCPCFixRatePB[0].Id]);
                delete lstQLIs;
            }
        }
    }
}