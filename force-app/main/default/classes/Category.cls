// A category describes a list of related queries to validate. Custom categories can be created and added to be tested.
public abstract class Category {
    private List<Query> queries = new List<Query>(); // the list of queries associated with the category
    private String name; // the title of the category
    private String description; // details on what the category is testing
    private boolean selected; // true if the category is selected for querying

    @TestVisible protected String EXTERNAL_ID_LABEL_NAME = 'ExternalId'; // constant name of the external id field (only varies in tests)

    // Each category must have its name title and a description of what it tests
    public Category (String name, String description) {
        this.name = name;
        this.description = description;
    }
    
    // returns the description of what the category is testing
    public String getDescription() {
        return this.description;
    } 
    
    // returns the list of queries that will be called 
    public List<Query> getQueries() {
        return this.queries;
    }
    
    public void setQueries(List<Query> queries) {
        this.queries = queries;
    }
    
    // returns the title of the category 
    public String getName() {
        return this.name;
    }
    
    // returns whether the category will run its queries
    public Boolean getSelected() {
        return this.selected;
    }
    
    public void setSelected(Boolean selected) {
        this.selected = selected;
    }

    public Boolean isTestPassed() {
        System.debug('#queries: ' + queries.size());
        
        for (Query q : queries) {
            if (q.getPassed() == false) {
                return false;
            }
        }
        return true;
    }

    // Each custom category will have their own validation on their queries
    public abstract void validate(Schema.SObjectType sObjectType);
    
}