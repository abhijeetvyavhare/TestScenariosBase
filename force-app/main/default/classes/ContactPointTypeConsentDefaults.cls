@isTest
public class ContactPointTypeConsentDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{
            'BusinessBrandId'=>null,
            'CaptureDate'=>'2024-01-01',
            'CaptureSource'=>'none',
            'ContactPointType'=>null,
            'DataUsePurposeId'=>null,
            'DoubleConsentCaptureDate'=>'2024-01-01',
            'EffectiveFrom'=>'2024-01-01',
            'EffectiveTo'=>'2024-01-03',
            'EngagementChannelTypeId'=>null,
            'Name'=>'ContactPointTypeConsent1',
            'PartyId'=>null,
            'PartyRoleId'=>null,
            'PrivacyConsentStatus'=>null
        };
    }
}