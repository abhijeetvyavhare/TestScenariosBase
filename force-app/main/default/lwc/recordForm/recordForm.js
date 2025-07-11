import { LightningElement, api, wire } from 'lwc';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CurrentPageReference } from 'lightning/navigation';
import { CloseActionScreenEvent } from 'lightning/actions';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';

import performSearch from '@salesforce/apex/SearchController.search';
import listView from '@salesforce/apex/SearchController.listView';
import getRecentlyViewed from '@salesforce/apex/SearchController.getRecentlyViewed';

import getScreenActionSettings from '@salesforce/apex/ScreenActionController.geScreenActionSettings';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getUserDefaults from '@salesforce/apex/RecordFormController.getUserDefaults';
import getPostalCodeDefaults from '@salesforce/apex/RecordFormController.getPostalCodeDefaults';
import getAccountDefaults from '@salesforce/apex/RecordFormController.getAccountDefaults';
import getAssetDefaults from '@salesforce/apex/RecordFormController.getAssetDefaults';
import getAllFieldMappings from '@salesforce/apex/RecordFormController.getAllFieldMappings';
import getFieldMappingsData from '@salesforce/apex/RecordFormController.getFieldMappingsData';
import getAccountAddressDefaults from '@salesforce/apex/RecordFormController.getAccountAddressDefaults';

const SAS_NAME = 'Screen Action Settings';

const OBJECT_ACCOUNT = 'Account';

const DELAY = 50;
const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_CONTACTID = 'dmpl__ContactId__c'
const FIELD_RESOURCEID = 'dmpl__ResourceId__c';
const FIELD_SALEEXECUTIVEID = 'dmpl__SalesExecutiveId__c';
const FIELD_FIRSTNAME = 'dmpl__FirstName__c';
const FIELD_LASTNAME = 'dmpl__LastName__c';
const FIELD_NAME = 'Name';
const FIELD_ASSETID = 'dmpl__AssetId__c'
const FIELD_ADDRESSID = 'dmpl__ContactAddressId__c'

const FIELD_CITY = 'dmpl__City__c';
const FIELD_CITYID = 'dmpl__CityPlaceId__c';
const FIELD_COUNTRY = 'dmpl__Country__c';
const FIELD_REGION = 'dmpl__Region__c';
const FIELD_STATE = 'dmpl__State__c';
const FIELD_POSTALCODE = 'dmpl__PostalCode__c';

const FIELD_BILLINGADDRESSID = 'dmpl__BillingAddressId__c';
const FIELD_BILLINGCITY = 'dmpl__BillingCity__c';
const FIELD_BILLINGCITYID = 'dmpl__BillingCityPlaceId__c';
const FIELD_BILLINGCOUNTRY = 'dmpl__BillingCountry__c';
const FIELD_BILLINGREGION = 'dmpl__BillingRegion__c';
const FIELD_BILLINGSTATE = 'dmpl__BillingState__c';
const FIELD_BILLINGSTREET = 'dmpl__BillingStreet__c';
const FIELD_BILLINGPOSTALCODE = 'dmpl__BillingPostalCode__c';

const FIELD_SHIPPINGADDRESSID = 'dmpl__ShippingAddressId__c';
const FIELD_SHIPPINGCITY = 'dmpl__ShippingCity__c';
const FIELD_SHIPPINGCITYID = 'dmpl__ShippingCityPlaceId__c';
const FIELD_SHIPPINGCOUNTRY = 'dmpl__ShippingCountry__c';
const FIELD_SHIPPINGREGION = 'dmpl__ShippingRegion__c';
const FIELD_SHIPPINGSTATE = 'dmpl__ShippingState__c';
const FIELD_SHIPPINGSTREET = 'dmpl__ShippingStreet__c';
const FIELD_SHIPPINGPOSTALCODE = 'dmpl__ShippingPostalCode__c';

export default class recordForm extends NavigationMixin(LightningElement) {
    @api title = 'New';
    @api objectApiName;
    @api recordTypeId='';

    @api sectionHeading = 'Basic Details';
    @api recordFieldsetName;

    @api tabTitle1;
    @api tab1sectionHeading1;
    @api tab1recordFieldsetName1;
    @api tab1sectionHeading2;
    @api tab1recordFieldsetName2;
    @api tab1sectionHeading3;
    @api tab1recordFieldsetName3;

    @api tabTitle2;
    @api tab2sectionHeading1;
    @api tab2recordFieldsetName1;
    @api tab2sectionHeading2;
    @api tab2recordFieldsetName2;
    @api tab2sectionHeading3;
    @api tab2recordFieldsetName3;

    @api tabTitle3;
    @api tab3sectionHeading1;
    @api tab3recordFieldsetName1;
    @api tab3sectionHeading2;
    @api tab3recordFieldsetName2;
    @api tab3sectionHeading3;
    @api tab3recordFieldsetName3;

    @api hideSubmit;
    @api recordId;
    @api layoutType; //Deprecated
    @api viewMode;//Deprecated
    @api pageReference;// Deprecated

