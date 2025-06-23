@namespaceAccessible
public abstract with sharing class DomainFeatureSettingHelper {
   
    @namespaceAccessible
    protected Boolean hasPartnerDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, DomainFeatureSetting domainFeatureSetting){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c !=null && fs.dmpl__BranchId__c ==null){
                domainFeatureSetting.FeatureSetting = fs;
                return true;
            }
        }
        return false;
    }

    @namespaceAccessible
    protected Boolean hasBranchDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, DomainFeatureSetting domainFeatureSetting){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c !=null && fs.dmpl__BranchId__c !=null){
                domainFeatureSetting.FeatureSetting = fs;
                return true;
            }
        }
        return false;
    }

    @namespaceAccessible
    protected Boolean hasGlobalDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, DomainFeatureSetting domainFeatureSetting){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c ==null && fs.dmpl__BranchId__c ==null){
                domainFeatureSetting.FeatureSetting = fs;
                return true;
            }
        }
        return false;
    }

    @namespaceAccessible
    protected Boolean hasPartnerDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, List<dmpl__DomainSetting__mdt> fieldList){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c !=null && fs.dmpl__BranchId__c ==null){
                fieldList.add(fs);
            }
        }

        return(fieldList.size()>0);
    }

    @namespaceAccessible
    protected Boolean hasBranchDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, List<dmpl__DomainSetting__mdt> fieldList){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c !=null && fs.dmpl__BranchId__c !=null){
                fieldList.add(fs);
            }
        }

        return(fieldList.size()>0);
    }

    @namespaceAccessible
    protected Boolean hasGlobalDomainSetting(List<dmpl__DomainSetting__mdt> allSettings, List<dmpl__DomainSetting__mdt> fieldList){
        for(dmpl__DomainSetting__mdt fs : allSettings){
            if(fs.dmpl__PartnerAccountId__c ==null && fs.dmpl__BranchId__c ==null){
                fieldList.add(fs);
            }
        }

        return(fieldList.size()>0);
    }

    @namespaceAccessible
    protected List<dmpl__DomainSetting__mdt> getDomainSetting(string featureName, string objectApiName){
        return [SELECT
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__Status__c,
                dmpl__FieldNameId__r.QualifiedApiName,
                dmpl__ParamName__c,
                dmpl__ParamValue__c
            FROM dmpl__DomainSetting__mdt
            WHERE dmpl__Feature__c =:featureName
                AND dmpl__ObjectNameId__r.QualifiedApiName =:objectApiName];
    }
    
    @namespaceAccessible
    protected List<dmpl__DomainSetting__mdt> getDomainSetting(string featureName, string objectApiName, string relatedObjectApiName){
        return [SELECT
                dmpl__PartnerAccountId__c,
                dmpl__BranchId__c,
                dmpl__Status__c,
                dmpl__FieldNameId__r.QualifiedApiName,
                dmpl__ParamName__c,
                dmpl__ParamValue__c
            FROM dmpl__DomainSetting__mdt
            WHERE dmpl__Feature__c =:featureName
                AND dmpl__ObjectNameId__r.QualifiedApiName =:objectApiName
                AND dmpl__RelatedObjectName__r.QualifiedApiName =:relatedObjectApiName
            ];
    }
}