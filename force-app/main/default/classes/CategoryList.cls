// Add your custom categories to this list
public class CategoryList {
    private List<Category> categoryList;
    
    public CategoryList(Map<String, Schema.SObjectType> gd, String objString) {
        categoryList = new List<Category>();
        addSampleCategories();
    }
    
    // Create instances of the categories, then add them to the category list 
    // Add any custom categories in this method 
    public void addSampleCategories() {
        categoryList.add(new SelectCategory('Select Queries', 'Tests the SELECT keyword'));
        categoryList.add(new OrderCategory('Order Queries', 'Tests the ability to order query results in ascending and descending order'));
        categoryList.add(new IdCategory('Id Queries', 'Checks for duplicate IDs in the external data'));
        categoryList.add(new InsertCategory('Insert/Delete Queries', 'Tests insertion of an object and its deletion (requires write access to external data source). TIP: Modify InsertCategory.cls to define fields and values for your objects. WARNING: This may have unwanted effects on your external data source. It is highly recommended it is used on a sandbox data source.'));
    }
    
    public List<Category> getCategoryList() {
        return categoryList;
    }
}