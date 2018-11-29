public class VisibleSampleClass 
{
    @TestVisible private Integer recordNumber = 0;
    @TestVisible private String areaCode = '(415)';

    public Integer maxRecords = 1000;

    @TestVisible class Employee
    {
        String fullName;
        String phone;

        @TestVisible Employee(String s, String ph)
        {
            fullName = s;
            phone = ph;
        }
    }

    @TestVisible private String PrivateMethod(Employee e)
    {
        System.debug('Im private');
        recordNumber++;
        String phone = areaCode + ' ' + e.phone;
        String s = e.fullName + '\'s phone number is '+phone;
        System.debug(s);
        return s;
    }

    public void PublicMethod()
    {
        maxRecords++;
        System.debug('I am public.');
    }

    //private custom exception class
    @TestVisible private class MyException extends Exception
    {

    }
}
