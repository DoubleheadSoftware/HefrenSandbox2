//code coverage LastReviewTest
public with sharing class EventTriggerHelper {

	ReviewTriggersDisabled__c lst = ReviewTriggersDisabled__c.getOrgDefaults();
    Boolean bDisabled = lst.IsDisabled__c;
    
     public void afterinsert(list<Event> lstNewEvent,map<id,Event> mapNewEvent,map<id,Event> mapOldEvent){

		map<id,date> mapAccDate = new map<id,date>();
		String EventWhatId;
    	String EventWhatObjectType;
    
     	for(Event EventItem : lstNewEvent){
			EventWhatId = EventItem.WhatId;
            system.debug('EventWhatId = ' + EventWhatId);
            if (EventWhatId != null)
            {
				EventWhatObjectType = EventItem.WhatId.getSObjectType().getDescribe().getName();
				//system.debug('Eventitem.ActivityDate.daysbetween(system.today() = ' + Eventitem.ActivityDate.daysbetween(system.today()));
	            if (EventWhatObjectType == 'Account' && EventItem.review__c == true && !bDisabled && Eventitem.ActivityDate != null && Eventitem.ActivityDate.daysbetween(system.today())>=0 ){			
			 		//setAccountsToUpdate.add(EventItem.whatid);
			 		mapAccDate.put(EventItem.whatid,EventItem.ActivityDate);
	            }
			}
		}
     	system.debug('mapAccDate.isempty() = ' + mapAccDate.isempty());
     	if(!mapAccDate.isempty()){
     		
     		list<account> lstUpAcc = [select id, FinServ__LastReview__c from account where id in :mapAccDate.keyset()];
     		for(account iACC :lstUpAcc){
     			if(iACC.FinServ__LastReview__c == null || iACC.FinServ__LastReview__c.daysbetween(mapAccDate.get(iACC.id)) > 0 ){
					iACC.FinServ__LastReview__c =mapAccDate.get(iACC.id);
     			} 
     		}
     		update lstUpAcc;
     	}
     	
     }
     public void afterupdate(list<Event> lstNewEvent,map<id,Event> mapNewEvent,map<id,Event> mapOldEvent){
     	   	
		map<id,date> mapAccDate = new map<id,date>();
		String EventWhatId;
    	String EventWhatObjectType;
    
     	for(Event EventItem : lstNewEvent){
			EventWhatId = EventItem.WhatId;
            system.debug('EventWhatId = ' + EventWhatId);
            if (EventWhatId != null)
            {
				EventWhatObjectType = EventItem.WhatId.getSObjectType().getDescribe().getName();
				system.debug('Eventitem.ActivityDate.daysbetween(system.today() = ' + Eventitem.ActivityDate.daysbetween(system.today()));
	            if (EventWhatObjectType == 'Account' && EventItem.review__c == true && !bDisabled && Eventitem.ActivityDate.daysbetween(system.today())>=0 &&
	            (EventItem.review__c !=mapOldEvent.get(EventItem.id).review__c   || EventItem.ActivityDate !=mapOldEvent.get(EventItem.id).ActivityDate)){			
			 		//setAccountsToUpdate.add(EventItem.whatid);
			 		mapAccDate.put(EventItem.whatid,EventItem.ActivityDate);
	            }
			}
		}
     	system.debug('mapAccDate.isempty() = ' + mapAccDate.isempty());
     	if(!mapAccDate.isempty()){
     		
     		list<account> lstUpAcc = [select id, FinServ__LastReview__c from account where id in :mapAccDate.keyset()];
     		for(account iACC :lstUpAcc){
     			if(iACC.FinServ__LastReview__c == null || iACC.FinServ__LastReview__c.daysbetween(mapAccDate.get(iACC.id)) > 0 ){
					iACC.FinServ__LastReview__c =mapAccDate.get(iACC.id);
     			} 
     		}
     		update lstUpAcc;
     	}
     	
     	
     	
     }
     
}