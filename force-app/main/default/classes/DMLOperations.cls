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

    public void InsertParentChild()
    {
        Date dt = Date.today();
        dt = dt.addDays(7);
        Opportunity opp = new Opportunity(
            Name='OpportunityWithAccountInsert',
            StageName='Prospecting',
            CloseDate=dt);
        
        // Create the parent reference.
        Account accRef = new Account(MyExtID__c='SAP111111');
        opp.Account = accRef;

        // Create the Account object to insert.
        Account parentAccount = new Account(Name = 'Hallie', MyExtID__c = 'SAP111111');

        Database.SaveResult[] results = Database.insert(new SObject[]{parentAccount, opp});

        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
            System.debug('Successfully created ID: '
                  + results[i].getId());
            } else {
            System.debug('Error: could not create sobject '
                  + 'for array element ' + i + '.');
            System.debug('   The error reported was: '
                  + results[i].getErrors()[0].getMessage() + '\n');
            }
        }
    }

    public void RecordsWithExternalIDs()
    {
        Opportunity newOpp = new Opportunity(
            Name = 'OpportunityWithAccountInsert',
            StageName = 'Prospecting',
            CloseDate = Date.Today().addDays(7));

        Account accountReference = new Account(MyExtID__c = 'SAP111111');

        newOpp.Account = accountReference;

        Database.SaveResult results = Database.insert(newOpp);
    }

    public void UpsertRecords()
    {
        Account[] accList = [SELECT Id, Name, BillingCity FROM Account WHERE BillingCity = 'Bombay'];
        for (Account a : accList)
        {
            a.BillingCity = 'Mumbai';
        }

        Account newAcc = new Account(Name = 'Acme', BillingCity = 'Waterloo');
        accList.add(newAcc);

        try {
           upsert accList;
        } catch (Exception e) {
           System.debug('Unexpected error: ' + e.getMessage());
        }
    }

    public void MergeRecords()
    {
        List<Account> ls = new List<Account>{
            new Account(Name = 'Acme Inc'),
            new Account(Name = 'Acme')};

        insert ls;

        Account masterAcc = [SELECT Id, Name FROM Account WHERE Name = 'Acme Inc' LIMIT 1];
        Account mergeAcc = [SELECT Id, Name FROM Account WHERE Name = 'Acme' LIMIT 1];

        Contact c = new Contact(FirstName = 'Joe', LastName = 'Merged');
        c.AccountId = mergeAcc.Id;

        insert c;

        try {
           merge masterAcc mergeAcc;
        } catch (DmlException e) {
           System.debug(e.getMessage());
        }

        // Once the account is merged with the master account,
        // the related contact should be moved to the master record.

        masterAcc = [SELECT Id, Name, (SELECT FirstName,LastName From Contacts) FROM Account WHERE Name = 'Acme Inc' LIMIT 1];
        System.assert(masterAcc.getSObjects('Contacts').size() > 0);
        System.assertEquals('Joe', masterAcc.getSObjects('Contacts')[0].get('FirstName'));
        System.assertEquals('Merged', masterAcc.getSObjects('Contacts')[0].get('LastName'));
    
        // Verify that the merge record got deleted
        Account[] result = [SELECT Id, Name FROM Account WHERE Id=:mergeAcc.Id];
        System.assertEquals(0, result.size());

    }

    public void UndeleteRecords()
    {
        Account a = new Account(Name = 'Universal Containers');
        insert a;
        insert(new Contact(LastName='Carter',AccountId=a.Id));
        delete a;

        Account[] savedAccounts = [SELECT Id, Name FROM Account WHERE Name = 'Universal Containers' ALL ROWS];
        try {
           Undelete savedAccounts;
        } catch (DmlException e) {
            System.debug(e.getMessage());           
        }
    }

    //The convertLead DML operation converts a lead into an account and contact, as well as (optionally) an opportunity. 
    //convertLead is available only as a method on the Database class; it is not available as a DML statement.
    public void ConvertLeads()
    {
        Lead mylead = new Lead(LastName = 'Fry', Company='Fry And Sons');
        insert mylead;

        Database.LeadConvert lc = new Database.LeadConvert();
        lc.setLeadId(mylead.Id);

        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted = true LIMIT 1];
        lc.setConvertedStatus(convertStatus.MasterLabel);

        Database.LeadConvertResult lcr = Database.convertLead(lc);
        System.assert(lcr.isSuccess());
    }
}
