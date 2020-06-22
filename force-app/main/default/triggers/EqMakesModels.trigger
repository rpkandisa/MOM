trigger EqMakesModels on TSGADX__Equipment__c (after insert, after update, after delete) {
    EA_Settings__c sett = EA_Settings__c.getInstance();
    
    if(sett != null && sett.Enable_EQMakesModels__c){
        Set<Id> accIds = new Set<Id>();
        if(Trigger.isInsert){
            for(TSGADX__Equipment__c eq : Trigger.new){
                accIds.add(eq.TSGADX__Business__c);
            }
        }
        else if(Trigger.isUpdate){
            for(TSGADX__Equipment__c en : Trigger.new){
                TSGADX__Equipment__c eo = System.Trigger.oldMap.get(en.Id);
                if(en.TSGADX__Make__c != eo.TSGADX__Make__c || en.TSGADX__Model__c != eo.TSGADX__Model__c) accIds.add(en.TSGADX__Business__c);
                if(en.TSGADX__Business__c != eo.TSGADX__Business__c) accIds.add(eo.TSGADX__Business__c); 
            }
        }
        else if(Trigger.isDelete){
            for(TSGADX__Equipment__c eq : Trigger.old){
                accIds.add(eq.TSGADX__Business__c);
            }
        }
        
        Account[] accs = [Select Id, Name, Equipment_Makes__c, Equipment_Models__c from Account where Id in :accIds];
        map<id,list<TSGADX__Equipment__c>> accEqMap = new map<id,list<TSGADX__Equipment__c>>();
        for(TSGADX__Equipment__c eq : [Select Id, Name, TSGADX__Make__c, TSGADX__Model__c, TSGADX__Business__c
                                       from TSGADX__Equipment__c 
                                       where TSGADX__Business__c in : accIds and TSGADX__Inactive__c = false]){
            if(accEqMap.containsKey(eq.TSGADX__Business__c))
                accEqMap.get(eq.TSGADX__Business__c).add(eq);
            else
                accEqMap.put(eq.TSGADX__Business__c,new list<TSGADX__Equipment__c>{eq});
        }
        String oldMakes = '';
        String oldModels = '';
        String newMakes = '';
        String newModels = '';
        for(Account acc : accs){
            
            oldMakes = acc.Equipment_Makes__c;
            oldModels = acc.Equipment_Models__c;
            newMakes = '';
            newModels = '';
            Set<String> makeSet = new Set<String>();
            Set<String> modelSet = new Set<String>();
            List<String> makes = new List<String>();
            List<String> models = new List<String>();

            if(accEqMap.containsKey(acc.Id)){
                for(TSGADX__Equipment__c eq : accEqMap.get(acc.id)){
                    makeSet.add(eq.TSGADX__Make__c);
                    modelSet.add(eq.TSGADX__Model__c);
                }
            }
            
            
            //convert to list and sort
            makes.addAll(makeSet);
            models.addAll(modelSet);
            makes.sort();
            models.sort();
            
            for(String make : makes){
                newMakes = newMakes + make + ',';
            }
            for(String model : models){
                newModels = newModels + model + ',';
            }
            if(newMakes.endsWith(',')) newMakes = newMakes.substring(0,newMakes.length()-1);
            if(newModels.endsWith(',')) newModels = newModels.substring(0,newModels.length()-1);
            if(oldMakes != newMakes){
                if(newMakes.length() > 255) acc.Equipment_Makes__c = newMakes.substring(0,255);
                else acc.Equipment_Makes__c = newMakes;
            }
            if(oldModels != newModels){
                if(newModels.length() > 255) acc.Equipment_Models__c = newModels.substring(0,255);
                else acc.Equipment_Models__c = newModels;
            }
            if(oldMakes != newMakes || oldModels != newModels) update acc;
        }
    }
}