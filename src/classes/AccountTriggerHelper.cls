public with sharing class AccountTriggerHelper {

    private static Id HHAccRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
    private static Id InstitutionAccRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Institution').getRecordTypeId();
    
    // single method to be called from account trigger for all
    // after update calls
    public static void handleAfterUpdate(){

        startAccountOwnershipChanges();
    }
    
    // method that controls the logic for updating account ownership
    public static void startAccountOwnershipChanges(){
    
        List<Id> accountIdsWithOwnerChanges = getAccountsWithOwnerChanges( Trigger.new, Trigger.old );

        Boolean hasOwnerChanges = accountIdsWithOwnerChanges != null && !accountIdsWithOwnerChanges.isempty();

        if( hasOwnerChanges ){
            updateRelationshipGroupAccountOwners( accountIdsWithOwnerChanges );
            updateFinancialAccountOwners( accountIdsWithOwnerChanges );
        }
    }

     public void HouseHoldNameInsert(List<Account> newAcc){
      set<id> aid = new set<id>();
      for(Account a:newAcc){
        if(a.Primary_HH_Member__c != null){
          aid.add(a.id);
        }
      }
      
      if(!aid.isempty()){
        list<account> lstA = [select id from Account where id in :aid];
        update lstA;
      }
    }

  @InvocableMethod(label='HouseHoldName' description='Renames the acount based on Primary and Secondary names')
    public static  void HouseHoldName(List<Account> newAcc){
      Id HHAccRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Household').getRecordTypeId();
      
      system.debug('newAcc = ' + newAcc);
      
      Map<Id,Account> mapUAccsPre=new Map<Id,Account>(newAcc);
      
      
      map<id, Account> mapUaccs = new map<id, Account>([Select id, name, Primary_HH_Member__c,Primary_HH_Member__r.FirstName, Primary_HH_Member__r.LastName,
                    Secondary_HH_Member__c, Secondary_HH_Member__r.FirstName, Secondary_HH_Member__r.LastName from Account where id in :mapUAccsPre.keyset()]);
           
            
      for(Account a : newAcc ){

        Boolean isHousehold = a.recordtypeid == HHAccRecordtypeId;

        if( isHousehold ){

            Boolean hasPrimaryMember = mapUaccs.get(a.id).Primary_HH_Member__c != null;
            Boolean hasSecondaryMember = mapUaccs.get(a.id).Secondary_HH_Member__c != null;
            Boolean hasNoSecondaryMember = mapUaccs.get(a.id).Secondary_HH_Member__c == null;

            Boolean membersHaveSameLastName = mapUaccs.get(a.id).Primary_HH_Member__r.LastName == mapUaccs.get(a.id).Secondary_HH_Member__r.LastName;
            Boolean membersHaveDifferentLastName = mapUaccs.get(a.id).Primary_HH_Member__r.LastName != mapUaccs.get(a.id).Secondary_HH_Member__r.LastName;

            String primaryLastName = mapUaccs.get(a.id).Primary_HH_Member__r.LastName;
            String primaryFirstName = mapUaccs.get(a.id).Primary_HH_Member__r.FirstName;
            String secondaryLastName = mapUaccs.get(a.id).Secondary_HH_Member__r.LastName;
            String secondaryFirstName = mapUaccs.get(a.id).Secondary_HH_Member__r.FirstName;

            if( hasPrimaryMember && hasSecondaryMember && membersHaveSameLastName ){
                system.debug('same last');                
                a.name = primaryLastName + ', '+ primaryFirstName + ' & '+ secondaryFirstName;
            }
            if( hasPrimaryMember && hasSecondaryMember && membersHaveDifferentLastName ){
                system.debug('diff last');
                a.name = primaryLastName + ', '+ primaryFirstName + ' & '+ secondaryFirstName + ' ' + secondaryLastName;
            }
            
            if( hasPrimaryMember && hasNoSecondaryMember ){
                system.debug('only primary');
                a.name = primaryLastName + ', '+ primaryFirstName;
            }                  
        }
      }    

      if( Trigger.isExecuting == false ){
          update newAcc;
      }  
        
    }  
    
    /*----------------------------- private methods ----------------------------*/

    // returns list of ids of households or institutions who's owner has changed
    // this should be called after update
    private static List<Id> getAccountsWithOwnerChanges( List<Account> updatedAccounts, List<Account> oldAccounts ){

        // holds ids of accounts that are either households or institutions
        // and their owner has been changed
        List<Id> accountIdsWithOwnerChanges = new List<Id>();

        for( Integer i = 0; i < updatedAccounts.size(); i++ ){

            Account updatedAccount = updatedAccounts[i];
            Account oldAccount = oldAccounts[i];

            Boolean isHousehold = HHAccRecordtypeId == updatedAccount.recordtypeid;
            Boolean isInstitution = InstitutionAccRecordtypeId == updatedAccount.recordtypeid;
            Boolean ownerChanged = updatedAccount.ownerId != null && updatedAccount.ownerId != oldAccount.ownerId;

            if( ( isHousehold || isInstitution ) && ownerChanged ){
                accountIdsWithOwnerChanges.add( updatedAccount.id );
            }
        }       

        return accountIdsWithOwnerChanges;
    }     
    
    // returns list of account contact relations related to the accountIds passed in
    // the account's owner will become the owner of the contact's account
    private static List<AccountContactRelation> getRelatedACRs( List<Id> accountIdsWithOwnerChanges ){

        return 
        [ 
            SELECT account.ownerid, contact.accountId
            FROM AccountContactRelation
            WHERE accountId IN :accountIdsWithOwnerChanges AND FinServ__PrimaryGroup__c = true 
        ];
    }

    // returns list of financial accounts related to the accountIds passed in
    // the owner will be set to the owner of the related account, which will be
    // either the household or the primary owner
    private static List<FinServ__FinancialAccount__c> getRelatedFinancialAccounts( List<Id> accountIdsWithOwnerChanges ){

        return 
        [
            SELECT id, ownerId, FinServ__Household__r.ownerId, FinServ__PrimaryOwner__r.ownerId
            FROM FinServ__FinancialAccount__c
            WHERE FinServ__Household__c IN :accountIdsWithOwnerChanges OR FinServ__PrimaryOwner__c IN :accountIdsWithOwnerChanges
        ];

    }
    
    // method that will update the owners of account related through 
    // account contact relations
    @future
    private static void updateRelationshipGroupAccountOwners( List<Id> accountIdsWithOwnerChanges ){

        List<AccountContactRelation> acrList = getRelatedACRs( accountIdsWithOwnerChanges );
        List<Account> accountsToUpdate = new List<Account>();
    
        for( AccountContactRelation acr : acrList ){

            // updates the related contact's account's owner to the owner of the primary account
            Account accountToUpdate = new Account( 
                id = acr.contact.accountId,
                ownerId = acr.account.ownerId
            );

            accountsToUpdate.add( accountToUpdate );
        }

        update accountsToUpdate;
    }

    // method that will update owners of financial
    // the ids passed into this method are account ids who's owner has changed
    @future
    private static void updateFinancialAccountOwners( List<Id> accountIdsWithOwnerChanges ){

        List<FinServ__FinancialAccount__c> financialAccountsList = getRelatedFinancialAccounts( accountIdsWithOwnerChanges );
        List<FinServ__FinancialAccount__c> financialAccountsToUpdate = new List<FinServ__FinancialAccount__c>();

        for( FinServ__FinancialAccount__c financialAccount : financialAccountsList ){

            Id householdOwnerId = financialAccount.FinServ__Household__r.ownerId;
            Id primaryOwnerId = financialAccount.FinServ__PrimaryOwner__r.ownerId;

            Boolean hasHousehold = String.isNotBlank( (String) householdOwnerId );
            Boolean hasPrimaryOwner = String.isNotBlank( (String) primaryOwnerId );
            Boolean hasChanged = false;

            // sets the owner of the financial account based on whether it has a household or a primary owner account
            if( hasHousehold ){

                financialAccount.ownerId = householdOwnerId;
                hasChanged = true;
                
            }else if( hasPrimaryOwner ){

                financialAccount.ownerId = primaryOwnerId;
                hasChanged = true;
            }

            if( hasChanged ){
                financialAccountsToUpdate.add( financialAccount );
            }
        }

        update financialAccountsToUpdate;
    }
}