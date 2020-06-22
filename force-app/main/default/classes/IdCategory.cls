// Category with queries that check for duplicate Ids in the external data
public virtual class IdCategory extends Category {
    public IdCategory(String name, String description) {
        super(name, description);
    }

    // Creates a query that checks for duplicate IDs
    // Example: SELECT ExternalId FROM googleDrive__x WHERE ExternalId ='0B4z2gzEmkDDCLURPQU0zRzNOOEE' LIMIT 2
    public void setIdQueries(Schema.SObjectType sObjectType) {
        String objString = sObjectType.getDescribe().getName();
        // Testing duplicate IDs
        List<Query> queries = new List<Query>();
        String idListQuery = 'SELECT ' + EXTERNAL_ID_LABEL_NAME + ' FROM ' + objString;
        List<sObject> idQueryList = Database.query(idListQuery);

        Map<String, Boolean> duplicateIDMap = new Map<String, Boolean>();

        for (sObject obj: idQueryList) {
            String objId = (String) (obj.get(EXTERNAL_ID_LABEL_NAME));
            if (duplicateIDMap.get(objID) == null) {
                duplicateIDMap.put(objID, true);
            } else {
                String duplicateIdQuery = 'SELECT ' + EXTERNAL_ID_LABEL_NAME + ' FROM ' + objString + ' WHERE ' + EXTERNAL_ID_LABEL_NAME + ' =\'' + objId + '\' LIMIT 2';
                queries.add(new Query(duplicateIdQuery, 'Duplicate ID', this));
                break;
            }
        }
        if (queries.size() == 0 && idQueryList.size() > 0) {
            String duplicateIdQuery = 'SELECT ' + EXTERNAL_ID_LABEL_NAME + ' FROM ' + objString + ' WHERE ' + EXTERNAL_ID_LABEL_NAME + ' =\'' + (String)(idQueryList.get(0).get(EXTERNAL_ID_LABEL_NAME)) + '\' LIMIT 2';
            queries.add(new Query(duplicateIdQuery, 'Duplicate ID', this));
        }
        
        setQueries(queries);
    }
    
    public override void validate(Schema.SObjectType sObjectType) {
        setIdQueries(sObjectType);

        for (Query query: this.getQueries()) {
            try {
                List<sObject> sobjList = Database.query(query.getQuery()); 
                if (sobjList.size() != 0) {
                    if (sobjList.size() == 2) {
                        query.setQueryFailed('External Object Error', 'A duplicate ID exists.');
                    } else {
                        query.setQueryPassed();
                    }
                }
            } catch (Exception e) {
                query.setQueryFailed(e.getTypeName(), e.getMessage());
            }
        }
    }
}