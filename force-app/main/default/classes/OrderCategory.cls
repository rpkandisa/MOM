// Category with queries that tests the ability to order query results in ascending and descending order
public virtual class OrderCategory extends Category {
    private String orderFieldName;
    
    public OrderCategory(String name, String description) {
        super(name, description);
    }
    
    // Creating the queries to test order
    private void setOrderQueries(Schema.SObjectType sObjectType) {
        String objString = sObjectType.getDescribe().getName();

        Schema.DescribeSObjectResult result = sObjectType.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<Schema.SObjectField> fieldList = fieldsMap.values();
        
        List<Query> orderQueries = new List<Query>();
        for (Schema.SObjectField field: fieldList) {
            Schema.DisplayType fieldType = field.getDescribe().getType();
            if (String.valueOf(fieldType) == 'String') {
                this.orderFieldName = field.getDescribe().getName();
                try {
                    
                    String ascQueryString = 'SELECT ' + orderFieldName + ' FROM ' + objString + ' ORDER BY ' + orderFieldName + ' ASC NULLS LAST LIMIT 5';
                    String descQueryString = 'SELECT ' + orderFieldName + ' FROM ' + objString + ' ORDER BY ' + orderFieldName + ' DESC NULLS LAST LIMIT 5';
                    
                    Query ascQuery = new Query(ascQueryString, 'Ascending order', this);
                    Query descQuery = new Query(descQueryString, 'Descending order', this);
                    
                    orderQueries.add(ascQuery);
                    orderQueries.add(descQuery);
                    
                    break;
                } catch (Exception e) {
                    continue;
                }
            }
        }

        setQueries(orderQueries);
    }
    
    public override void validate(Schema.SObjectType sObjectType) {
        setOrderQueries(sObjectType);

        for (Query query: this.getQueries()) {
            String testQuery = query.getQuery();
            try {
                List<sObject> sobjList = Database.query(query.getQuery()); 
                if (sobjList.size() != 0) {
                    if (testQuery.contains('ASC') && !checkAscQueries(sobjList, sObjectType)) {
                        query.setQueryFailed('Incorrect results', 'The expected sorted list didn\'t match the actual sorted list.');
                    } else if (testQuery.contains('DESC') && !checkDescQueries(sobjList, sObjectType)) {
                        query.setQueryFailed('Incorrect results', 'The expected sorted list didn\'t match the actual sorted list.');
                    } else {
                        query.setQueryPassed();
                    }
                } else {
                    query.setQueryFailed('No records found', 'The query ran but didn\'t return any records.');
                }
            } catch (Exception e) {
                query.setQueryFailed(e.getTypeName(), e.getMessage());
            }
        }  
    }
    
    // Checking if the returned objects are in ASC order
    private boolean checkAscQueries(List<sObject> stringValueASC, Schema.SObjectType sObjectType) {
        List<String> orderQueries = new List<String>();
        Schema.DescribeSObjectResult result = sObjectType.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<String> testingOrderQueries = new List<String>();
        List<String> testingOrderQueriesSorted = new List<String>();
        Integer testingOrderQueriesSize = 5;
        if (stringValueASC.size() < 5) {
            testingOrderQueriesSize = stringValueASC.size();
        }
        for (Integer i = 0; i < testingOrderQueriesSize; i++) {
            String ascString = (String)(stringValueASC.get(i).get(orderFieldName));
            testingOrderQueries.add(ascString);
            testingOrderQueriesSorted.add(ascString);
        }
        testingOrderQueriesSorted.sort();

        for (Integer i = 0; i < testingOrderQueriesSize; i++) {
            if (testingOrderQueries.get(i) != testingOrderQueriesSorted.get(i)) {
                return false;
            }
        }

        return true;
    }
    
    // Checking if the returned objects are in DESC order
    private boolean checkDescQueries(List<sObject> stringValueDESC, Schema.SObjectType sObjectType) {
        List<String> orderQueries = new List<String>();
        Schema.DescribeSObjectResult result = sObjectType.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<String> testingOrderQueries = new List<String>();
        List<String> testingOrderQueriesSorted = new List<String>();
        Integer testingOrderQueriesSize = 5;
        if (stringValueDESC.size() < 5) {
            testingOrderQueriesSize = stringValueDESC.size();
        }  
        for (Integer i = 0; i < testingOrderQueriesSize; i++)
        {
            String descString = (String)(stringValueDESC.get(i).get(orderFieldName));
            testingOrderQueries.add(descString);
            testingOrderQueriesSorted.add(descString);
        } 
        testingOrderQueriesSorted.sort();
        
        for (Integer i = 0; i < testingOrderQueriesSize; i++) {
            if (testingOrderQueries.get(testingOrderQueriesSize-i-1) != testingOrderQueriesSorted.get(i)) {
                return false;
            }
        }
        return true;
    }
}