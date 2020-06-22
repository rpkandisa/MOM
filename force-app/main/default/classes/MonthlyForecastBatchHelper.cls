public with sharing class MonthlyForecastBatchHelper {

	public static string findAllMonthlyDealRecords(){
		string soql = 'select Id,Name,TSGADX__Sales_Team__c,RecordType.DeveloperName,TSGADX__Type__c, ' +
                    'TSGADX__Total_Dollars__c,TSGADX__Agedays__c,TSGADX__Deal_Activity_Monitor__c,TSGADX__Sales_Stage__c,' +
                    'TSGADX__Close_Date__c,Next_Steps__c,RecordType.Name,Hardware_Revenue_Dollars__c,' +
                    'Owner.Name,TSGADX__Price__c,Deal_Activity_Monitor_Color__c,TSGADX__Forecast_Category__c ' +
                    ' from TSGADX__Deal__c WHERE TSGADX__Close_Date__c = THIS_MONTH ';
		return soql;
	}

	public static void callMonthlyForecastBatch(){
		Sales_Team_Setting__c salesTeamcustomsetting = Sales_Team_Setting__c.getOrgDefaults();
        List<string> lstForecastCategory = new List<string>();
        if(salesTeamcustomsetting != null && salesTeamcustomsetting.Forecast_Category__c != null){
            lstForecastCategory = salesTeamcustomsetting.Forecast_Category__c.split(',');
        }		
		string Soql = findAllMonthlyDealRecords() + ' and TSGADX__Forecast_Category__c in: lstForecastCategory';

		MonthlyForecastBatch mfbatch = new MonthlyForecastBatch(Soql, lstForecastCategory); 
		Database.executeBatch(mfbatch,1);
	}
	
	public static void forecastRevenueProcess(List<TSGADX__Deal__c> lst) {
		for(TSGADX__Deal__c deal : lst){
			string revenue='0';
        	Decimal totalRevenue=0;
			if(deal.RecordType.Name == 'Production Deals') {
				if(deal.TSGADX__Price__c != null) {
					revenue = deal.TSGADX__Price__c.setScale(0).format();
				} else {
					revenue = '0';
				}    
			} 
			else {
				if(deal.RecordType.Name == 'Equipment Deals') {
					if(deal.TSGADX__Price__c != null) {
						revenue = deal.Hardware_Revenue_Dollars__c.setScale(0).format();
					} else {
						revenue = '0';
					}    
				} 
				else {
					if(deal.TSGADX__Total_Dollars__c != null) {
						revenue = deal.TSGADX__Total_Dollars__c.setScale(0).format();
					} else {
						revenue = '0';
					}
				}
			} 
			totalRevenue = decimal.valueof(revenue.replace(',',''));

			deal.Monthly_Forecast__c = totalRevenue;
		}

		if(lst != null && lst.size()>0){
			update lst;
		}

	}
}