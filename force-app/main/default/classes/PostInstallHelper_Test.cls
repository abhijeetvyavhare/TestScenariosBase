@isTest
private class PostInstallHelper_Test
{ 
    @isTest
    static void postInstallTest()
    {
        PostInstallHelper postinstall = new PostInstallHelper();
        Test.testInstall(postinstall, null);
        System.assert(postinstall != null, 'Postinstall is null');
    }
}