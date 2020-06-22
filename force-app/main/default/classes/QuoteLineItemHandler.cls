/*
    class for updating the deals field on changing the qty on qli
*/
public with sharing class QuoteLineItemHandler {
    
    public static boolean Execute_QuoteLineItemHandler = true;
    
    public static void UpateCPCFixRateCharge(List<TSGCFG__Quote_Line_Items__c> lstQuoteLineItems, 
                map<Id,TSGCFG__Quote_Line_Items__c> mapOldQuoteLineItems){
        
        set<Id> setQLIQuoteId = new set<Id>();
        set<Id> setQLIConfigId = new set<Id>();
        
        
        set<string> setProductNames = new set<string>();
        setProductNames.add('CPC Service');
        setProductNames.add('CPC Base');
        setProductNames.add('CPC Base Plus');
        setProductNames.add('CPC Base Minimum');
        
        map<string,Decimal> mapQLIWiseTotal = new map<string,Decimal>();
        // && (mapOldQuoteLineItems == null ||
         //       objQLI.TSGCFG__Total_Price__c != mapOldQuoteLineItems.get(objQLI.Id).TSGCFG__Total_Price__c)
        
        for(TSGCFG__Quote_Line_Items__c objQLI: [select Id, Name, TSGCFG__Product__c, TSGCFG__Product__r.Name,TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c,
                     TSGCFG__Total_Price__c,TSGCFG__Quote__c, TSGCFG__Configuration__c from TSGCFG__Quote_Line_Items__c Where Id in:lstQuoteLineItems ]) {
            if(objQLI.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c != null && objQLI.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c > 0 && setProductNames.contains(objQLI.TSGCFG__Product__r.Name)) { 
                setQLIQuoteId.add(objQLI.TSGCFG__Quote__c);
                setQLIConfigId.add(objQLI.TSGCFG__Configuration__c);
                mapQLIWiseTotal.put(objQLI.TSGCFG__Quote__c+'#'+objQLI.TSGCFG__Configuration__c,objQLI.TSGCFG__Total_Price__c);
            }
        }
        if(setQLIQuoteId.size() > 0 && setQLIConfigId.size() > 0){
            List<TSGCFG__Quote_Line_Items__c> lstQuoteLineItemsToUpsert = new List<TSGCFG__Quote_Line_Items__c>();
            
            if(mapOldQuoteLineItems == null){
                List<TSGCFG__Price_Book__c> lstCPCFixRatePB = new List<TSGCFG__Price_Book__c>([select Id from TSGCFG__Price_Book__c 
                        Where (Name = 'CPC Fix Rate Charge' or TSGCFG__Product_Code__c = 'CPCFixRate' ) and TSGCFG__Active__c = true]);
                if(lstCPCFixRatePB.size() > 0) {

                    map<Id,Decimal> mapQuoteFRM = new map<Id,Decimal>();
                    for(TSGCFG__Quote__c objQuote: [select Id,Name,Fixed_Rate_Multiplier2__c from TSGCFG__Quote__c Where Id in: setQLIQuoteId]){
                        if(objQuote.Fixed_Rate_Multiplier2__c  != null && objQuote.Fixed_Rate_Multiplier2__c > 0){
                            mapQuoteFRM.put(objQuote.Id, objQuote.Fixed_Rate_Multiplier2__c);
                        }
                    }
                    
                    for(string strKey: mapQLIWiseTotal.keyset()){
                        string strQuoteId = strKey.split('#')[0];
                        string strConfigId = strKey.split('#')[1];
                        if(mapQuoteFRM.containskey(strQuoteId)){
                            Decimal FixedRateMultiplier = mapQuoteFRM.get(strQuoteId);
                            Decimal totalprice = mapQLIWiseTotal.get(strKey) != null ? mapQLIWiseTotal.get(strKey) : 0;
                            Decimal costPrice = totalprice*FixedRateMultiplier;
                            
                            TSGCFG__Quote_Line_Items__c qlitoupdate = new TSGCFG__Quote_Line_Items__c ();    
                            qlitoupdate.TSGCFG__Quote__c = strQuoteId;
                            qlitoupdate.TSGCFG__Configuration__c = strConfigId;
                            qlitoupdate.TSGCFG__Product__c = lstCPCFixRatePB[0].Id;
                            qlitoupdate.TSGCFG__Price__c = (costPrice-totalprice).setScale(2);
                            qlitoupdate.TSGCFG__Cost__c = (costPrice-totalprice).setScale(2);
                            qlitoupdate.TSGCFG__Sales_Price__c = 0;
                            qlitoupdate.TSGCFG__Sales_Uplift__c = -100;
                            qlitoupdate.TSGCFG__Qty__c = 1;
                            qlitoupdate.TSGCFG__Total_Quantity__c = 1;
                            if(qlitoupdate.TSGCFG__Sales_Price__c != null)  
                                qlitoupdate.TSGCFG__Sub_Total__c = (qlitoupdate.TSGCFG__Sales_Price__c * 1).setScale(2);
                            if(qlitoupdate.TSGCFG__Sales_Price__c != null)
                                qlitoupdate.TSGCFG__Total_Price__c = (qlitoupdate.TSGCFG__Sales_Price__c * 1).setScale(2);
                            
                            if(qlitoupdate.TSGCFG__Cost__c != null)
                                qlitoupdate.TSGCFG__Total_Cost__c = qlitoupdate.TSGCFG__Cost__c * 1;
                            
                            lstQuoteLineItemsToUpsert.add(qlitoupdate);
                        }
                    }
                }
            }
            
            for(TSGCFG__Quote_Line_Items__c objQLIs: [select Id,Name, TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c, 
                            TSGCFG__Price__c,TSGCFG__Cost__c,TSGCFG__Sales_Price__c,TSGCFG__Sales_Uplift__c,
                            TSGCFG__Sub_Total__c,TSGCFG__Total_Cost__c ,
                            TSGCFG__Quote__r.Fixed_Rate__c,TSGCFG__Quote__r.Fixed_Rate_Term__c,
                            TSGCFG__Configuration__c,TSGCFG__Quote__c,TSGCFG__Qty__c,TSGCFG__Total_Quantity__c,
                            TSGCFG__Total_Price__c from TSGCFG__Quote_Line_Items__c Where TSGCFG__Quote__c in: setQLIQuoteId and
                            TSGCFG__Configuration__c in: setQLIConfigId and TSGCFG__Product_Name__c = 'CPC Fix Rate Charge']){
                string strKey = objQLIs.TSGCFG__Quote__c + '#' + objQLIs.TSGCFG__Configuration__c;
                if(mapQLIWiseTotal.containskey(strKey)) {
                    
                    Decimal FixedRateMultiplier = objQLIs.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c != null ? objQLIs.TSGCFG__Quote__r.Fixed_Rate_Multiplier2__c : 0;
                    Decimal totalprice = mapQLIWiseTotal.get(strKey) != null ? mapQLIWiseTotal.get(strKey) : 0;
                    Decimal costPrice = totalprice*FixedRateMultiplier;
                    
                    TSGCFG__Quote_Line_Items__c qlitoupdate = new TSGCFG__Quote_Line_Items__c ();    
                    qlitoupdate.Id = objQLIs.Id;
                    qlitoupdate.TSGCFG__Price__c = (costPrice-totalprice).setScale(2);
                    qlitoupdate.TSGCFG__Cost__c = (costPrice-totalprice).setScale(2);
                    qlitoupdate.TSGCFG__Sales_Price__c = 0;
                    qlitoupdate.TSGCFG__Sales_Uplift__c = -100;
                    system.debug('objQLIs.TSGCFG__Total_Quantity__c ::: '+objQLIs.TSGCFG__Total_Quantity__c);
                    if(qlitoupdate.TSGCFG__Sales_Price__c != null)  
                        qlitoupdate.TSGCFG__Sub_Total__c = (qlitoupdate.TSGCFG__Sales_Price__c * objQLIs.TSGCFG__Qty__c != null ? objQLIs.TSGCFG__Qty__c : 1).setScale(2);
                    if(qlitoupdate.TSGCFG__Sales_Price__c != null)
                        qlitoupdate.TSGCFG__Total_Price__c = (qlitoupdate.TSGCFG__Sales_Price__c * objQLIs.TSGCFG__Total_Quantity__c != null ? objQLIs.TSGCFG__Total_Quantity__c : 1).setScale(2);
                    
                    if(qlitoupdate.TSGCFG__Cost__c != null)
                        qlitoupdate.TSGCFG__Total_Cost__c = qlitoupdate.TSGCFG__Cost__c * objQLIs.TSGCFG__Total_Quantity__c != null ? objQLIs.TSGCFG__Total_Quantity__c : 1;
                    
                    lstQuoteLineItemsToUpsert.add(qlitoupdate);
                }
            }
            
            if(lstQuoteLineItemsToUpsert.size() > 0) {
                //system.debug('lstQuoteLineItemsToUpdate :::: '+lstQuoteLineItemsToUpsert);
                TSGCFG.QuoteLineItemHelper.DO_QLI_CALCULATION = false;
                TSGCFG.QuoteLineItemHelper.VERIFY_SALES_PRICE_CHANGE = false;
                //QuoteLineItemHandler.Execute_QuoteLineItemHandler = false;
                upsert lstQuoteLineItemsToUpsert;
            }
        }
    }
}