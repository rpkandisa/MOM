global class MonthlyForecastBatchSchedulable implements Schedulable {
	global void execute(SchedulableContext sc) {		
		MonthlyForecastBatchHelper.callMonthlyForecastBatch();
	}
}