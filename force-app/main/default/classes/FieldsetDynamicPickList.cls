@namespaceAccessible
public with sharing class FieldsetDynamicPickList extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;
    DescribeSObjectResult sObjectInfo;

    @namespaceAccessible
    public FieldsetDynamicPickList(VisualEditor.DesignTimePageContext context) {
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
        String namespacePrefix = this.sObjectInfo.getName().remove(this.sObjectInfo.getLocalName());
        for(Schema.ChildRelationship relation : this.sObjectInfo.getChildRelationships()) {
            Schema.DescribeSObjectResult childInfo = relation.getChildSObject().getDescribe();
            Map<String, Schema.FieldSet> fieldSetMap = childInfo.fieldSets.getMap();
            for(Schema.FieldSet fieldSet : fieldSetMap.values()){
                    String fsName = fieldSet.getName();
                    String fsLabel = String.format('{0}-{1}',new List<String> {this.sObjectInfo.getLocalName(), fieldSet.getLabel()});
                    if(!fsName.startsWith(namespacePrefix)){
                        fsName = String.format('{0}{1}',new List<String> {namespacePrefix, fsName});
                    }
                    pickListValues.addRow(
                        new VisualEditor.DataRow(
                            fsLabel, 
                            fsName));
                }
        }
        return pickListValues;
    }
}