    privateDefaultFieldValues;
    currentPageReference = null;
    urlStateParameters = null;
    screenActionSettingId;
    showLoader = true;
    shippingAddressId;
    billingAddressId;
    billingAddressOptions = []
    shippingAddressOptions = []
    customLookupColumns = [null,null];
    defaultedSearch ={};

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.urlStateParameters = currentPageReference.state;
            if(currentPageReference.state?.recordTypeId){
                this.recordTypeId = currentPageReference.state?.recordTypeId;
            }
            this.setParametersBasedOnUrl();
        }
    }
    
    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    objectInfo;

    @api
    get defaultFieldValues() {
        return this.privateDefaultFieldValues;
    }
    set defaultFieldValues(value) {
        this.privateDefaultFieldValues = value;
        this.setAttribute('defaultFieldValues', this.privateDefaultFieldValues);
        this.populateDefaultValues();
    }

    @wire(getUserDefaults, {})
    userDefaults;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$recordFieldsetName' })
    fieldsetFields;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab1recordFieldsetName1' })
    tab1fieldsetFields1;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab1recordFieldsetName2' })
    tab1fieldsetFields2;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab1recordFieldsetName3' })
    tab1fieldsetFields3;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab2recordFieldsetName1' })
    tab2fieldsetFields1;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab2recordFieldsetName2' })
    tab2fieldsetFields2;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab2recordFieldsetName3' })
    tab2fieldsetFields3;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab3recordFieldsetName1' })
    tab3fieldsetFields1;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab3recordFieldsetName2' })
    tab3fieldsetFields2;

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$tab3recordFieldsetName3' })
    tab3fieldsetFields3;

    @wire(getScreenActionSettings, { objectApiName: '$objectApiName', recordTypeId : '$recordTypeId' })
    wiredGetScreenActionSettings(d) {
        if (d.data && d.data.length > 0) {
            let data = d.data[0];
            this.screenActionSettingId = data.Id;
            this.disabledFields = data.dmpl__DisabledFields__c;
            this.recordFieldsetName = data.dmpl__RecordPanelFieldset__c;
            this.sectionHeading = data.dmpl__RecordPanelTitle__c;
            this.tab1sectionHeading1 = data.dmpl__Tab1Section1Title__c;
            this.tab1recordFieldsetName1 = data.dmpl__Tab1Section1Fieldset__c;
            this.tab1sectionHeading2 = data.dmpl__Tab1Section2Title__c;
            this.tab1recordFieldsetName2 = data.dmpl__Tab1Section2Fieldset__c;
            this.tab1sectionHeading3 = data.dmpl__Tab1Section3Title__c;
            this.tab1recordFieldsetName3 = data.dmpl__Tab1Section3Fieldset__c;
            this.tab2sectionHeading1 = data.dmpl__Tab2Section1Title__c;
            this.tab2recordFieldsetName1 = data.dmpl__Tab2Section1Fieldset__c;
            this.tab2sectionHeading2 = data.dmpl__Tab2Section2Title__c;
            this.tab2recordFieldsetName2 = data.dmpl__Tab2Section2Fieldset__c;
            this.tab2sectionHeading3 = data.dmpl__Tab2Section3Title__c;
            this.tab2recordFieldsetName3 = data.dmpl__Tab2Section3Fieldset__c;
            this.tab3sectionHeading1 = data.dmpl__Tab3Section1Title__c;
            this.tab3recordFieldsetName1 = data.dmpl__Tab3Section1Fieldset__c;
            this.tab3sectionHeading2 = data.dmpl__Tab3Section2Title__c;
            this.tab3recordFieldsetName2 = data.dmpl__Tab3Section2Fieldset__c;
            this.tab3sectionHeading3 = data.dmpl__Tab3Section3Title__c;
            this.tab3recordFieldsetName3 = data.dmpl__Tab3Section3Fieldset__c;
            
            this.tabTitle1 = data.dmpl__Tab1Title__c;
            this.title = data.dmpl__Title__c;
            this.tabTitle3 = data.dmpl__Tab3Title__c;
            this.tabTitle2 = data.dmpl__Tab2Title__c;
            
            this.customLookupFieldName = data.dmpl__CustomLookupFieldName__r?.QualifiedApiName;
            this.customLookupFieldsetName = data.dmpl__CustomLookupFieldsetName__c;
            this.customLookupShowNew = data.dmpl__CustomLookupShowNew__c;
            this.customLookupFilter = data.dmpl__CustomLookupFilter__c?data.dmpl__CustomLookupFilter__c : '';
            this.customLookupFieldName2 = data.dmpl__CustomLookupFieldName2__r?.QualifiedApiName;
            this.customLookupFieldsetName2 = data.dmpl__CustomLookupFieldsetName2__c;
            this.customLookupFilter2 = data.dmpl__CustomLookupFilter2__c?data.dmpl__CustomLookupFilter2__c : '';
            this.hideLeftPanel = data.dmpl__HideLeftPanel__c;
            this.showBillingAddressOptions = data.dmpl__ShowBillingAddressOptions__c;
            this.showShippingAddressOptions = data.dmpl__ShowShippingAddressOptions2__c;
            this.showNewAccountAction = data.dmpl__ShowNewAccountAction__c;
            this.hideDefaultShippingAddress = data.dmpl__HideDefaultShippingAddress2__c;
            this.hideDefaultBillingAddress = data.dmpl__HideDefaultBillingAddress__c;
        }
    }; 

    @wire(getAllFieldMappings, { destinationObjectApiName: '$objectApiName' })
    wiredFieldMapping(d) {
        if (d.data && d.data.length > 0) {
            this.fieldMappings = d.data;
        }
    };

    get isBillingAddressOptionsVisible(){
        return this.showBillingAddressOptions;
    }
    
    get isBillingAddressOptionsSmall(){
        return this.billingAddressOptions?.length <5;
    }

    get isShippingAddressOptionsVisible(){
        return this.showShippingAddressOptions;
    }
    
    get isShippingAddressOptionsSmall(){
        return this.shippingAddressOptions?.length <5;
    }

    get getFieldsetFields() {
        if (this.fieldsetFields && this.fieldsetFields.data) {
            return this.extendFieldValues(this.fieldsetFields.data);
        }
    }

    get getTab1FieldsetFields1() {
        if (this.tab1fieldsetFields1 && this.tab1fieldsetFields1.data) {
            return this.extendFieldValues(this.tab1fieldsetFields1.data);
        }
    }

    get getTab1FieldsetFields2() {
        if (this.tab1fieldsetFields2 && this.tab1fieldsetFields2.data) {
            return this.extendFieldValues(this.tab1fieldsetFields2.data);
        }
    }

    get getTab1FieldsetFields3() {
        if (this.tab1fieldsetFields3 && this.tab1fieldsetFields3.data) {
            return this.extendFieldValues(this.tab1fieldsetFields3.data);
        }
    }

    get getTab2FieldsetFields1() {
        if (this.tab2fieldsetFields1 && this.tab2fieldsetFields1.data) {
            return this.extendFieldValues(this.tab2fieldsetFields1.data);
        }
    }

    get getTab2FieldsetFields2() {
        if (this.tab2fieldsetFields2 && this.tab2fieldsetFields2.data) {
            return this.extendFieldValues(this.tab2fieldsetFields2.data);
        }
    }
    
    get getTab2FieldsetFields3() {
        if (this.tab2fieldsetFields3 && this.tab2fieldsetFields3.data) {
            return this.extendFieldValues(this.tab2fieldsetFields3.data);
        }
    }

    get getTab3FieldsetFields1() {
        if (this.tab3fieldsetFields1 && this.tab3fieldsetFields1.data) {
            return this.extendFieldValues(this.tab3fieldsetFields1.data);
        }
    }

    get getTab3FieldsetFields2() {
        if (this.tab3fieldsetFields2 && this.tab3fieldsetFields2.data) {
            return this.extendFieldValues(this.tab3fieldsetFields2.data);
        }
    }
    
    get getTab3FieldsetFields3() {
        if (this.tab3fieldsetFields3 && this.tab3fieldsetFields3.data) {
            return this.extendFieldValues(this.tab3fieldsetFields3.data);
        }
    }

    get isLoaded() {
        return (this.fieldsetFields.data || this.fieldsetFields.error);
    }

    get isSubmitDisabled() {
        return (!this.fieldsetFields);
    }

    get showNewAccount(){
        return (this.showNewAccountAction);
    }

    extendFieldValues(data) {
        if (!Array.isArray(data)) {
            return data;
        }
        data = JSON.parse(JSON.stringify(data));
        data = this.extendDisabledValues(data);
        data = data.map(v => {
            if(this.customLookupFieldName == v.apiName){
                v['isCustomLookup'] = true;
                v['showNew'] = this.customLookupShowNew;
                v['searchFieldset'] = this.customLookupFieldsetName;
                v['searchFilter'] = this.customLookupFilter;
            }
            if(this.customLookupFieldName2 == v.apiName){
                v['isCustomLookup'] = true;
                v['searchFieldset'] = this.customLookupFieldsetName2;
                v['searchFilter'] = this.customLookupFilter2;
            }
            return v;
        });
        return data;
    }
    
    extendDisabledValues(data) {
        if (!this.disabledFields) {
            return data;
        }
        data = JSON.parse(JSON.stringify(data));
        return data.map(v => {
            v['disabled'] = this.disabledFields.indexOf(v['apiName']) >= 0;
            return v;
        });
    }

    populateDefaultValues(fireChange) {
        if (!this.privateDefaultFieldValues) {
            return;
        }
        this.privateDefaultFieldValues.split(',').forEach(p => {
            if (p) {
                const nvPair = p.split("|");
                if (nvPair.length == 2) {
                    this.setDefaultValue(nvPair[0], nvPair[1], fireChange);
                }
            }
        });
    }

    populateHardCodedDefaultValues(fireChange) {
        if (this.userDefaults && this.userDefaults.data) {
            if (this.userDefaults.data.dmpl__DefaultBranchId__c) {
                this.setDefaultValue(FIELD_BRANCHID, this.userDefaults.data.dmpl__DefaultBranchId__c, fireChange);
            }
            if (this.userDefaults.data.dmpl__DefaultPartnerAccountId__c) {
                this.setDefaultValue(FIELD_PARTNER_ACCOUNTID, this.userDefaults.data.dmpl__DefaultPartnerAccountId__c, fireChange);
            }
            if (this.userDefaults.data.Id) {
                this.setDefaultValue(FIELD_RESOURCEID, this.userDefaults.data.Id, fireChange);
                this.setDefaultValue(FIELD_SALEEXECUTIVEID, this.userDefaults.data.Id, fireChange);    
                this.copyFieldMappingData('dmpl__Resource__c', this.userDefaults.data.Id);
            }
        }
    }

    setParametersBasedOnUrl() {
        if (this.urlStateParameters.dmpl__ParterAccountId__c ? 
            this.urlStateParameters.dmpl__ParterAccountId__c :
            this.urlStateParameters.ParterAccountId__c) {
            this.setDefaultValue(
                FIELD_PARTNER_ACCOUNTID, 
                this.urlStateParameters.dmpl__ParterAccountId__c ? 
                    this.urlStateParameters.dmpl__ParterAccountId__c :
                    this.urlStateParameters.ParterAccountId__c, 
                true);
        }
        
        if (this.urlStateParameters.dmpl__BranchId__c ? 
            this.urlStateParameters.dmpl__BranchId__c : 
            this.urlStateParameters.BranchId__c) {
            this.setDefaultValue(FIELD_BRANCHID, 
                this.urlStateParameters.dmpl__BranchId__c ? 
                    this.urlStateParameters.dmpl__BranchId__c : 
                    this.urlStateParameters.BranchId__c, 
                true);
        }

        if (this.urlStateParameters.dmpl__AccountId__c ? 
            this.urlStateParameters.dmpl__AccountId__c : 
            this.urlStateParameters.AccountId__c ? 
                this.urlStateParameters.AccountId__c : 
                this.urlStateParameters.AccountId) {
            this.setDefaultValue(FIELD_ACCOUNTID, 
                this.urlStateParameters.dmpl__AccountId__c ? 
                    this.urlStateParameters.dmpl__AccountId__c : 
                    this.urlStateParameters.AccountId__c ? 
                        this.urlStateParameters.AccountId__c : 
                        this.urlStateParameters.AccountId, 
                true);
        }
    }

    setDefaultValue(name, value, fireChange) {
        let fields = this.getAllInputFields().filter(v=>
            v.fieldName == name 
            || v.fieldName == 'dmpl__.' + name
            || v.fieldName == name.replace('dmpl__',''));
        fields.forEach(field=> {
            if (field && field.value != value) {
                    if(value){
                        field.value = value == "true" ? true : value == "false" ? false : value;
                    }else{
                        field.value = null;
                    }
                    if (fireChange) {
                        this.fireChangeEvent(name, value);
                    }
                }
            });
        // let searchField = this.getSearchField(name);
        // if(searchField){
        //     if(value && searchField.selection != value){
        //         searchField.selection = value;
        //     }
        // }
    }

    getFieldValue(name) {
        const inputFields = this.getAllInputFields();
        return inputFields && inputFields.find(f => f.fieldName == name)?.value;
    }

    getSearchField(name){
        const inputFields = this.template.querySelectorAll(
            'c-dmpl-lookup'
        );
        if (inputFields) {
            return Array.from(inputFields)?.find(v=>v.name == name);
        }
        return null;
    }

    getAllInputFields(){
        let inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        return inputFields.concat(this.template.querySelectorAll(
            'c-dmpl-lookup'
        ));
    }

    @api
    invokeSave() {
        const btn = this.template.querySelector("lightning-button");
        if (btn) {
            btn.click();
        }
    }

    connectedCallback(){
    }
    
    async handleSuccess(event) {
        this.showLoader = false;
        this.recordId = event.detail ? event.detail.id : undefined;
        let documentName = this.getFieldValue('Name');
        var messsage = this.recordId ? `Document ${documentName ? documentName : ''} created successfully.` : 'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        this.handleReset();
        refreshApex(this.recordId);
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        this.refreshStdComponents();
        this.fireSavedEvent();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    handleClose(event) {
        this.fireCloseEvent();
    }

    async handleSave(event) {
        this.showLoader = true;
        this.template.querySelector('lightning-record-edit-form').submit();
    }

    handleLoad() {
        setTimeout(()=>{
            this.showLoader = false;
        }, 1000)
        this.populateDefaultValues(true);
        this.populateHardCodedDefaultValues(true);
    }

    handleError(error) {
        this.showLoader = false;
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        const fsField = this.getFieldsetFields && this.getFieldsetFields.length > 0 ? this.getFieldsetFields[0] : undefined;
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    handleNewClick(){
        let refrences = this.objectInfo.data?.fields[this.customLookupFieldName]?.referenceToInfos;
        if(refrences && refrences.length>0){
            let newPageRef = {
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: refrences[0].apiName,
                    actionName: 'new'
                }
            };
            this[NavigationMixin.Navigate](newPageRef);
        }
    }

    handleFieldChange(event) {
        if ((!event.target) || (!event.target.id))
            return;
        const target = event.target.id.slice(0, event.target.id.lastIndexOf('-'));
        var value = undefined;
        if (event.detail.value) {
            if (Array.isArray(event.detail.value) && Array.from(event.detail.value).length > 0) {
                value = event.detail.value[0];
            } else if (!(typeof event.detail.value === 'object')) {
                value = event.detail.value;
            }
        } else if ('checked' in event.detail) {
            value = event.detail.checked;
        }
        this.fireChangeEvent(target, value);
    }
 
    async handleSearch(event){
        let fieldName = event.detail.name;
        let fieldsetName = fieldName == this.customLookupFieldName ? 
            this.customLookupFieldsetName : this.customLookupFieldsetName2;
        let lookupIndex = fieldName == this.customLookupFieldName?0:1;
        let refrences = this.objectInfo.data?.fields[fieldName]?.referenceToInfos;
        if(refrences && refrences.length>0){
            try{
                const result = await performSearch({ 
                    searchTerm: event.detail.searchTerm, 
                    selectedIds: event.detail.selectedIds, 
                    objectApiName: refrences[0].apiName,
                    fieldset: fieldsetName ? fieldsetName : '',
                    filter: this.parseDynamicString(fieldName == this.customLookupFieldName ? 
                        this.customLookupFilter : this.customLookupFilter2)
                });

                if (result) {
                    let field = this.getSearchField(event.detail.name);
                    if(field){
                        if(!this.customLookupColumns[lookupIndex]){
                            if(fieldsetName){
                                getFieldsByFieldSetName({ 
                                    objectApiName: refrences[0].apiName, 
                                    fieldSetName: fieldsetName })
                                .then(fsResult => {
                                    this.customLookupColumns[lookupIndex] = fsResult.map(v=> {
                                        return {
                                            label: v.label,
                                            fieldName: v.apiName, 
                                            hideDefaultActions: true,
                                        }
                                    });
                                    field.setSearchCoulmns(this.customLookupColumns[lookupIndex]);
                                    field.setSearchResults(result);
                                })
                                .catch(error => {
                                    this.error = error;
                                }); 
                            }else{
                                field.setSearchCoulmns([{
                                    label: 'Name',
                                    fieldName: 'Name', 
                                    hideDefaultActions: true
                                }]);
                                field.setSearchResults(result);
                            }
                        }else{
                            field.setSearchCoulmns(this.customLookupColumns[lookupIndex]);
                            field.setSearchResults(result);
                        }
                    }
                }
            }catch(error){
                this.error = error;
            }
        }
    }

    async handleSearchFocus(event){
        if(!this.getFieldsetFields){
            return;
        }
        let fieldName = event.detail.name;
        if(this.defaultedSearch[fieldName]){
            return;
        }
        let searchField = this.getFieldsetFields.find(f=>f.apiName == fieldName);
        if(searchField) {
            let refrences = this.objectInfo.data?.fields[searchField.apiName]?.referenceToInfos;
            let field = this.getSearchField(searchField.apiName);
            if(field && refrences && refrences.length>0){
                try{
                    let result = undefined;
                    if(searchField.searchFilter){
                        result = await listView({ 
                            selectedIds: [], 
                            objectApiName: refrences[0].apiName,
                            fieldset: fieldName == this.customLookupFieldName ? 
                                this.customLookupFieldsetName : this.customLookupFieldsetName2,
                            filter: this.parseDynamicString(fieldName == this.customLookupFieldName ? 
                                this.customLookupFilter : this.customLookupFilter2)
                        });
                    }else {
                        result = await getRecentlyViewed({ 
                            objectApiName: refrences[0].apiName});
                    }
                    if (result) {
                        field.setDefaultResults(result);
                        this.defaultedSearch[fieldName] = true;
                    }
                }catch(e){
                    this.handleError(e);
                }
            }
        }
    }

    handleSelectionChange(event){
        if(event.detail.selectedIds && event.detail.selectedIds.length>0){
            this.setDefaultValue(
                event.detail.name, 
                event.detail.selectedIds[0],
                true);
        }else{
            this.setDefaultValue(
                event.detail.name, 
                null,
                true);
        }
    }

    handleBillingAddressChange(event){
        this.billingAddressId = event.detail.value;
        this.handleBillingAddressIdChange();
    }

    handleShippingAddressChange(event){
        this.shippingAddressId = event.detail.value;
        this.handleShippingAddressIdChange();
    }
    
    handleNewAccount(event){
        let newPageRef = {
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Account',
                actionName: 'new'
            }
        };
        this[NavigationMixin.Navigate](newPageRef);
    }

    fireChangeEvent(name, value) {
        window.clearTimeout(this.delayTimeout);
        this.delayTimeout = setTimeout(() => {
            const filters = {
                name: name,
                value: value
            };
            this.dispatchEvent(new CustomEvent('valuechanged', { "detail": filters }));
            if (name == FIELD_POSTALCODE || 'dmpl__' + name == FIELD_POSTALCODE) {
                this.handlePostalCodeChange(value);
            } else if (name == FIELD_ACCOUNTID || 'dmpl__' + name == FIELD_ACCOUNTID) {
                this.handleAccountIdChange(value);
            } else if (name == FIELD_CONTACTID || 'dmpl__' + name == FIELD_CONTACTID) {
                this.handleContactIdChange(value);
            } else if (name == FIELD_BILLINGPOSTALCODE || 'dmpl__' + name == FIELD_BILLINGPOSTALCODE) {
                this.handleBillingPostalCodeChange(value);
            } else if (name == FIELD_SHIPPINGPOSTALCODE || 'dmpl__' + name == FIELD_SHIPPINGPOSTALCODE) {
                this.handleShippingPostalCodeChange(value);
            } else if ((name == FIELD_FIRSTNAME || 'dmpl__' + name == FIELD_FIRSTNAME) && this.objectApiName == OBJECT_ACCOUNT) {
                this.handleFirstNameChange(value);
            } else if ((name == FIELD_LASTNAME || 'dmpl__' + name == FIELD_LASTNAME) && this.objectApiName == OBJECT_ACCOUNT) {
                this.handleLastNameChange(value);
            } else if (name == FIELD_ASSETID ||'dmpl__' + name == FIELD_ASSETID) {
                this.handleAssetChange(value);
            }
            else if (name == FIELD_ADDRESSID || 'dmpl__' + name == FIELD_ADDRESSID) {
                this.handleContactAddressIdChange(value);
            } else {
                this.copyFieldMapping(name, value);
            }
        }, DELAY);
    }

    fireSavedEvent() {
        const filters = {
            Id: this.recordId
        };
        this.dispatchEvent(new CustomEvent('recordsaved', { "detail": filters }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    fireCloseEvent() {
        const filters = {
            Id: this.recordId
        };
        this.dispatchEvent(new CustomEvent('closeclicked', { "detail": filters }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    
    parseDynamicString(query){
        const matches = query.match(/\{(.*?)\}/g);
        const result = [];
        if (matches) {
            for (let i = 0; i < matches.length; ++i) {
                const match = matches[i];
                const fiedlName = match.substring(1, match.length - 1);
                let fv = this.getFieldValue(fiedlName);
                if(!fv){
                    return '';
                }
                query = query.replace(match, fv);
            }
        }
        return query;
    }

    async handleAccountIdChange(accountId) {
        try {
            this.resetBillingAddress();
            this.resetShippingAddress();
            const result = await getAccountDefaults({ accountId: accountId });
            let bOptions = this.hideDefaultBillingAddress ? [] : [{ label: 'Default', value: 'default' }];
            let sOptions = this.hideDefaultShippingAddress ? [] : [{ label: 'Default', value: 'default' }];
            if (result) {
                this.accountData = result;
                this.setDefaultBillingAddress(result.dmpl__ContactAddress__r);
                this.setDefaultShippingAddress(result.dmpl__ContactAddress__r);
                if(result.dmpl__ContactAddress__r){
                    this.billingAddressOptions = bOptions.concat(result.dmpl__ContactAddress__r.filter(v=>
                        v.dmpl__AddressType__c == 'Billing Address' 
                        || v.dmpl__AddressType__c == 'Both').map(v=>{
                            return { label: v.Name, value: v.Id }
                    }));
                    this.shippingAddressOptions = sOptions.concat(result.dmpl__ContactAddress__r.filter(v=>
                        v.dmpl__AddressType__c == 'Shipping Address' 
                        || v.dmpl__AddressType__c == 'Both').map(v=>{
                            return { label: v.Name, value: v.Id }
                    }));
                }
                this.copyFieldMappingData('Account', accountId);
            }else{
                this.billingAddressOptions = bOptions;
                this.shippingAddressOptions = sOptions;
                this.copyFieldMappingData('Account');
            }
        }
        catch (error) {
            console.log('error ', error);
        }
    }

    async handleAssetChange(assetId){
        const result = await getAssetDefaults({ assetId: assetId });
        if (result) {
            this.assetData = result;
            this.setDefaultValue(FIELD_ACCOUNTID, this.assetData.AccountId, true);
            this.copyFieldMappingData('Asset', assetId);
        }else{
            this.copyFieldMappingData('Asset');
        }
    }

    async handleContactIdChange(contactId){
        this.copyFieldMappingData('Contact', contactId);
    }
    
    async handlePostalCodeChange(postalCode) {
        try {
            const result = await getPostalCodeDefaults({ postalCode: postalCode });
            if (result) {
                this.setDefaultValue(FIELD_CITY, result.dmpl__City__c, true);
                this.setDefaultValue(FIELD_CITYID, result.dmpl__CityPlaceId__c, true);
                this.setDefaultValue(FIELD_COUNTRY, result.dmpl__Country__c, true);
                this.setDefaultValue(FIELD_REGION, result.dmpl__Region__c, true);
                this.setDefaultValue(FIELD_STATE, result.dmpl__State__c, true);
            }
        }
        catch (error) {
            console.log('error ', error);
        }
    }

    async handleBillingPostalCodeChange(postalCode) {
        try {
            const result = await getPostalCodeDefaults({ postalCode: postalCode });
            if (result) {
                this.setDefaultValue(FIELD_BILLINGCITY, result.dmpl__City__c, true);
                this.setDefaultValue(FIELD_BILLINGCITYID, result.dmpl__CityPlaceId__c, true);
                this.setDefaultValue(FIELD_BILLINGCOUNTRY, result.dmpl__Country__c, true);
                this.setDefaultValue(FIELD_BILLINGREGION, result.dmpl__Region__c, true);
                this.setDefaultValue(FIELD_BILLINGSTATE, result.dmpl__State__c, true);
            }
        }
        catch (error) {
            console.log('error ', error);
        }
    }
    
    async handleShippingPostalCodeChange(postalCode) {
        try {
            const result = await getPostalCodeDefaults({ postalCode: postalCode });
            if (result) {
                this.setDefaultValue(FIELD_SHIPPINGCITY, result.dmpl__City__c, true);
                this.setDefaultValue(FIELD_SHIPPINGCITYID, result.dmpl__CityPlaceId__c, true);
                this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, result.dmpl__Country__c, true);
                this.setDefaultValue(FIELD_SHIPPINGREGION, result.dmpl__Region__c, true);
                this.setDefaultValue(FIELD_SHIPPINGSTATE, result.dmpl__State__c, true);
            }
        }
        catch (error) {
            console.log('error ', error);
        }
    }


    async handleContactAddressIdChange(addressId) {
        try {
            const result = await getAccountAddressDefaults({ addressId: addressId });
            if (result) {
                this.setDefaultValue(FIELD_ACCOUNTID, result.dmpl__AccountId__c, true);
                this.setDefaultValue(FIELD_BILLINGSTREET, result.dmpl__Street__c, true);
                this.setDefaultValue(FIELD_BILLINGPOSTALCODE, result.dmpl__PostalCode__c, true);
                this.setDefaultValue(FIELD_BILLINGCITY, result.dmpl__City__c, true);
                this.setDefaultValue(FIELD_BILLINGCITYID, result.dmpl__CityPlaceId__c, true);
                this.setDefaultValue(FIELD_BILLINGCOUNTRY, result.dmpl__Country__c, true);
                this.setDefaultValue(FIELD_BILLINGREGION, result.dmpl__Region__c, true);
                this.setDefaultValue(FIELD_BILLINGSTATE, result.dmpl__State__c, true);
                this.setDefaultValue(FIELD_SHIPPINGSTREET, result.dmpl__Street__c, true);
                this.setDefaultValue(FIELD_SHIPPINGPOSTALCODE, result.dmpl__PostalCode__c, true);
                this.setDefaultValue(FIELD_SHIPPINGCITY, result.dmpl__City__c, true);
                this.setDefaultValue(FIELD_SHIPPINGCITYID, result.dmpl__CityPlaceId__c, true);
                this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, result.dmpl__Country__c, true);
                this.setDefaultValue(FIELD_SHIPPINGREGION, result.dmpl__Region__c, true);
                this.setDefaultValue(FIELD_SHIPPINGSTATE, result.dmpl__State__c, true);
            }
        }
        catch (error) {
            console.log('error ', error);
        }
    }


    handleBillingAddressIdChange() {
        if(this.billingAddressId == 'default'){
            this.setDefaultValue(FIELD_BILLINGADDRESSID, undefined, false)
            this.setDefaultBillingAddress(this.accountData?.dmpl__ContactAddress__r);
        }else {
            this.setDefaultValue(FIELD_BILLINGADDRESSID, this.billingAddressId, false)
            let address = this.accountData?.dmpl__ContactAddress__r?.find(a=>a.Id == this.billingAddressId);
            if(!address){
                return
            }
            this.setDefaultValue(FIELD_BILLINGSTREET, address.dmpl__Street__c, true);
            this.setDefaultValue(FIELD_BILLINGPOSTALCODE, address.dmpl__PostalCode__c, true);
            this.setDefaultValue(FIELD_BILLINGCITY, address.dmpl__City__c, true);
            this.setDefaultValue(FIELD_BILLINGCITYID, address.dmpl__CityPlaceId__c, true);
            this.setDefaultValue(FIELD_BILLINGCOUNTRY, address.dmpl__Country__c, true);
            this.setDefaultValue(FIELD_BILLINGREGION, address.dmpl__Region__c, true);
            this.setDefaultValue(FIELD_BILLINGSTATE, address.dmpl__State__c, true);
        }
    }

    handleShippingAddressIdChange() {
        if(this.shippingAddressId == 'default'){
            this.setDefaultValue(FIELD_SHIPPINGADDRESSID, undefined, false)
            this.setDefaultShippingAddress(this.accountData?.dmpl__ContactAddress__r);
        }else {
            this.setDefaultValue(FIELD_SHIPPINGADDRESSID, this.shippingAddressId, false)
            let address = this.accountData?.dmpl__ContactAddress__r?.find(a=>a.Id == this.shippingAddressId);
            if(!address){
                return
            }
            this.setDefaultValue(FIELD_SHIPPINGSTREET, address.dmpl__Street__c, true);
            this.setDefaultValue(FIELD_SHIPPINGPOSTALCODE, address.dmpl__PostalCode__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCITY, address.dmpl__City__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCITYID, address.dmpl__CityPlaceId__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, address.dmpl__Country__c, true);
            this.setDefaultValue(FIELD_SHIPPINGREGION, address.dmpl__Region__c, true);
            this.setDefaultValue(FIELD_SHIPPINGSTATE, address.dmpl__State__c, true);
        }
    }

    async resetBillingAddress() {
        this.billingAddressId = 'default';
        this.setDefaultValue(FIELD_BILLINGADDRESSID, null, false);
        this.setDefaultValue(FIELD_BILLINGSTREET, null, false);
        this.setDefaultValue(FIELD_BILLINGPOSTALCODE, null, false);
        this.setDefaultValue(FIELD_BILLINGCITY, null, false);
        this.setDefaultValue(FIELD_BILLINGCITYID, null, false);
        this.setDefaultValue(FIELD_BILLINGCOUNTRY, null, false);
        this.setDefaultValue(FIELD_BILLINGREGION, null, false);
        this.setDefaultValue(FIELD_BILLINGSTATE, null, false);
    }

    setDefaultBillingAddress(addresses){
        if(!this.hideDefaultBillingAddress){
            if(!this.accountData){
                return;
            }    
            this.setDefaultValue(FIELD_BILLINGPOSTALCODE, this.accountData.dmpl__BillingPostalCode__c, false);
            this.setDefaultValue(FIELD_BILLINGCITY, this.accountData.dmpl__BillingCity__c, false);
            this.setDefaultValue(FIELD_BILLINGCITYID, this.accountData.dmpl__BillingCityPlaceId__c, false);
            this.setDefaultValue(FIELD_BILLINGCOUNTRY, this.accountData.dmpl__BillingCountry__c, false);
            this.setDefaultValue(FIELD_BILLINGREGION, this.accountData.dmpl__BillingRegion__c, false);
            this.setDefaultValue(FIELD_BILLINGSTATE, this.accountData.dmpl__BillingState__c, false);
            this.setDefaultValue(FIELD_BILLINGADDRESSID, this.accountData.dmpl__BilingAddressId__c, false);
            this.setDefaultValue(FIELD_BILLINGSTREET, this.accountData.dmpl__BillingStreet__c, false);
        }else{
            let address = addresses?.find(v=> (v.dmpl__AddressType__c == 'Billing Address' 
                || v.dmpl__AddressType__c == 'Both') && v.dmpl__IsDefault__c);
            if(!address){
                return;
            }
            this.billingAddressId = address.Id;
            this.setDefaultValue(FIELD_BILLINGADDRESSID, address.Id, true);
            this.setDefaultValue(FIELD_BILLINGSTREET, address.dmpl__Street__c, true);
            this.setDefaultValue(FIELD_BILLINGPOSTALCODE, address.dmpl__PostalCode__c, true);
            this.setDefaultValue(FIELD_BILLINGCITY, address.dmpl__City__c, true);
            this.setDefaultValue(FIELD_BILLINGCITYID, address.dmpl__CityPlaceId__c, true);
            this.setDefaultValue(FIELD_BILLINGCOUNTRY, address.dmpl__Country__c, true);
            this.setDefaultValue(FIELD_BILLINGREGION, address.dmpl__Region__c, true);
            this.setDefaultValue(FIELD_BILLINGSTATE, address.dmpl__State__c, true);
        }
    }

    async resetShippingAddress() {
        this.shippingAddressId = 'default';
        this.setDefaultValue(FIELD_SHIPPINGADDRESSID, null, false);
        this.setDefaultValue(FIELD_SHIPPINGSTREET, null, false);
        this.setDefaultValue(FIELD_SHIPPINGPOSTALCODE, null, false);
        this.setDefaultValue(FIELD_SHIPPINGCITY, null, false);
        this.setDefaultValue(FIELD_SHIPPINGCITYID, null, false);
        this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, null, false);
        this.setDefaultValue(FIELD_SHIPPINGREGION, null, false);
        this.setDefaultValue(FIELD_SHIPPINGSTATE, null, false);
    }

    setDefaultShippingAddress(addresses){
        if(!this.hideDefaultBillingAddress){
            if(!this.accountData){
                return;
            }
            this.setDefaultValue(FIELD_SHIPPINGPOSTALCODE, this.accountData.dmpl__ShippingPostalCode__c, false);
            this.setDefaultValue(FIELD_SHIPPINGCITY, this.accountData.dmpl__ShippingCity__c, false);
            this.setDefaultValue(FIELD_SHIPPINGCITYID, this.accountData.dmpl__ShippingCityPlaceId__c, false);
            this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, this.accountData.dmpl__ShippingCountry__c, false);
            this.setDefaultValue(FIELD_SHIPPINGREGION, this.accountData.dmpl__ShippingRegion__c, false);
            this.setDefaultValue(FIELD_SHIPPINGSTATE, this.accountData.dmpl__ShippingState__c, false);
            this.setDefaultValue(FIELD_SHIPPINGADDRESSID, this.accountData.dmpl__ShippingAddressId__c, false);
            this.setDefaultValue(FIELD_SHIPPINGSTREET, this.accountData.dmpl__ShippingStreet__c, false);
        }else{
            let address = addresses?.find(v=> (v.dmpl__AddressType__c == 'Shipping Address' 
                || v.dmpl__AddressType__c == 'Both') && v.dmpl__IsDefault__c);
            if(!address){
                return;
            }
            this.shippingAddressId = address.Id;
            this.setDefaultValue(FIELD_SHIPPINGADDRESSID, address.Id, true);
            this.setDefaultValue(FIELD_SHIPPINGSTREET, address.dmpl__Street__c, true);
            this.setDefaultValue(FIELD_SHIPPINGPOSTALCODE, address.dmpl__PostalCode__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCITY, address.dmpl__City__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCITYID, address.dmpl__CityPlaceId__c, true);
            this.setDefaultValue(FIELD_SHIPPINGCOUNTRY, address.dmpl__Country__c, true);
            this.setDefaultValue(FIELD_SHIPPINGREGION, address.dmpl__Region__c, true);
            this.setDefaultValue(FIELD_SHIPPINGSTATE, address.dmpl__State__c, true);
        }
    }

    async handleFirstNameChange(firstName) {
        let lastName = this.getFieldValue(FIELD_LASTNAME);
        this.setDefaultValue(
            FIELD_NAME, 
            lastName?firstName + ' ' + lastName : firstName, 
            true);
    }

    async handleLastNameChange(lastName) {
        let firstName = this.getFieldValue(FIELD_FIRSTNAME);
        this.setDefaultValue(
            FIELD_NAME, 
            firstName?firstName + ' ' + lastName : lastName, 
            true);
    }

    async copyFieldMapping(fieldName, fieldValue){
        if(!this.fieldMappings){
            return;
        }
        const mappings = [...new Set(this.fieldMappings.filter(v=> 
            v.dmpl__DestinationLookupFieldName__r?.QualifiedApiName == fieldName).map(m => 
                m.dmpl__SourceObjectNameId__r?.QualifiedApiName))]; 
        mappings.forEach(v=> this.copyFieldMappingData(v, fieldValue));
    }

    async copyFieldMappingData(sourceApiName, objectId){
        if(!this.fieldMappings){
            return;
        }
        let mappings = this.fieldMappings.filter(v => 
            v.dmpl__SourceObjectNameId__r?.QualifiedApiName == sourceApiName).sort((a, b) => 
                a.dmpl__SequenceNumber__c && b.a.dmpl__SequenceNumber__c ? a.dmpl__SequenceNumber__c - b.dmpl__SequenceNumber__c : 0);
        if(mappings && mappings.length>0){
            if(objectId){
                const result = await getFieldMappingsData({ 
                    sourceObjectApiName: sourceApiName,
                    destinationObjectApiName: this.objectApiName,
                    objectId: objectId});
                if (result && result.length>0) {
                    let source = result[0]; 
                    mappings.forEach(m=>{
                        if(m.dmpl__DestinationFieldName__r.QualifiedApiName
                            && m.dmpl__SourceFieldNameId__r.QualifiedApiName 
                            && source[m.dmpl__SourceFieldNameId__r.QualifiedApiName]){
                                if(!m.dmpl__CopyOnlyIfEmpty__c
                                    || (!this.getFieldValue(m.dmpl__DestinationFieldName__r?.QualifiedApiName))
                                    ){
                                        this.setDefaultValue(
                                            m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                            source[m.dmpl__SourceFieldNameId__r.QualifiedApiName], false);
                                    }
                        }
                    });
                }   
            } else {
                mappings.forEach(m=>{
                    if(m.dmpl__DestinationFieldName__r.QualifiedApiName
                        && m.dmpl__SourceFieldNameId__r.QualifiedApiName){                            
                            this.setDefaultValue(
                                m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                undefined, false);
                    }
                });
            }        
        }
    }
}