@isTest
public class InventoryStockService_Test {

    @isTest
    static void testConstructor() {
        InventoryStockService service = new InventoryStockService();
        
        System.assertNotEquals(null, service);
    }

}