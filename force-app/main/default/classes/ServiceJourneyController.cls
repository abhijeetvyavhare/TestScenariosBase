public with sharing class ServiceJourneyController implements Callable {
    public Object call(String action, Map<String, Object> args) {
        switch on action {
            when 'updateField' {
                return handleUpdateField(args);
            }
            when else {
                throw new CalloutException('Method not implemented');
            }
        }
    } 

    @testvisible
    private Object handleUpdateField(Map<String, Object> args){
        Map<String, Object> result = new Map<String, Object>();
        if(args.containsKey('uid') && args.get('uid') == 'ACTIVITY_SEARCH_VIN'){
            searchAsset(args, result);
        }else if(args.containsKey('uid') && args.get('uid') == 'ACTIVITY_SEARCH_CASE'){
            searchCase(args, result);
        }
        return result;
    }

    private static void searchAsset(
        Map<String, Object> args, 
        Map<String, Object> result){
            
            String assetName = '%' + (String)args.get('fieldValue') + '%';
            List<Asset> assets = [SELECT Id, Name from Asset Where Name Like :assetName LIMIT 1];
            
            setAssetDetails(
                assets,
                result
            );

            if(assets.size()>0){
                setCaseDetails(
                    [SELECT Id, CaseNumber from Case 
                        Where Status != 'Closed' AND AssetId = :assets[0].Id  ORDER BY CreatedDate DESC LIMIT 1],
                    result);
                setSRDetails(
                    [SELECT Id, Name from dmpl__ServiceRequest__c 
                        Where dmpl__Status__c != 'Closed' AND dmpl__AssetId__c = :assets[0].Id  ORDER BY CreatedDate DESC LIMIT 1],
                    result);
                setJCDetails(
                    [SELECT Id, Name from dmpl__RepairOrder__c 
                        Where dmpl__Status__c != 'Closed' AND dmpl__AssetId__c = :assets[0].Id  ORDER BY CreatedDate DESC LIMIT 1],
                    result);
            }else {
                setCaseDetails(null, result);
                setSRDetails(null, result);
                setJCDetails(null, result);
            }
    }

    private static void searchCase(
        Map<String, Object> args, 
        Map<String, Object> result){
            
            String caseName = '%' + (String)args.get('fieldValue') + '%';
            List<Case> cases = [SELECT Id, CaseNumber, AssetId from Case Where CaseNumber Like :caseName  ORDER BY CreatedDate DESC LIMIT 1];
            
            setCaseDetails(
                cases,
                result);

            if(cases.size()>0){        
                setAssetDetails(
                    [SELECT Id, Name from Asset Where Id = :cases[0].AssetId LIMIT 1],
                    result);
                setSRDetails(
                    [SELECT 
                        Id, Name from dmpl__ServiceRequest__c 
                        Where dmpl__Status__c != 'Closed' AND dmpl__AssetId__c =:cases[0].AssetId ORDER BY CreatedDate DESC LIMIT 1],
                    result);
                setJCDetails(
                    [SELECT Id, Name from dmpl__RepairOrder__c 
                        Where dmpl__Status__c != 'Closed' AND dmpl__AssetId__c = :cases[0].AssetId  ORDER BY CreatedDate DESC LIMIT 1],
                    result);
            }else{
                setAssetDetails(null, result);
                setSRDetails(null, result);
                setJCDetails(null, result);
            }
    }

    private static void setAssetDetails(
        List<Asset> assets,
        Map<String, Object> result){
        Map<String, Object> assetRecord = new Map<String, Object>();
        Map<String, Object> searchRecord = new Map<String, Object>();
                
        if(assets?.size()>0){    
            assetRecord.put('isHidden', false);
            assetRecord.put('recordId', assets[0].Id);
            assetRecord.put('valueLabel', assets[0].Name);
            searchRecord.put('fieldValue', assets[0].Name);
        }else{
            assetRecord.put('isHidden', true);
            assetRecord.put('recordId', null);
            searchRecord.put('fieldValue', '');
        }
        result.put('ACTIVITY_ASSET_DETAIL', assetRecord);
        result.put('ACTIVITY_SEARCH_VIN', searchRecord);

        // searchRecord.put('settings', JSON.deserializeUntyped('{"fields":[{"fieldApiName" : "CaseNumber"}, {"fieldApiName" : "Status"}, {"fieldApiName" : "OwnerId"}, {"fieldApiName" : "Subject"}], "navigation":{"type":"standard__navItemPage", "attributes": {"apiName": "/flow/dmpl/TestFlow"},"state": { "assetId": "' + assets[0].Id + '" }}}'));
        // result.put('ACTION1', searchRecord);
        
    }

    private static void setCaseDetails(
        List<Case> cases,
        Map<String, Object> result){
        Map<String, Object> caseTaskRecord = new Map<String, Object>();
        Map<String, Object> caseRecord = new Map<String, Object>();
        Map<String, Object> caseSearchRecord = new Map<String, Object>();
            
        if(cases?.size()>0){    
            caseTaskRecord.put('isHidden', false);
            caseRecord.put('isHidden', false);
            caseRecord.put('recordId', cases[0].Id);
            caseRecord.put('valueLabel', cases[0].CaseNumber);
            caseSearchRecord.put('fieldValue', cases[0].CaseNumber);
        }else{
            //caseTaskRecord.put('isHidden', true);
            caseRecord.put('isHidden', true);
            caseRecord.put('recordId', null);
            caseRecord.put('valueLabel', null);
            caseSearchRecord.put('fieldValue', '');
        }
        result.put('TASK_CASE', caseTaskRecord);
        result.put('ACTIVITY_CASE_DETAIL', caseRecord);
        result.put('ACTIVITY_SEARCH_CASE', caseSearchRecord);
    }

    private static void setSRDetails(
        List<dmpl__ServiceRequest__c> serviceRequests,
        Map<String, Object> result){
        Map<String, Object> srTaskRecord = new Map<String, Object>();
        Map<String, Object> srRecord = new Map<String, Object>();
        if(serviceRequests?.size()>0){    
            srTaskRecord.put('isHidden', false);
            srRecord.put('recordId', serviceRequests[0].Id);
            srRecord.put('valueLabel', serviceRequests[0].Name);
        }else{
            srTaskRecord.put('isHidden', true);
            srRecord.put('recordId', null);
        }
        result.put('TASK_SERVICE_REQUEST', srTaskRecord);
        result.put('ACTIVITY_SR_DETAIL', srRecord);
    }

    private static void setJCDetails(
        List<dmpl__RepairOrder__c> repairOrders,
        Map<String, Object> result){
        Map<String, Object> roTaskRecord = new Map<String, Object>();
        Map<String, Object> roRecord = new Map<String, Object>();
        if(repairOrders?.size()>0){    
            roTaskRecord.put('isHidden', false);
            roRecord.put('recordId', repairOrders[0].Id);
            roRecord.put('valueLabel', repairOrders[0].Name);
        }else{
            roTaskRecord.put('isHidden', true);
            roRecord.put('recordId', null);
        }
        result.put('TASK_JOB_CARD', roTaskRecord);
        result.put('ACTIVITY_JC_DETAIL', roRecord);
    }
}