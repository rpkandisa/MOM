trigger EmailTrackingStatisticsTrigger on wbsendit__Campaign_Activity__c (before insert, before update, before delete,
                                                                            after insert, after update, after delete, after undelete) {
    EmailTrackingStatisticsTriggerHandler controller = new EmailTrackingStatisticsTriggerHandler(trigger.new, trigger.old, trigger.newMap, trigger.oldMap, trigger.isInsert,
                                                            trigger.isUpdate, trigger.isDelete, trigger.isUndelete, trigger.isAfter, trigger.isBefore);    
    TSGADX.taskConnectorHelper.calledFromBatch = true;
    if(trigger.isBefore){
        if(trigger.isInsert){
            controller.beforeInsertEvent();
        }else if(trigger.isUpdate){
            controller.beforeUpdateEvent();
        }else if(trigger.isDelete){
            controller.beforeDeleteEvent();
        }
    }else if(trigger.isAfter){
        if(trigger.isInsert){
            controller.afterInsertEvent();
        }else if(trigger.isUpdate){
            controller.afterUpdateEvent();
        }else if(trigger.isDelete){
            controller.afterDeleteEvent();
        }else if(trigger.isUndelete){
            controller.afterUndeleteEvent();
        }
    }                                                        
}
/*  Deactived via Julie Italiano Request 6/27/2019 */