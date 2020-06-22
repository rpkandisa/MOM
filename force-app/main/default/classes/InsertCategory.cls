// Category with queries that tests the ability to insert and delete queries from an external data source
public virtual class InsertCategory extends Category {
    public InsertCategory(String name, String description) {
        super(name, description);
    }

    public override void validate(Schema.SObjectType sObjectType) {
        String objString = sObjectType.getDescribe().getName();

        List<Query> queries = new List<Query>();
        this.setQueries(queries);

        List<Query> queryCategorySelectList = new List<Query>();

        // obj can be defined programmatically based on the object you want to test
        // e.g. Product2__x obj = new Product2__x(Name__c='Mac Pro', ProductCode__c='MP11');
        sObject obj = sObjectType.newSObject();

        Schema.DescribeSObjectResult result = sObjectType.getDescribe();
        Map<String,Schema.SObjectField> fieldsMap = result.fields.getMap();
        List<Schema.SObjectField> fieldList = fieldsMap.values();

        String queryFields = '';
        String queryValues = '';

        boolean objectCreated;
        
        // Set values for relevant fields of obj
        for (Schema.SObjectField field: fieldList) {
            try {
            Schema.DescribeFieldResult fieldResult = field.getDescribe();
                if ((fieldResult.isNameField() && !fieldResult.isAutoNumber()) ||
                    ( fieldResult.isAccessible() &&
                      fieldResult.isUpdateable() &&
                      fieldResult.isCustom() &&
                      fieldResult.getReferenceTo().size() > 0 &&
                     !fieldResult.isDefaultedOnCreate())) {
    
                    // More data types and respective values can be added here
                    if (fieldResult.getType() == Schema.DisplayType.STRING) {
                        obj.put(field, 't000xTESTING');
                        queryValues = queryValues + '\'t000xTESTING\'' + ', ';
                    } else if (fieldResult.getType() == Schema.DisplayType.INTEGER) {
                        obj.put(field, 10);
                        queryValues = queryValues + '\'10\'' + ', ';
                    } else if (fieldResult.getType() == Schema.DisplayType.BOOLEAN) {
                        obj.put(field, 0);
                        queryValues = queryValues + '\'0\'' + ', ';
                    } else if (fieldResult.getType() == Schema.DisplayType.DOUBLE) {
                        obj.put(field, 10.0);
                        queryValues = queryValues + '\'10.0\'' + ', ';
                    }
    
                    queryFields = queryFields + fieldResult.getName() + ', ';
                }
            } catch (Exception e) {
                objectCreated = false;
                break;
            }
            objectCreated = true;
        }

        // Count initial number of records
        Integer initialCount = Database.countQuery('SELECT count() FROM ' + objString);

        // Validate insertion
        String queryString = objectCreated ? 'INSERT INTO ' + objString + ' (' + queryFields.substring(0, queryFields.length() - 2) +
                ') VALUES (' + queryValues.substring(0, queryValues.length() - 2) + ')' : 'NaN';
        Query insertQuery = new Query(queryString, 'Tests insertion of an object', this);

        if (objectCreated) {
            try {
                if (sObjectType.getDescribe().isCreateable()) {
                    // Database.insertImmediate(obj);
    
                    // Check counts
                    Integer currentCount = Database.countQuery('SELECT count() FROM ' + objString);
                    if (currentCount == initialCount + 1) {
                        insertQuery.setQueryPassed();
                    } else {
                        insertQuery.setQueryFailed('Insertion error', 'No additional record detected. TIP: Modify InsertCategory.cls to define fields and values for your objects.');
                    }
                } else {
                    insertQuery.setQueryFailed('No write access error', 'You do not have write access for this external object');
                }
            } catch (Exception e) {
                insertQuery.setQueryFailed(e.getTypeName(), e.getMessage());
            }
        } else {
            insertQuery.setQueryFailed('Object building failed', 'Could not build an sample object to insert');
        }

        queries.add(insertQuery);

        // Test deletion if insertion passed
        if (this.isTestPassed()) {
            // Validate deletion
            Query deleteQuery = new Query('DELETE FROM ' + objString + ' WHERE ...', 'Tests deletion of the inserted object', this);

            try {
                if (sObjectType.getDescribe().isDeletable()) {
                    Database.deleteImmediate(obj);

                    // Check counts
                    Integer currentCount = Database.countQuery('SELECT count() FROM ' + objString);
                    if (currentCount == initialCount) {
                        deleteQuery.setQueryPassed();
                    } else {
                        deleteQuery.setQueryFailed('Deletion error', 'The current number of records does not match the initial number. It is recommended you check that there are no garbage values in your table.');
                    }
                } else {
                    deleteQuery.setQueryFailed('Deletion error', 'You do not have permission to delete this external object');
                }
            } catch (Exception e) {
                deleteQuery.setQueryFailed(e.getTypeName(), e.getMessage());
            }

            queries.add(deleteQuery);
        }
    }
}