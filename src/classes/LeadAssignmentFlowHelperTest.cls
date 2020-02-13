@isTest
public class LeadAssignmentFlowHelperTest {

    @TestSetup
    public static void setupData(){
        
        User u = [ SELECT id, email FROM User WHERE email != null and isActive = true and profile.name = 'System Administrator' order by id asc LIMIT 1 ];
        
        Lead newLead = new Lead(
        	lastName = 'lastName',
            company = 'lastName',
            ownerId = u.id
        );
        insert newLead; 
        
        Group newGroup = new Group(
        	name = 'Test Group'
        );        
        insert newGroup;
        
        GroupMember newMember = new GroupMember( 
        	userOrGroupId = u.id,
            groupId = newGroup.id
        );        
        insert newMember;
    }
    
    @isTest
    public static void test_getUserEmailAddresses(){

        Lead newLead = [ SELECT ownerId FROM lead LIMIT 1 ];
        User u = [ SELECT id, email FROM User WHERE id = :newLead.ownerId LIMIT 1 ];
        
        Test.startTest();
        List<String> emailAddresses = LeadAssignmentFlowHelper.getUserEmailAddresses( new List<Lead>{ newLead } );
        Test.stopTest();
        
        System.assertEquals( true, emailAddresses[0].contains( u.email ) );
    }     
}