@isTest
public with sharing class HelloWorldTestClass {
    @isTest static void ValidateHelloWorld()
    {
        Book__c b = new Book__c(Name = 'Behind the Cloud', Price__c = 100);
        System.debug('Price before inserting new book: ' + b.Price__c);

        insert b;

        b = [SELECT Price__c FROM Book__c WHERE Id = :b.Id ];
        System.debug('Price after trigger fired: ' + b.Price__c);
        System.assertEquals(90, b.Price__c);
    }

    @isTest static void ValidateAccountData()
    {
        Account a = new Account(Name = 'Acme', BillingCity = 'San Francisco');
        insert a;

        sObject s = [SELECT Id, Name FROM Account WHERE Name = 'Acme' LIMIT 1];

        Account convertedAcc = (Account)s;
        System.debug(convertedAcc);
        convertedAcc.Name = 'Acme 2';

        update convertedAcc;
       // Object s2 = [SELECT Id, Name FROM Account WHERE Name like 'Acme%' LIMIT 1];
        //Account updatedAcc = (Account)s2;
        //System.debug(updatedAcc);

        Contact sal = new Contact(FirstName = 'Sal', Account = convertedAcc);
        System.debug(sal.FirstName);
        System.debug(sal.Account);
        System.debug(sal);

    }
}
