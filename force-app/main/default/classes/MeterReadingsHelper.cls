/*
    Created by Kandisa Technologies
    Date: 2nd November
*/
public class MeterReadingsHelper {

    //Function to update isLatest field
    public static void updateIsLatest(List<Meter_Reading__c> meterList){
        
        System.debug('Inside');
        // Set of All Equipment Ids
        Set<Id> set_EquipIDs = new Set<Id>();

        // Set of All Meter Types updated by
        set<String> meterTypeSet = new set<String>();

        // Set of Meter Type + Equipment Id
        Set<String> meterTypeEquipmentIdSet = new Set<String>();

        for(Meter_Reading__c meterReading : meterList) {
            if(meterReading.Equipment__c != null && String.isNotBlank(meterReading.Meter_Type__c)) {
                set_EquipIDs.add(meterReading.Equipment__c);
                meterTypeSet.add(meterReading.Meter_Type__c);

                // Create Key
                String key = meterReading.Meter_Type__c + meterReading.Equipment__c;

                // Check if Key is already in Set. If not, mark this as the Latest
                if(!meterTypeEquipmentIdSet.contains(key)) {
                    meterTypeEquipmentIdSet.add(key);
                    meterReading.Is_Latest__c = true;    
                }
            }
        }    
        
        if(set_EquipIDs.isEmpty() || meterTypeSet.isEmpty())
            return;

        // Make all Past Records of the Equipment and Type as null        

        List<Meter_Reading__c> markNotLatestList = new List<Meter_Reading__c>();
        
        //Querying the record which have field Is_Latest=true and updating the field
        for(Meter_Reading__c meterReading : [Select Is_Latest__c, Meter_Type__c, Equipment__c 
                                                            From    Meter_Reading__c
                                                            WHERE   Is_Latest__c = true
                                                     AND     Meter_Type__c IN :metertypeSet  
                                                            AND     Equipment__c IN :set_EquipIDs
                                                            AND     Meter_Type__c != null
                                                            AND     Equipment__c != null]){
        

            String key = meterReading.Meter_Type__c + meterReading.Equipment__c;

            if(meterTypeEquipmentIdSet.contains(key)) {
                meterReading.Is_Latest__c = false;
                markNotLatestList.add(meterReading);
            }
        }
        
        // Update Previous Meter Reading Records
        update markNotLatestList;
    }

    //Function to update the isLatest field to true of already existing records
    public static void updateExistingIsLatest(Set<ID> set_EquipIDs){
        
        // Set of Meter Type + Equipment Id
        Set<String> meterTypeEquipmentIdSet = new Set<String>();
        List<Meter_Reading__c> updateList = new List<Meter_Reading__c>();

        for(Meter_Reading__c meterReading : [Select Is_Latest__c, Meter_Type__c, Equipment__c 
                                                            From    Meter_Reading__c
                                                            WHERE   Equipment__c IN :set_EquipIDs
                                                            AND     Meter_Type__c != null
                                                            AND     Equipment__c != null
                                                            ORDER BY CreatedDate DESC]) {

            // Create Key
            String key = meterReading.Meter_Type__c + meterReading.Equipment__c;

            // Check if Key is already in Set. If not, mark this as the Latest
            if(!meterTypeEquipmentIdSet.contains(key)) {
                meterTypeEquipmentIdSet.add(key);
                meterReading.Is_Latest__c = true;
                updateList.add(meterReading);
            }
                
        }

        if(!updateList.isEmpty())
            update updateList;
                
    }
}