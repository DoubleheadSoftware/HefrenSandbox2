public class DatatableFSCController {
    
    /* method to generically create or update records passed from 
     * the datatableFSC component */
    @AuraEnabled
    public static void upsertRecords( List<SObject> objectList ){
        
        List<SObject> sObjectsToInsert = new List<SObject>();
        List<SObject> sObjectsToUpdate = new List<SObject>();
        
        // checks each record passed in for an id
        // if an id is present, add it to a list to update
        // if no id, add it to a list to insert
        for( SObject o : objectList ){
            
            Boolean hasId = o.id != null && String.isNotBlank( o.id );
            if( hasId ){
                
                sObjectsToUpdate.add( o );
            }else{
                
                sObjectsToInsert.add( o );
            }
        }

		Boolean hasRecordsToInsert = sObjectsToInsert != null && !sObjectsToInsert.isEmpty();
        if( hasRecordsToInsert ){
            insert sObjectsToInsert;
        }        

        Boolean hasRecordsToUpdate = sObjectsToUpdate != null && !sObjectsToUpdate.isEmpty();
        if( hasRecordsToUpdate ){
            update sObjectsToUpdate;
        }        
    }
}