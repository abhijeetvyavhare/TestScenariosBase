@namespaceAccessible
public with sharing class CurrencyFieldDynamicPickList extends VisualEditor.DynamicPickList{
    VisualEditor.DesignTimePageContext context;
    DescribeSObjectResult sObjectInfo;

    @namespaceAccessible
    public CurrencyFieldDynamicPickList(VisualEditor.DesignTimePageContext context) {
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
        for(Schema.SObjectField field : this.sObjectInfo.fields.getMap().values()) {
            Schema.DescribeFieldResult fieldInfo = field.getDescribe();
            if(fieldInfo.getType() == Schema.DisplayType.CURRENCY){
                pickListValues.addRow(new VisualEditor.DataRow(fieldInfo.label, fieldInfo.name));
            }
        }
        return pickListValues;
    }
}