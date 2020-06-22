// External data sources don't have mock test endpoints. To test the Salesforce connector
// test suite, custom objects are created and run as stand-in for external objects.
@isTest
private class TestValidator {
    // Utility method to populate database
    public static void setUpTestData() {
        TestExternalObject__c teo1 = new TestExternalObject__c(ExternalId__c = 'id1');
        TestExternalObject__c teo2 = new TestExternalObject__c(ExternalId__c = 'id2');
        TestExternalObject__c teo3 = new TestExternalObject__c(ExternalId__c = 'id3');

        insert teo1;
        insert teo2;
        insert teo3;
    }

    // Tests CategoryList
    static testMethod void testCategoryList() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        String objString = '';

        CategoryList cl = new CategoryList(gd, objString);

        List<Category> l = cl.getCategoryList();
        System.assert(cl.getCategoryList().size() == 4);
    }

    // Tests IdCategory
    @isTest static void testIdCategory() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

        // Overwrite external object to custom object
        String objString = 'TestExternalObject__c';

        Schema.SObjectType sObjectType = gd.get(objString);

        String catName = 'testName';
        String catDesc = 'testDescription';

        // Create category
        IdCategory idCategory = new IdCategory(catName, catDesc);
        idCategory.setSelected(true);

        // Overwrite external id field to reflect custom object API
        updateExternalIdLabel(idCategory);

        // Test getters
        System.assert(catName.equals(idCategory.getName()));
        System.assert(catDesc.equals(idCategory.getDescription()));
        System.assert(idCategory.getSelected() == true);

        // Test on empty table
        idCategory.validate(sObjectType);
        System.assert(idCategory.isTestPassed() == true);

        // Add test data without duplicates
        setUpTestData();
        idCategory.validate(sObjectType);

        System.assert(idCategory.isTestPassed() == true);

        // Now insert two duplicate objects
        TestExternalObject__c dup1 = new TestExternalObject__c(ExternalId__c = '0001');
        TestExternalObject__c dup2 = new TestExternalObject__c(ExternalId__c = '0001');

        insert dup1;
        insert dup2;

        idCategory.validate(sObjectType);

        System.assert(idCategory.isTestPassed() == false);
    }

    // Tests OrderCategory
    @isTest static void testOrderCategory() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

        // Overwrite external object to custom object
        String objString = 'TestExternalObject__c';

        Schema.SObjectType sObjectType = gd.get(objString);

        String catName = 'testName';
        String catDesc = 'testDescription';

        // Create category
        OrderCategory orderCategory = new OrderCategory(catName, catDesc);
        orderCategory.setSelected(true);

        // Overwrite external id field to reflect custom object API
        updateExternalIdLabel(orderCategory);

        // Test getters
        System.assert(catName.equals(orderCategory.getName()));
        System.assert(catDesc.equals(orderCategory.getDescription()));
        System.assert(orderCategory.getSelected() == true);

        // Add test data
        setUpTestData();
        orderCategory.validate(sObjectType);

        System.assert(orderCategory.isTestPassed() == true);
    }

    // Tests SelectCategory
    @isTest static void testSelectCategory() {
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();

        // Overwrite external object to custom object
        String objString = 'TestExternalObject__c';

        Schema.SObjectType sObjectType = gd.get(objString);

        String catName = 'testName';
        String catDesc = 'testDescription';

        // Create category
        SelectCategory selectCategory = new SelectCategory(catName, catDesc);
        selectCategory.setSelected(true);

        // Overwrite external id field to reflect custom object API
        updateExternalIdLabel(selectCategory);

        // Test getters
        System.assert(catName.equals(selectCategory.getName()));
        System.assert(catDesc.equals(selectCategory.getDescription()));
        System.assert(selectCategory.getSelected() == true);


        // Test on empty table
        selectCategory.validate(sObjectType);
        System.assert(selectCategory.isTestPassed() == false);

        // Add test data and test
        setUpTestData();
        selectCategory.validate(sObjectType);
        System.assert(selectCategory.isTestPassed() == true);
    }

    // Tests PostSyncValidator
    @isTest static void testValidator() {
        PostSyncValidator psv = new PostSyncValidator();

        setUpTestData();

        // Render first page
        psv.firstPage();

        CategoryList cl = new CategoryList(Schema.getGlobalDescribe(), 'TestExternalObject__c');
        for (Category c : cl.getCategoryList()) {
            updateExternalIdLabel(c);
        }

        // Overwrite external object to custom object
        psv.objString = 'TestExternalObject__c';

        psv.categoryList = cl.getCategoryList();

        // Add all possible categories
        psv.selectAllCategories = true;
        psv.selectAll();

        // Render second page
        psv.secondPage();

        psv.runQueries();

        System.assert(psv.showPassTable);

        // Now insert two duplicate objects
        TestExternalObject__c dup1 = new TestExternalObject__c(ExternalId__c = '0001');
        TestExternalObject__c dup2 = new TestExternalObject__c(ExternalId__c = '0001');

        insert dup1;
        insert dup2;

        psv.runQueries();

        System.assert(psv.showFailTable && psv.showPassTable);
    }

    // Tests getters and setters for Query and QueryWrapper
    @isTest static void testQueries() {
        String catName = 'testName';
        String catDesc = 'testDescription';

        // Create category
        SelectCategory selectCategory = new SelectCategory(catName, catDesc);

        Query q = new Query('SELECT ExternalId FROM TestExternalObject__c', 'description', selectCategory);
        q.setQueryPassed();

        System.assertEquals(q.getDescription(), 'description');
        System.assertEquals(q.getQuery(), 'SELECT ExternalId FROM TestExternalObject__c');
        System.assert(q.getPassed() == true);

        q.setQueryFailed('error', 'error message');

        System.assertEquals(q.getErrorMessage(), 'error message');
        System.assertEquals(q.getErrorType(), 'error');

        System.assertEquals(q.getCategory().getName(), 'testName');
    }

    private static void updateExternalIdLabel(Category category) {
        category.EXTERNAL_ID_LABEL_NAME = category.EXTERNAL_ID_LABEL_NAME + '__c';
    }
}