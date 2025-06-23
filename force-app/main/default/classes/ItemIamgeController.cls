public with sharing class ItemIamgeController {
    
    @auraenabled(cacheable=true)
	public static List<dmpl__Item__c> getAllItemWithImages()
    {
        return [
            SELECT 
                Id, 
                Name
            FROM dmpl__Item__c];
    }
    
    @auraenabled(cacheable=true)
    public static ImageResponse getImage(string id)
    {
        if(string.isEmpty(id)){
            throw new DMPLException('Bad Input');
        }

        List<ContentDocumentLink> links = [
            SELECT 
                ContentDocumentId,
                LinkedEntityId 
            FROM 
                ContentDocumentLink 
            WHERE 
                LinkedEntityId=:id];

        Set<Id> ids=new Set<Id>();	
        for(ContentDocumentLink link:links){
            ids.add(link.ContentDocumentId);
        }
        
        List<ContentVersion> versions= [
            SELECT 
                VersionData,
                Title,
                ContentDocumentId,
                FileExtension 
            FROM 
                ContentVersion 
            WHERE 
                ContentDocumentId = :ids 
                AND IsLatest = true];
        
        List<ContentDistribution> cdts=[
            SELECT 
                ContentDocumentId,
                DistributionPublicUrl,
                ContentDownloadURL 
            FROM 
                ContentDistribution 
            WHERE 
                ContentDocumentId =:ids];
        
        Map<String, ContentDistribution> contentList= new Map <String, ContentDistribution>();  
        for(ContentDistribution cdt:cdts){
            contentList.put(cdt.ContentDocumentId, cdt);     
        }
        SecurityHelper.ensureCanReadFields(new List<String>{
            'dmpl__Coordinate__c',
            'dmpl__Shape__c', 
            'dmpl__LinkUrl__c',
            'dmpl__Detail__c',
            'dmpl__ComponentItemId__c',
            'dmpl__ItemComponentId__c'
},'dmpl__ItemImageDetail__c');
        List<dmpl__ItemImageDetail__c> details=[
            SELECT 
                Id,
                Coordinate__c,
                Shape__c, 
                LinkUrl__c,
                Detail__c,
                ComponentItemId__c,
                ComponentItemId__r.Name,
                ItemComponentId__c,
                ItemComponentId__r.Name
            FROM 
                dmpl__ItemImageDetail__c 
            WHERE 
                dmpl__ItemId__c=:id];

                
        for(ContentVersion attach:versions){           
            ContentDistribution image=contentList.get(attach.ContentDocumentId);
            if(image!=null){           
                ImageResponse response=new ImageResponse();
                response.PublicUrl=image.DistributionPublicUrl;
                response.DownloadableUrl=image.ContentDownloadUrl;
                response.Details=details;
                return response;
            }
        }
        return null;        
    }

    public class ImageResponse
    {
        @auraenabled
        public string PublicUrl;
        @auraenabled
        public string DownloadableUrl;
        @auraenabled
        public List<dmpl__ItemImageDetail__c> Details;
    } 
    
}