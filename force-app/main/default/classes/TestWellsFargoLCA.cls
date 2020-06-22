@isTest(SeeAllData=true) 
private class TestWellsFargoLCA
{
    static testMethod void testMethodbuild_WF_Email() {

        String wfcontent = '{"request_app_no":"11062014-02113","equipment_type":"New","lease_finance_amnt":"50,000","lease_payment_amnt":"1,000","lease_term":"36","lease_type":"FMV","customer_name":"Good Gadget Company","customer_addr":"4747 Lake Forest Drive","customer_city":"CINCINNATI","customer_state":"OH","customer_zip":"45242","customer_phone":"513-791-0909","customer_inbusiness_as":"","customer_business_type":"Limited Liability Company","industry":"Manufacturing/Industrial","customer_fed_tax_id":"","cust_contact_fname":"Joe","cust_contact_lname":"Smith","application_comments":"","contact2_fname":"Dave","contact2_lname":"Bandy","contact2_email":"dbandy@momnet.com","contact2_phone":"513-791-0909","contact3_fname":"","contact3_email":""}';

        MOM_Lease_Credit_App_WellsFargo.build_WF_Email('11062014-02113', wfcontent, 'dbandy@momnet.com');  

   }

}