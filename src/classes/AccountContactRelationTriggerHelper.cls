public with sharing class AccountContactRelationTriggerHelper {

    
    
    public void addHouseHold (Map<id,AccountContactRelation> newMap, Map<id,AccountContactRelation> oldMap){
    	
    	
    	List<AccountContactRelation> acrs= new List<AccountContactRelation>(); 
		if(newMap != null){
			system.debug('newMap = ');
			acrs= [select id, Account.id,Contact.id,Account.RecordType.Name, Contact.Account.id,FinServ__PrimaryGroup__c,FinServ__Primary__c,Contact.Household__c,roles from AccountContactRelation where id in:newMap.Keyset()];
		}
		else{
			system.debug('oldMap = ');
			acrs= [select id, Account.id,Contact.id,Account.RecordType.Name, Contact.Account.id,FinServ__PrimaryGroup__c,FinServ__Primary__c,Contact.Household__c,roles from AccountContactRelation where id in:oldMap.Keyset()];
		}
		

    	List<Contact> contactListToUpdate = new List<Contact>();
    	List<Account> accountListToUpdate = new List<Account>();
    	
    	//get the account first... can't just do the update of the field
    	set<id> setAccIds = new set<id>();
    	set<id> setContIds = new set<id>();
    	map<id,id> mapConToPA = new map<id,id>();
    	
    	
    	for(AccountContactRelation arc:acrs){
    		setAccIds.add(arc.Account.id);
    		setContIds.add(arc.Contact.id);
    	}
    	system.debug('setContIds = ' + setContIds);
    	Map<id,Contact> acrContactRelation = new Map<id,Contact>([select id,Household__c from contact where id in :setContIds]);
    	list<Account> lstAcrACC = [select id, Primary_HH_Member__c, Secondary_HH_Member__c from Account where id in : setAccIds];
		
		Id indAccRecordtypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual').getRecordTypeId();
		
		list<Account> personAccounts = [Select id, PersonContactId From Account Where PersonContactId in :setContIds];
		if(!personAccounts.isempty()){
			system.debug('personAccounts = ' + personAccounts);
			
			for(Account pa :personAccounts){
				mapConToPA.put(pa.PersonContactId, pa.id);  //person account id of the contact
			}
		}
		else if(indAccRecordtypeId != NULL){
			list<Contact> IndAccounts = [Select id, AccountId From Contact Where Id in :setContIds and Account.recordtypeid = :indAccRecordtypeId];
			system.debug('IndAccounts = ' + IndAccounts);
			
			for(Contact pa :IndAccounts){
				mapConToPA.put(pa.Id, pa.Accountid);  //person account id of the contact
			}
		}		    	
    	//this adds anything that needs added because of the changes
		for(Account iAcrACC :lstAcrACC){
	       	for(AccountContactRelation arc:acrs){
	       		if(iAcrACC.id == arc.account.id){
		            system.debug('##'+arc);
		            //new map = null means it is a delete
		            if(newMap ==null ||newMap.isEmpty()){
						system.debug('new map = null');
						if(iAcrACC.Primary_HH_Member__c  == arc.Contact.id){ // && (arc.FinServ__PrimaryGroup__c && arc.FinServ__Primary__c)){
							system.debug('remove primary deleted');
							iAcrACC.Primary_HH_Member__c = null;
						}
						if(iAcrACC.Secondary_HH_Member__c == arc.Contact.id){   // && !arc.FinServ__PrimaryGroup__c  || arc.FinServ__Primary__c || (!arc.roles.contains('Client') && !arc.roles.contains('Spouse') && !arc.roles.contains('Domestic Partner'))){
							system.debug('remove secondary deleted');
							iAcrACC.Secondary_HH_Member__c  = null;
						}
		            }
		            else{
			            //old map = null means it is an insert
			       		if((arc.FinServ__PrimaryGroup__c && (oldMap ==null ||oldMap.isEmpty()))|| (arc.FinServ__PrimaryGroup__c && !oldMap.get(arc.id).FinServ__PrimaryGroup__c)){
								//arc.Contact.Household__c = arc.Contact.Account.id;
								 Contact c = acrContactRelation.get(arc.Contact.id);
								 c.Household__c=arc.Account.id;
								 contactListToUpdate.add(c);
								 
								 
								 Account a = new account();	
								 system.debug('arc.Contactid = ' + arc.Contactid);
								 system.debug('arc.Contact.id = ' + arc.Contact.id);
								 system.debug('mapConToPA.get(arc.Contact.id);' + mapConToPA.get(arc.Contact.id));							 
								 a.id = mapConToPA.get(arc.Contact.id);
								 a.Household_id__c=arc.Account.id;
								 a.Household__c =arc.Account.id;  //added 11/12/2018
								 accountListToUpdate.add(a);
						}
						//add it an insert or an update					
						if(arc.FinServ__PrimaryGroup__c  && arc.FinServ__Primary__c){
							if(((oldMap ==null ||oldMap.isEmpty()) || ((arc.FinServ__PrimaryGroup__c != !oldMap.get(arc.id).FinServ__PrimaryGroup__c) || (arc.FinServ__Primary__c != !oldMap.get(arc.id).FinServ__Primary__c))))	{
								system.debug('add primary');
								iAcrACC.Primary_HH_Member__c = arc.Contact.id;
							}
						}
						//remove it on an update
						if(!arc.FinServ__PrimaryGroup__c  || !arc.FinServ__Primary__c){
							if(iAcrACC.Primary_HH_Member__c == arc.Contact.id && ((oldMap !=null ) || ((arc.FinServ__PrimaryGroup__c != !oldMap.get(arc.id).FinServ__PrimaryGroup__c) || (arc.FinServ__Primary__c != !oldMap.get(arc.id).FinServ__Primary__c)))){
								system.debug('remove primary');
								iAcrACC.Primary_HH_Member__c = null;
							}
						}
						
						//add it
						//debugs... why didnot it hit
						if(arc.FinServ__PrimaryGroup__c  && !arc.FinServ__Primary__c && (arc.roles.contains('Member') && (arc.roles.contains('Spouse') || arc.roles.contains('Domestic Partner')))){
							/*		
							system.debug('add secondary');
							system.debug('oldMap = ' + oldMap);
							system.debug('arc.FinServ__PrimaryGroup__c = ' + arc.FinServ__PrimaryGroup__c);
							system.debug('oldMap.get(arc.id).FinServ__PrimaryGroup__c = ' + oldMap.get(arc.id).FinServ__PrimaryGroup__c);
							system.debug('arc.FinServ__Primary__c = ' + arc.FinServ__Primary__c);
							system.debug('oldMap.get(arc.id).FinServ__Primary__c = ' + oldMap.get(arc.id).FinServ__Primary__c);
							system.debug('arc.roles = ' + arc.roles);
							system.debug('oldMap.get(arc.id).roles = ' + oldMap.get(arc.id).roles);
						 	*/
						 	
						 	if((oldMap ==null ||oldMap.isEmpty()) || ((arc.FinServ__PrimaryGroup__c != oldMap.get(arc.id).FinServ__PrimaryGroup__c) || (arc.FinServ__Primary__c != oldMap.get(arc.id).FinServ__Primary__c) ||(arc.roles != oldMap.get(arc.id).roles))){
						 		system.debug('add the secondary');
								iAcrACC.Secondary_HH_Member__c  = arc.Contact.id;
							}
						}
						
						//remove it
						if(iAcrACC.Secondary_HH_Member__c == arc.Contact.id && ((oldMap !=null) && ((arc.FinServ__PrimaryGroup__c != oldMap.get(arc.id).FinServ__PrimaryGroup__c) || (arc.FinServ__Primary__c != oldMap.get(arc.id).FinServ__Primary__c) ||(arc.roles != oldMap.get(arc.id).roles)))){
							system.debug('remove secondary?');
							if(!arc.FinServ__PrimaryGroup__c  || arc.FinServ__Primary__c || (!arc.roles.contains('Member') && (!arc.roles.contains('Spouse') || !arc.roles.contains('Domestic Partner')))){
								system.debug('remove secondary');
								iAcrACC.Secondary_HH_Member__c  = null;
							}
						}
		            }
	       		}					
	       	}
		}
	
    	if(!contactListToUpdate.isEmpty()){
    		update contactListToUpdate;
    	}

    	if(!accountListToUpdate.isEmpty()){
    		update accountListToUpdate;
    	}
    	
    	if(!lstAcrACC.isEmpty()){
    		update lstAcrACC;
    	}
    }
    
}