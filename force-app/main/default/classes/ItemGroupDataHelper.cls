public with sharing class ItemGroupDataHelper {
    public static dmpl__ItemGroup__c createItemGroup(String itemGroupName) {
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = itemGroupName,
                dmpl__Description__c = 'Test Description'
            ),
            'ItemGroupDefaults',
            true
        );
    }

    public static dmpl__ItemGroup__c updateItemGroup(String itemGroupName) {
        return (dmpl__ItemGroup__c) TestFactory.createSObject(
            new dmpl__ItemGroup__c(
                Name = itemGroupName,
                dmpl__Description__c = 'Updated Test Description'
            ),
            'ItemGroupDefaults',
            true
        );
    }

    public static dmpl__ItemGroup__c getItemGroup(String itemGroupName) {
        return [
            SELECT Id, Name, dmpl__Description__c
            FROM dmpl__ItemGroup__c
            WHERE Name = :itemGroupName
            LIMIT 1
        ];
    }
     
    public static dmpl__ItemGroupRule__c createItemGroupRule(dmpl__ItemGroup__c itemGroup, Integer sequenceNumber) {
        return (dmpl__ItemGroupRule__c) TestFactory.createSObject(
            new dmpl__ItemGroupRule__c(
                dmpl__ItemGroupId__c = itemGroup.Id,
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__FieldName__c = 'Test Field Name',
                dmpl__FieldValue__c = 'Test Field Value'
            ),
            'ItemGroupRuleDefaults',
            true
        );
    }

    public static dmpl__ItemGroupRule__c updateItemGroupRule(dmpl__ItemGroup__c itemGroup, Integer sequenceNumber) {
        return (dmpl__ItemGroupRule__c) TestFactory.createSObject(
            new dmpl__ItemGroupRule__c(
                dmpl__ItemGroupId__c = itemGroup.Id,
                dmpl__SequenceNumber__c = sequenceNumber,
                dmpl__FieldName__c = 'Updated Field Name',
                dmpl__FieldValue__c = 'Updated Field Value'
            ),
            'ItemGroupRuleDefaults',
            true
        );
    }

    public static dmpl__ItemGroupRule__c getItemGroupRule(Id itemGroupId) {
        return [
            SELECT Id, dmpl__ItemGroupId__c, dmpl__SequenceNumber__c, 
                   dmpl__FieldName__c, dmpl__FieldValue__c
            FROM dmpl__ItemGroupRule__c 
            WHERE dmpl__ItemGroupId__c = :itemGroupId
            LIMIT 1
        ];
    }
      
    public static dmpl__ItemGroupMember__c createItemGroupMember(dmpl__ItemGroup__c itemGroup) {
        dmpl__Item__c item = ItemDataHelper.getItemByCode('TEST123');
        
        return (dmpl__ItemGroupMember__c) TestFactory.createSObject(
            new dmpl__ItemGroupMember__c(
                dmpl__ItemGroupId__c = itemGroup.Id,
                dmpl__ItemId__c = item.Id
            ),
            'ItemGroupMemberDefaults',
            true
        );
    }

    public static dmpl__ItemGroupMember__c getItemGroupMember(Id itemGroupId) {
        return [
            SELECT Id, dmpl__ItemGroupId__c, dmpl__ItemId__c
            FROM dmpl__ItemGroupMember__c
            WHERE dmpl__ItemGroupId__c = :itemGroupId
            LIMIT 1
        ];
    }
}