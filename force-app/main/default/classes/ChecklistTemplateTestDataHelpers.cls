@isTest
public with sharing class ChecklistTemplateTestDataHelpers {
    public static dmpl__ChecklistTemplate__c createChecklistTemplate(dmpl__Resource__c resource, dmpl__Item__c item, Account partnerAccount, Account account, dmpl__AccountGroup__c accountGroup) {
        return (dmpl__ChecklistTemplate__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplate__c(
                                            dmpl__ResourceId__c = resource.Id,
                                            dmpl__ItemId__c = item.Id,
                                            dmpl__PartnerAccountId__c = partnerAccount.Id,
                                            dmpl__AccountId__c = account.Id,
                                            dmpl__AccountGroupId__c = accountGroup.Id
                                            ),
            'ChecklistTemplateDefaults',
            true
        );
    }

    public static dmpl__ChecklistTemplate__c getChecklistTemplate() {
        return [SELECT
            Id,
            Name,
            dmpl__ResourceId__c,
            dmpl__ItemId__c,
            dmpl__PartnerAccountId__c,
            dmpl__AccountId__c,
            dmpl__AccountGroupId__c,
            dmpl__Code__c,
            dmpl__Type__c
            FROM dmpl__ChecklistTemplate__c
            LIMIT 1
        ];
    }

    public static dmpl__CheckListTemplateLine__c createChecklistTemplateLine(dmpl__ChecklistTemplate__c checkListTemplate) {
        return (dmpl__CheckListTemplateLine__c) TestFactory.createSObject(
            new dmpl__CheckListTemplateLine__c(
                                            dmpl__ChecklistTemplateId__c = checkListTemplate.Id
                                            ),
            'CheckListTemplateLineDefaults',
            true
        );
    }

    public static dmpl__CheckListTemplateLine__c createChecklistTemplateLine(
        dmpl__ChecklistTemplate__c checkListTemplate,
        String name
) {
        return (dmpl__CheckListTemplateLine__c) TestFactory.createSObject(
            new dmpl__CheckListTemplateLine__c(
                                            dmpl__ChecklistTemplateId__c = checkListTemplate?.Id,
                                            Name=name,
                                            dmpl__DataType__c='Text',
                                            dmpl__DefaultValue__c='DateValue1',
                                            dmpl__GroupBy__c='Sample1'
                                            ),
            // 'CheckListTemplateLineDefaults',
            true
        );
    }
    
    public static dmpl__CheckListTemplateLine__c getChecklistTemplateLine() {
        return [SELECT
            Id,
            Name,
            dmpl__ChecklistTemplateId__c,
            dmpl__DataType__c,
            dmpl__DefaultValue__c,
            dmpl__GroupBy__c
            FROM dmpl__CheckListTemplateLine__c
            LIMIT 1
        ];
    }
    public static dmpl__ChecklistTemplate__c createChecklistTemplateWithIds(dmpl__Resource__c resource, dmpl__Item__c item, Account partnerAccount, Account account, dmpl__AccountGroup__c accountGroup) {
        return (dmpl__ChecklistTemplate__c) TestFactory.createSObject(
            new dmpl__ChecklistTemplate__c(
                                            dmpl__ResourceId__c = resource?.Id,
                                            dmpl__ItemId__c = item?.Id,
                                            dmpl__PartnerAccountId__c = partnerAccount?.Id,
                                            dmpl__AccountId__c = account?.Id,
                                            dmpl__AccountGroupId__c = accountGroup?.Id
                                            ),
            'ChecklistTemplateDefaults',
            true
        );
    }
}