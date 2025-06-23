@isTest
public with sharing class ResourceGroupHandler_Test {
  @TestSetup
  static void createRequiredData() {
    dmpl__ResourceGroup__c resourceGroup = ResourceGroupDataHelper.createResourceGroup();
    dmpl__ResourceGroupRule__c resourceGroupRule = ResourceGroupDataHelper.createResourceGroupRule(resourceGroup);
    Account partnerAccount = TestDataHelpers.createPartnerAccount();
    dmpl__Branch__c branch = TestDataHelpers.createBranch(partnerAccount);
    dmpl__Resource__c resource = ResourceDataHelper.createResource(partnerAccount, branch);
    dmpl__ResourceGroupMember__c resourceGroupMember = ResourceGroupDataHelper.createResourceGroupMember(resource, resourceGroup);
  }

  @isTest
  static void createResourceGroupPositive() {
    dmpl__ResourceGroup__c resourceGroup = ResourceGroupDataHelper.getResourceGroup();
    System.assertNotEquals(resourceGroup, null, 'Expected Resource Group to be created.');
    System.assertEquals('Field Filter', resourceGroup.dmpl__DynamicMemberType__c, ' Resource Group Dynamic Member Type Must be Field Filter');
    System.assertEquals('Incentive', resourceGroup.dmpl__ResourceGroupType__c, ' Resource Group Type Must be Incentive');
  }

  @isTest
  static void createResourceGroupRulePositive() {
    dmpl__ResourceGroupRule__c resourceGroupRule = ResourceGroupDataHelper.getResourceGroupRule();
    System.assertNotEquals(resourceGroupRule, null, 'Expected Resource Group Rule to be created.');
    System.assertEquals(1, resourceGroupRule.dmpl__SequenceNumber__c, ' Resource Group Rule Sequence Number Must be 1');
    System.assertEquals('Sample', resourceGroupRule.dmpl__FieldValue__c, ' Resource Group Rule Field Value Must be Sample');
  }

  @isTest
  static void createResourceGroupMemberPositive() {
    dmpl__ResourceGroupMember__c resourceGroupMember = ResourceGroupDataHelper.getResourceGroupMember();
    System.assertNotEquals(resourceGroupMember, null, 'Expected Resource Group Member to be created.');
    System.assertNotEquals(null, resourceGroupMember.dmpl__ResourceId__c, ' Resource Group Member Must have a resourceId');
  }

  @isTest
  static void updateResourceGroupPositive() {
    dmpl__ResourceGroup__c resourceGroup = ResourceGroupDataHelper.getResourceGroup();
    System.assertNotEquals(resourceGroup, null, 'Resource Group should exist before update.');

    resourceGroup.dmpl__DynamicMemberType__c = 'Report Data';
    resourceGroup.dmpl__ResourceGroupType__c = 'Scheme';
    update resourceGroup;

    dmpl__ResourceGroup__c resourceGroupUpdated = ResourceGroupDataHelper.getResourceGroup(resourceGroup.Id);
    System.assertEquals('Report Data', resourceGroupUpdated.dmpl__DynamicMemberType__c, ' Resource Group Dynamic Member Type Must be Report Data');
    System.assertEquals('Scheme', resourceGroupUpdated.dmpl__ResourceGroupType__c, ' Resource Group Type Must be Scheme');
  }

  @isTest
  static void updateResourceGroupRulePositive() {
    dmpl__ResourceGroupRule__c resourceGroupRule = ResourceGroupDataHelper.getResourceGroupRule();
    System.assertNotEquals(resourceGroupRule, null, 'Resource Group Rule should exist before update.');

    resourceGroupRule.dmpl__FieldValue__c = 'Sample1';
    update resourceGroupRule;

    dmpl__ResourceGroupRule__c resourceGroupRuleUpdated = ResourceGroupDataHelper.getResourceGroupRule(resourceGroupRule.Id);
    System.assertEquals('Sample1', resourceGroupRule.dmpl__FieldValue__c, ' Resource Group Rule Field Value Must Updated to  Sample1');
  }

  @isTest
  static void updateResourceGroupMemberPositive() {
    dmpl__ResourceGroupMember__c resourceGroupMember = ResourceGroupDataHelper.getResourceGroupMember();
    System.assertNotEquals(resourceGroupMember, null, 'Resource Group Member should exist before update.');
    resourceGroupMember.dmpl__ResourceId__c = null;
    update resourceGroupMember;
    dmpl__ResourceGroupMember__c resourceGroupMemberUpdated = ResourceGroupDataHelper.getResourceGroupMember(resourceGroupMember.Id);
    System.assertEquals(null, resourceGroupMember.dmpl__ResourceId__c, ' Resource Group Member ResourceId Must Updated to null');
  }

  @isTest
  static void deleteResourceGroupMember() {
    dmpl__ResourceGroupMember__c resourceGroupMember = ResourceGroupDataHelper.getResourceGroupMember();
    System.assertNotEquals(null, resourceGroupMember, 'ResourceGroupMember should exist before delete.');

    delete resourceGroupMember;

    dmpl__ResourceGroupMember__c deletedMember;
    try {
      deletedMember = ResourceGroupDataHelper.getResourceGroupMember(resourceGroupMember.Id);
    } catch (Exception e) {
      deletedMember = null;
    }
    System.assertEquals(null, deletedMember, 'ResourceGroupMember should be deleted and not found in query.');
  }

  @isTest
  static void deleteResourceGroupRule() {
    dmpl__ResourceGroupRule__c resourceGroupRule = ResourceGroupDataHelper.getResourceGroupRule();
    System.assertNotEquals(null, resourceGroupRule, 'ResourceGroupRule should exist before delete.');

    delete resourceGroupRule;

    dmpl__ResourceGroupRule__c deletedRule;
    try {
      deletedRule = ResourceGroupDataHelper.getResourceGroupRule(resourceGroupRule.Id);
    } catch (Exception e) {
      deletedRule = null;
    }
    System.assertEquals(null, deletedRule, 'ResourceGroupRule should be deleted and not found in query.');
  }

  @isTest
  static void deleteResourceGroup() {
    dmpl__ResourceGroup__c resourceGroup = ResourceGroupDataHelper.getResourceGroup();
    System.assertNotEquals(null, resourceGroup, 'ResourceGroup should exist before delete.');

    delete resourceGroup;

    dmpl__ResourceGroup__c deletedGroup;
    try {
      deletedGroup = ResourceGroupDataHelper.getResourceGroup(resourceGroup.Id);
    } catch (Exception e) {
      deletedGroup = null;
    }
    System.assertEquals(null, deletedGroup, 'ResourceGroup should be deleted and not found in query.');
  }
}