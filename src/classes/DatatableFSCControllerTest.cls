@IsTest
public class DatatableFSCControllerTest {
    
    @IsTest
    public static void test_updateRecords(){
        
        Contact newContact = new Contact( firstName = 'Test', lastName = 'Contact' );
        insert newContact;
        
        SObject newObject = newContact;
        newObject.put( 'firstName', 'Prospect' );
        
        Test.startTest();
        DatatableFSCController.upsertRecords( new List<SObject>{ newObject } );
        Test.stopTest();
        
        newContact = [ SELECT firstName FROM Contact LIMIT 1 ];
        System.assertEquals( true, newContact.firstName.equalsIgnoreCase ( 'Prospect' ) );
    }
    
    @IsTest
    public static void test_insertRecords(){
        
        SObject newObject = new Contact();
        newObject.put( 'firstName', 'Prospect' );
        newObject.put( 'lastName', 'Contact' );
        
        Test.startTest();
        DatatableFSCController.upsertRecords( new List<SObject>{ newObject } );
        Test.stopTest();
        
        Contact newContact = [ SELECT firstName FROM Contact LIMIT 1 ];
        System.assertEquals( 'Prospect', newContact.firstName );
    }
}