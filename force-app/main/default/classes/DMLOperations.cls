public with sharing class DMLOperations {
    public DMLOperations() {    }

    public void InsertAccounts()
    {
        Account[] accts = new List<Account>();
        for(Integer i = 0; i < 3; i++)
        {
            Account a = New Account(Name = 'Acme'+i, BillingCity = 'San Francisco');
            accts.add(a);
        }

        Account accToUpdate;

        try {
           insert accts;

           accToUpdate = [SELECT BillingCity FROM Account WHERE Name = 'Acme2' AND BillingCity = 'San Francisco' LIMIT 1];
           accToUpdate.BillingCity = 'New york';
           update accToUpdate;
            } 
        catch (DmlException e) 
        {
           System.debug('Unexpected error occured : ' + e.getMessage());
        }

        Account accAfterupdate = [SELECT BillingCity FROM Account WHERE Id = :accToUpdate.Id];
        System.assertEquals('New york', accAfterupdate.BillingCity);
    }

    public void InsertRelatedRecords()
    {
        try 
        {
           Account acc = new Account(Name = 'SFDC Account');
           Insert acc;

           ID accID = acc.Id;

           Contact con = new Contact(
               FirstName = 'Joe',
               LastName = 'Smith',
               Phone='415.555.1212',
               AccountId = accID);

            insert con;
        } 
        catch (DmlException e) {
            System.debug('unexpected error:' +e.getMessage());
           
        }
    }

    public void UpdateRelatedRecords()
    {
        try 
        {
            Contact queriedContact = [SELECT Account.Name 
                                    FROM Contact 
                                    WHERE FirstName = 'Joe' AND LastName = 'Smith' LIMIT 1];
        
            queriedContact.Phone = '415.555.1213';
            queriedContact.Account.Industry = 'Technology';

            update queriedContact;
            update queriedContact.Account;
        }
        catch(Exception e)
        {
            System.debug('unexpected error :'+ e.getMessage());
        }
    }
}
