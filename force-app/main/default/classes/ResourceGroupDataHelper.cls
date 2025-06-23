@isTest
public with sharing class ResourceGroupDataHelper {
  public static dmpl__ResourceGroup__c createResourceGroup() {
    return (dmpl__ResourceGroup__c) TestFactory.createSObject(
      new dmpl__ResourceGroup__c(Name = 'Test-ResourceGroup', dmpl__ResourceGroupType__c = 'Incentive', dmpl__DynamicMemberType__c = 'Field Filter'),
      'ResourceGroupDefaults',
	  true
    );
  }

  public static dmpl__ResourceGroup__c getResourceGroup() {
    return [
      SELECT Id, Name, dmpl__DynamicMemberType__c, dmpl__ResourceGroupType__c
      FROM dmpl__ResourceGroup__c
      LIMIT 1
    ];
  }

  public static dmpl__ResourceGroup__c getResourceGroup(Id id) {
    return [
      SELECT Id, Name, dmpl__DynamicMemberType__c, dmpl__ResourceGroupType__c
      FROM dmpl__ResourceGroup__c
      WHERE Id = :id
      LIMIT 1
    ];
  }

  public static dmpl__ResourceGroupRule__c createResourceGroupRule(dmpl__ResourceGroup__c resourceGroup) {
    return (dmpl__ResourceGroupRule__c) TestFactory.createSObject(
      new dmpl__ResourceGroupRule__c(
        dmpl__ResourceGroupId__c = resourceGroup.Id,
        dmpl__FieldName__c = 'Test-ResourceGroup',
        dmpl__FieldValue__c = 'Sample',
        dmpl__Operation__c = 'in',
        dmpl__SequenceNumber__c = 1
      ),
	  'ResourceGroupRuleDefaults',
      true
    );
  }

  public static dmpl__ResourceGroupRule__c getResourceGroupRule() {
    return [
      SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
      FROM dmpl__ResourceGroupRule__c
      LIMIT 1
    ];
  }
  public static dmpl__ResourceGroupRule__c getResourceGroupRule(Id id) {
    return [
      SELECT Id, Name, dmpl__FieldName__c, dmpl__FieldValue__c, dmpl__Operation__c, dmpl__SequenceNumber__c
      FROM dmpl__ResourceGroupRule__c
      WHERE Id = :id
      LIMIT 1
    ];
  }

  public static dmpl__ResourceGroupMember__c createResourceGroupMember(dmpl__Resource__c resource, dmpl__ResourceGroup__c resourceGroup) {
    return (dmpl__ResourceGroupMember__c) TestFactory.createSObject(
      new dmpl__ResourceGroupMember__c(dmpl__ResourceId__c = resource.id, dmpl__ResourceGroupId__c = resourceGroup.Id),
	  'ResourceGroupMemberDefaults',
      true
    );
  }

  public static dmpl__ResourceGroupMember__c getResourceGroupMember() {
    return [
      SELECT Id, dmpl__ResourceId__c, dmpl__ResourceGroupId__c
      FROM dmpl__ResourceGroupMember__c
      LIMIT 1
    ];
  }
  
  public static dmpl__ResourceGroupMember__c getResourceGroupMember(Id id) {
    return [
      SELECT Id, dmpl__ResourceId__c, dmpl__ResourceGroupId__c
      FROM dmpl__ResourceGroupMember__c
      WHERE Id = :id
      LIMIT 1
    ];
  }
}