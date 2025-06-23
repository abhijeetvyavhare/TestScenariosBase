@isTest
public class FinanceBalanceSnapshotDefaults implements TestFactory.FieldDefaults{
    public Map<String, Object> getFieldDefaults(){
        return new Map<String, Object>{ 
            'AccountId'=>null,
            'AdjustmentAmount'=>'$100 USD',
            'Balance'=>'$100 USD',
            'BaseCurrencyAmount'=>'$100 USD',
            'BaseCurrencyBalance'=>'$100 USD',
            'BaseCurrencyFxDate'=>'2024-01-01',
            'BaseCurrencyFxRate'=>'123',
            'BaseCurrencyIsoCode'=>'91',
            'ChargeAmount'=>'$100 USD',
            'CreatedDate'=>'2024-01-01',
            'DueDate'=>'2024-01-02',
            'EffectiveDate'=>'2024-01-01',
            'EventType'=>'Allocated',
            'FinanceSystemIntegrationMode'=>'none',
            'FinanceSystemName'=>'none',
            'FinanceSystemTransactionNumber'=>'1234',
            'FinanceTransactionId'=>null,
            'ImpactAmount'=>'$100 USD',
            'LegalEntityId'=>null,
            'OriginalEventType'=>'none',
            'OriginalReferenceEntityType'=>'none',
            'ReferenceEntityType'=>'Invoice',
            'Subtotal'=>'$100 USD',
            'TaxAmount'=>'$100 USD',
            'TotalAmountWithTax'=>'$100 USD',
            'TransactionDate'=>'2024-01-01'
        };
    }
}