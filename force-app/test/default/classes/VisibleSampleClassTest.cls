@isTest
private class VisibleSampleClassTest 
{
    @isTest static void test1()
    {
        VisibleSampleClass sample = new VisibleSampleClass();
        sample.recordNumber =100;
        sample.areaCode = '(510)';

        VisibleSampleClass.Employee emp = new VisibleSampleClass.Employee('Ramesha Gowda', '777-7777');

        String s = sample.PrivateMethod(emp);

        System.assert(s.contains('(510)') && 
                        s.contains('Ramesha Gowda') && 
                        s.contains('777-7777'));
    }

    @isTest static void test2()
    {
        try {
           throw new VisibleSampleClass.MyException('Exception thrown from test');
        } catch (VisibleSampleClass.MyException e) {
           System.debug(e.getMessage());
        }
    }

    @isTest static void test3()
    {
        VisibleSampleClass sample = new VisibleSampleClass();
        sample.PublicMethod();
    }
}
