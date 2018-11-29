public with sharing class MyHelloWorld {
    public MyHelloWorld() 
    {    }

    public static void ApplyDiscount(Book__c book)
    {
            book.Price__c *= 0.9;
        
    }
}

