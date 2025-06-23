@isTest
public with sharing class CaseRelatedIssueDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'Name'=>'CaseRelatedIssue1',
            'RelatedEntityType'=>null,
            'RelationshipType'=>'Root Cause'
        };
    }
}