public with sharing class SearchController {
    private final static Integer MAX_RESULTS = 7;

    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> search(
        String searchTerm, 
        List<String> selectedIds,
        String objectApiName,
        String fieldset,
        String filter) {
        // Prepare query parameters
        searchTerm += '*';
        
        List<String> fieldsToReturn = new List<String>();
        if(!string.isBlank(fieldset)){
            List<FieldsetFieldInfo> fields = MetadataHelper.getFieldsByFieldSetName(
                objectApiName, 
                fieldset);
            for(FieldsetFieldInfo field : fields){
                if(field.apiName!= 'Id' && field.apiName!= 'Name'){
                    fieldsToReturn.add(field.apiName);
                }
            }
        }
        String fieldList = 'Id, Name';
        if(fieldsToReturn.size()>0){
            fieldList = fieldList + ', ' + String.join(fieldsToReturn, ',');
        }

        String whereClause = ' WHERE (id NOT IN :selectedIds) ';
        if(!String.isBlank(filter)){
            whereClause = whereClause + ' AND (' + filter + ')';
        }
        // Execute search query
        List<List<SObject>> searchResults = Search.query('FIND :searchTerm IN ALL FIELDS RETURNING ' + 
            objectApiName 
            + '(' 
            + fieldList 
            + whereClause 
            + ' ) LIMIT :MAX_RESULTS');

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Accounts & convert them into LookupSearchResult
        String objectIcon = 'standard:account';
        SObject[] objects = (List<SObject>) searchResults[0];
        for (SObject aObject : objects) {
            String subtitle = (String)aObject.get('Name');
            if(fieldsToReturn.size()>0){
                List<String> subtitleList = new List<String>();
                for(String fieldName : fieldsToReturn){
                    if(aObject.get(fieldName)!=null){
                        subtitleList.add(aObject.get(fieldName).toString());
                    }
                }
                if(subtitleList.size()>0){
                    subtitle = String.join(subtitleList, ' • ');
                }
            }
            
            results.add(new LookupSearchResult(aObject.Id, objectApiName, objectIcon, (String)aObject.get('Name'), subtitle, aObject));
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }

    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> listView(
        List<String> selectedIds,
        String objectApiName,
        String fieldset,
        String filter) {
        
        List<String> fieldsToReturn = new List<String>();
        if(!string.isBlank(fieldset)){
            List<FieldsetFieldInfo> fields = MetadataHelper.getFieldsByFieldSetName(
                objectApiName, 
                fieldset);
            for(FieldsetFieldInfo field : fields){
                if(field.apiName!= 'Id' && field.apiName!= 'Name'){
                    fieldsToReturn.add(field.apiName);
                }
            }
        }
        String fieldList = 'Id, Name';
        if(fieldsToReturn.size()>0){
            fieldList = fieldList + ', ' + String.join(fieldsToReturn, ',');
        }

        String whereClause = ' WHERE (id NOT IN :selectedIds) ';
        if(!String.isBlank(filter)){
            whereClause = whereClause + ' AND (' + filter + ')';
        }
        // Execute search query
        List<SObject> searchResults = Database.query('SELECT  ' + 
            + fieldList
            + ' FROM ' + objectApiName  
            + whereClause 
            + ' LIMIT :MAX_RESULTS');

        // Prepare results
        List<LookupSearchResult> results = new List<LookupSearchResult>();

        // Extract Accounts & convert them into LookupSearchResult
        String objectIcon = 'standard:account';
        for (SObject aObject : searchResults) {
            String subtitle = (String)aObject.get('Name');
            if(fieldsToReturn.size()>0){
                List<String> subtitleList = new List<String>();
                for(String fieldName : fieldsToReturn){
                    if(aObject.get(fieldName)!=null){
                        subtitleList.add(aObject.get(fieldName).toString());
                    }
                }
                if(subtitleList.size()>0){
                    subtitle = String.join(subtitleList, ' • ');
                }
            }
            
            results.add(new LookupSearchResult(aObject.Id, objectApiName, objectIcon, (String)aObject.get('Name'), subtitle, aObject));
        }

        // Optionnaly sort all results on title
        results.sort();

        return results;
    }
    
    @AuraEnabled(cacheable=true scope='global')
    public static List<LookupSearchResult> getRecentlyViewed(
        String objectApiName) {
        List<LookupSearchResult> results = new List<LookupSearchResult>();
        List<RecentlyViewed> recentRecords = [
            SELECT Id, Name
            FROM RecentlyViewed
            WHERE Type = :objectApiName
            ORDER BY LastViewedDate DESC
            LIMIT 7
        ];
        for (RecentlyViewed recentRecord : recentRecords) {
            results.add(
                new LookupSearchResult(
                    recentRecord.Id,
                    objectApiName,
                    'standard:account',
                    recentRecord.Name,
                    recentRecord.Name
                )
            );
        }
        return results;
    }



    /**
     * Class used to serialize a single Lookup search result item
     * The Lookup controller returns a List<LookupSearchResult> when sending search result back to Lightning
     */
    public virtual class LookupSearchResult implements Comparable {
        protected String id;
        protected String sObjectType;
        protected String icon;
        protected String title;
        protected String subtitle;
        protected SObject sourceObject;

        protected LookupSearchResult() {
        }

        /**
         * @param id the lookup entry identifier (generally a record ID)
         * @param sObjectType Optional - The sObject type of the selected record. This value is not used for lookup rendering. It's passed back to the selection handler in case you search on multiple object types.
         * @param icon Optional - A qualified SLDS icon name taken from https://www.lightningdesignsystem.com/icons. It defaults to standard:default.
         * @param title Required - The label of the lookup entry
         * @param subtitle Optional - A subtitle that is displayed under the lookup entry label
         */
        public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle) {
            this.id = id;
            this.sObjectType = sObjectType;
            this.icon = icon;
            this.title = title;
            this.subtitle = subtitle;
        }

        public LookupSearchResult(String id, String sObjectType, String icon, String title, String subtitle, SObject sourceObject) {
            this.id = id;
            this.sObjectType = sObjectType;
            this.icon = icon;
            this.title = title;
            this.subtitle = subtitle;
            this.sourceObject = sourceObject;
        }

        @AuraEnabled
        public String getId() {
            return id;
        }

        @AuraEnabled
        public String getSObjectType() {
            return sObjectType;
        }

        @AuraEnabled
        public String getIcon() {
            return icon;
        }

        @AuraEnabled
        public String getTitle() {
            return title;
        }

        @testVisible
        @AuraEnabled
        public String getSubtitle() {
            return subtitle;
        }

        @testVisible
        @AuraEnabled
        public SObject getSourceObject() {
            return sourceObject;
        }

        /**
         * Allow to sort search results based on title
         */
        @testVisible
        public Integer compareTo(Object compareTo) {
            LookupSearchResult other = (LookupSearchResult) compareTo;
            if (this.getTitle() == null) {
                return (other.getTitle() == null) ? 0 : 1;
            }
            if (other.getTitle() == null) {
                return -1;
            }
            return this.getTitle().compareTo(other.getTitle());
        }
    }
}