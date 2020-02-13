public class LeadAssignmentFlowHelper {
    
    @InvocableMethod( label = 'getUserEmailAddresses' description = 'takes a list of user ids and returns a list of their email addresses' )
    public static List<String> getUserEmailAddresses( List<Lead> leads ){
        
        List<String> emailAddresses = new List<String>();        
        
        List<String> leadOwnerIds = new List<String>();
        
        // get the owner for each lead passed in
        for( Lead lead : leads ){
            leadOwnerIds.add( lead.ownerId );
        }
        
        List<String> groupIds = new List<String>();
        
        // identify the public groups to notify
        for( GroupMember member : [ SELECT groupId FROM GroupMember WHERE userOrGroupId IN :leadOwnerIds AND group.type = 'Regular' ] ){
            groupIds.add( member.groupId );
        }
        
        Boolean hasGroupIds = groupIds != null && !groupIds.isEmpty();	
        
        // only query if userIds has a value
        if( hasGroupIds ){
            
            // gets full list of group members based on the identified public groups
            List<GroupMember> members = [ SELECT userOrGroupId FROM GroupMember WHERE groupId IN :groupIds ];
            
            List<String> memberIds = new List<String>();
            
            for( GroupMember member : members ){
                memberIds.add( member.userOrGroupId );
            }
            
            // gets email addresses for group members
            List<User> users = [ SELECT id, email FROM User WHERE id IN :memberIds ];
            
            for( User u : users ){
                emailAddresses.add( u.email );
            }
        }
        
        // passes back a list with a comma separated string of email addresses
        // if a flow calls this method it assigns the first index in the list to a variable
        String commaSeparatedEmailAddresses = String.join(emailAddresses, ',' );
        emailAddresses.clear();
        emailAddresses.add( commaSeparatedEmailAddresses );
        return emailAddresses;
    }
}