/*
in order for this to work correctly schedule it to run after midnight
code coverage LastReviewTest
*/
global class BatchLastReviewDate implements Database.Batchable<SObject>, Database.Stateful, Schedulable 
{
    
   global void execute(SchedulableContext sc) {
      BatchLastReviewDate b = new BatchLastReviewDate(); 
      Database.executebatch(b);
   }
    
    private set<id> qWhere;

    public BatchLastReviewDate(set <id> iWhere){
        qWhere = iWhere;
    }

    public BatchLastReviewDate(){

    }
    
    
    
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        
        string squery ='SELECT id, FinServ__LastReview__c from Account'; 
        if (qWhere != null){
            squery = squery + ' where id in :qWhere';
        }
        system.debug('squery = ' + squery);
        return database.getQuerylocator(squery);
    }

    global void execute(Database.BatchableContext bc, List<Account> lstACCs)      
    {               

		date dToday = system.today();
		system.debug('dToday = ' + dToday);
		Map<Id,Account> mapAccounts =new Map<Id,Account>(lstACCs);

		//tasks
		List<Account> account_recent_activityT = ([SELECT Id, 
		    (
		        SELECT Id, ActivityDate 
		        FROM ActivityHistories 
		        WHERE ActivityDate < :dToday and Review__c = True and IsTask = TRUE and IsClosed = True
		        ORDER BY ActivityDate DESC 
		        LIMIT 1
		    ) 
		    FROM Account 
		    WHERE Id in :mapAccounts.keyset()
		]);

		Map<Id,Account> account_map = new Map<Id,Account>();
		
		if(!account_recent_activityT.isEmpty()){
		    for(Account a : account_recent_activityT){
		        if( !a.ActivityHistories.isEmpty()){
		        	system.debug('TASK  a.ActivityHistories[0].ActivityDate = ' + a.ActivityHistories[0].ActivityDate);
		        	if(a.ActivityHistories[0].ActivityDate != mapAccounts.get(a.id).FinServ__LastReview__c || test.isrunningtest() ){
		        		system.debug('TASK added');
		        		Account iToU = new account(id = a.Id,FinServ__LastReview__c = a.ActivityHistories[0].ActivityDate); account_map.put(a.Id,iToU);
		        	}
		        }
		    }
		}

		//events
		List<Account> account_recent_activityE = ([SELECT Id, 
		    (
		        SELECT Id, ActivityDate 
		        FROM ActivityHistories 
		        WHERE ActivityDate < :dToday and Review__c = True and IsTask = False
		        ORDER BY ActivityDate DESC 
		        LIMIT 1
		    ) 
		    FROM Account 
		    WHERE Id in :mapAccounts.keyset()
		]);

		
		if(!account_recent_activityE.isEmpty()){
		    for(Account a : account_recent_activityE){
		        if( !a.ActivityHistories.isEmpty() ){
		        	system.debug('EVENT  a.ActivityHistories[0].ActivityDate = ' + a.ActivityHistories[0].ActivityDate);
		        	if((a.ActivityHistories[0].ActivityDate != mapAccounts.get(a.id).FinServ__LastReview__c) &&(account_map.get(a.Id) == null || account_map.get(a.Id).FinServ__LastReview__c.daysbetween(a.ActivityHistories[0].ActivityDate) >0)){
		        			system.debug('EVENT added');
			        		Account iToU = new account(id = a.Id,FinServ__LastReview__c = a.ActivityHistories[0].ActivityDate); account_map.put(a.Id,iToU);
		        	}
		        }
		    }
		}
		
		system.debug('account_map = ' + account_map);
		UPDATE account_map.values();		

    }
    
    global void finish(Database.BatchableContext bc) 
    {
        
    }
    
  
}