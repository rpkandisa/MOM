global class MonthlyForecastBatch implements Database.Batchable<sObject> {
	
	global final String Query;
	global final List<String> lstForecastCategory;	
	global MonthlyForecastBatch(string 	q, List<String> lstForecastCategory) {
		this.Query = q;		
		this.lstForecastCategory = lstForecastCategory;
	}
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {
		   MonthlyForecastBatchHelper.forecastRevenueProcess((List<TSGADX__Deal__c>)scope);
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}