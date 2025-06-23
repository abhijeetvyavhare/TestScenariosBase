@isTest
public class ContactPointConsentDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'BusinessBrandId'=>null,
            'CaptureContactPointType'=>'none',
            'CaptureDate'=>'2024-01-01',
            'CaptureSource'=>'none',
            'ContactPointId'=>null,
            'DataUsePurposeId'=>null,
            'DoubleConsentCaptureDate'=>'2024-01-01',
            'EffectiveFrom'=>'2024-01-01',
            'EffectiveTo'=>'2024-01-02',
            'EngagementChannelTypeId'=>null,
            'Name'=>'ContactPointConsentDefaults',
            'PartyRoleId'=>null,
            'PrivacyConsentStatus'=>'none'
        };
    }
}