public with sharing class MaintenanceRequestHelper {
            
    public static void createNewMaintenanceRequest(Map<Id, Case> casesToBeProcessed) {        
        List<Case> casesToBeCreated = new list<Case>();
        List<Product2> relatedProducts = new List<Product2>();
        Map<Id, Integer> mapProduct = new Map<Id, Integer>();

        List<Equipment_Maintenance_Item__c> maintenanceRequestItems = [
                            SELECT Equipment__c, Maintenance_Request__c
                            FROM Equipment_Maintenance_Item__c
                            WHERE Maintenance_Request__c IN: casesToBeProcessed.keySet()
                            WITH SECURITY_ENFORCED
                            ];
        
        for (Equipment_Maintenance_Item__c maintenanceRequestItem : maintenanceRequestItems) {        
            Product2 product = new Product2(); 
            product.Id = maintenanceRequestItem.Equipment__c;
            if (product.Id != null) {
                relatedProducts.add(product);
            }
        }

        for (Product2 p : relatedProducts) {        
                if(p.Maintenance_Cycle__c != null){
                    mapProduct.put(p.Id, Integer.valueOf(p.Maintenance_Cycle__c));               
            }
        }

        //If there is more than 1 related equipment, find the smallest maintenance cycle
Integer smallestMaintenanceCycle = null;

// Iterate over the map values to find the value for smallestMaintenanceCycle
for (Integer value : mapProduct.values()) {
    if (smallestMaintenanceCycle == null || value < smallestMaintenanceCycle) {
        smallestMaintenanceCycle = value;
    }
}
        
        for (Case cs :casesToBeProcessed.values()) {

	        if(cs.Status == 'Closed' && (cs.Type == 'Repair' || cs.Type == 'Routine Maintenance')) {
            Case maintR = new Case();
	        maintR.Type = 'Routine Maintenance';
	        maintR.Subject = 'Routine Maintenance - ' + cs.Subject;
            maintR.Status = 'New';
	        maintR.Date_Reported__c = Date.today();
            maintR.Vehicle__c = cs.Vehicle__c;
            maintR.Product__c = cs.ProductId;
            maintR.ParentId = cs.Id;
            maintR.AccountId = cs.AccountId;
            maintR.ContactId = cs.ContactId;
            maintR.AssetId = cs.AssetId;
            maintR.Origin = cs.Origin;
            maintR.Reason = cs.Reason;
            if(mapProduct.size() == 1) {
            maintR.Date_Due__c = (mapProduct.get(cs.Id) != null) ? (Date.today().addDays(Integer.valueOf(mapProduct.get(cs.Id)))) : (Date.today());
            }
            else         
        
        If(!casesToBeCreated.IsEmpty()) {
        insert as user casesToBeCreated;
        }
    }
}

}

}