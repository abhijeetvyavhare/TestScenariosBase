@namespaceAccessible
public with sharing class RelatedFieldDynamicPickList extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;
    DescribeSObjectResult sObjectInfo;

    @namespaceAccessible
    public RelatedFieldDynamicPickList(VisualEditor.DesignTimePageContext context) {
        this.context = context;
        this.sObjectInfo = Schema.getGlobalDescribe().get(context.entityName).getDescribe();
     }

    @namespaceAccessible
    public override VisualEditor.DataRow getDefaultValue(){
        return null;
    }
    
    @namespaceAccessible
    public override VisualEditor.DynamicPickListRows getValues() {
        VisualEditor.DynamicPickListRows  pickListValues = new VisualEditor.DynamicPickListRows();
        for(Schema.ChildRelationship relation : this.sObjectInfo.getChildRelationships()) {
            Schema.SObjectField keyField = relation.getField();
            Schema.DescribeFieldResult fieldInfo = keyField.getDescribe();
            if(!String.isEmpty(relation.getRelationshipName())){
                pickListValues.addRow(new VisualEditor.DataRow(relation.getRelationshipName(), relation.getRelationshipName()));
            }
        }
        return pickListValues;
    }
}