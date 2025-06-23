@namespaceAccessible
public with sharing class RecordTypeDynamicPickList extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;
    DescribeSObjectResult sObjectInfo;

    @namespaceAccessible
    public RecordTypeDynamicPickList(VisualEditor.DesignTimePageContext context) {
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
            Schema.DescribeSObjectResult childInfo = relation.getChildSObject().getDescribe();
            for(Schema.RecordTypeInfo rtInfo : childInfo.getRecordTypeInfos()) {
                    String fsLabel = String.format('{0}-{1}',new List<String> {childInfo.getLocalName(), rtInfo.getName()});
                    pickListValues.addRow(
                        new VisualEditor.DataRow(
                            fsLabel, 
                            String.valueOf(rtInfo.getRecordTypeId())));
                }
        }
        return pickListValues;
   }
}