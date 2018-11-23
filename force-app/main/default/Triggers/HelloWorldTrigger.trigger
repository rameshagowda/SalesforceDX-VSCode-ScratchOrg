trigger HelloWorldTrigger on Book__c (before insert) 
{
    Book__c book = Trigger.new[0];

    MyHelloWorld.ApplyDiscount(book);
}