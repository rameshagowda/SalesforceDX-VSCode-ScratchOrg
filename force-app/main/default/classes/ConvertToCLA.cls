//The following example shows how you can use SOSL over a set of records to determine their object types.
public with sharing class ConvertToCLA
{
    public ConvertToCLA() {    }

    List<Contact> contacts;
    List<Account> accounts;
    List<Lead> leads;

    public void ConvertType(Integer phoneNumber)
    {
        //'results' will hold multiple records - each record is list of fields containing Account, LEad and Contact
        List<List<SObject>> results = [FIND '4155557000' IN Phone FIELDS 
                                        RETURNING Contact(Id, Phone, FirstName, LastName),
                                        Lead(Id, Phone, FirstName, LastName),
                                        Account(Id, Phone, Name)];

        //First record in the results is a List<sObject> containing lead, contact and Account
        SObject[] records = ((List<SObject>) results[0]); 

        if (!records.isEmpty()) 
        {
           for (Integer i =0; i < records.size(); i++)
           {
               SObject record = records[i];
                if(record.getSObjectType() == Contact.sObjectType)
                {
                    contacts.add((Contact) record);
                }
                else if(record.getSObjectType() == Lead.sObjectType)
                {
                    leads.add((Lead) record);
                }
                else if(record.getSObjectType() == Account.sObjectType)
                {
                    accounts.add((Account) record);
                }
           }
        }
    }

    public void AddAccounts()
    {
        List<Account> accountList = new List<Account>();
        accountList.add(new Account(Name = 'Acme1'));
        accountList.add(new Account(Name = 'Acme2'));

        //insert accountList;

        Database.SaveResult[] srList = Database.insert(accountList, false);

        for (Database.SaveResult sr : srList)
        {
            if (sr.isSuccess())
            {
             System.debug('Successfully inserted account. Account ID = '+ sr.getId());  
            }
            else {
                    for (Database.Error err : sr.getErrors())
                    {
                        System.debug(err.getStatusCode() + ':' + err.getMessage());
                        System.debug('Account fields that affected this error: '+ err.getFields());
                    }
            }
        }
    }


}
