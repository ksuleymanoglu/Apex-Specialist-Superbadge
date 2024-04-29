trigger MaintenanceTrigger on Case (before insert, 
                                    after update, 
                                    after delete, 
                                    after undelete) {
    switch on Trigger.operationType {        
        when AFTER_UPDATE {
           MaintenanceRequestHelper.createNewMaintenanceRequest(Trigger.new);
        }
    }
}
