@isTest
public class ItemLotService_Test {

    @isTest
    static void testConstructor() {
        ItemLotService service = new ItemLotService();
        AlternateItemStock obj = new AlternateItemStock();
        AlternateItemStock obj2 = new AlternateItemStock('','','','','','');
        CustomProcessor obj3 = new CustomProcessor();
        dmpl__LeaveType__c type = new LeaveType__c(Name = 'test');
        insert type;
        Account obj4 = new Account(Name = 'Test');
        insert obj4;
        dmpl__InterfaceQueue__c que= new dmpl__InterfaceQueue__c(dmpl__QueueType__c = 'Queueable');
        insert que;
        obj3.perfromAction(obj4.Id,que.Id);
        Map<String,Object> mp = new Map<String,Object>();
        mp.put('recordId',obj4.Id);
        mp.put('queueId',que.Id);
        obj3.call('performAction',mp);
        System.assertNotEquals(null, service);
    }

}