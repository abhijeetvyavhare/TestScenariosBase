import { LightningElement, track, wire, api } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { RefreshEvent } from 'lightning/refresh';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getPostalCodeDefaults from '@salesforce/apex/RecordFormController.getPostalCodeDefaults';
import getAllRelatedVisitRoute from '@salesforce/apex/VisitRouteSearchController.getAllRelatedVisitRoutes';
import getAccounts from '@salesforce/apex/VisitRouteSearchController.getAccounts';
import createFieldSalesInvoice from '@salesforce/apex/VisitRouteSearchController.createFieldSalesInvoice';
import createVisit from '@salesforce/apex/VisitRouteSearchController.createVisit';
import getFieldSalesType from '@salesforce/apex/VisitRouteSearchController.getFieldSalesType';
import { getObjectInfo, getPicklistValues } from "lightning/uiObjectInfoApi";
import POSTALCODE_OBJECT from "@salesforce/schema/PostalCode__c";
import CITY_FIELD from "@salesforce/schema/PostalCode__c.City__c";
import STATE_FIELD from "@salesforce/schema/PostalCode__c.State__c";

export default class VisitRouteSearchPanel extends LightningElement {

    @api title;
    @api accordianTitle;
    @api accountGroup_Fieldset = 'dmpl__AccountGroupFieldset';
    @api pincode_Fieldset = 'dmpl__ConfigureRoute_Pincode_Fieldset';
    @api routing_Fieldset = 'RoutingMethodFieldset';
    @track isLoading = false
    @track selectedAccountGroup = false;
    @track selectedGeography = false;
    @track accountGroupText = '';
    @track accountGroupId;
    @track postalCode;
    @track postalCity;
    @track accountGroup;
    @track postalState;
    @track routeValue;
    @track fromDate;
    @track toDate;
    @api showAccounts = false;
    @track columns = [];
    @track accountData = [];
    selectedAccountGroupId;
    defaultStringArrTwo = ['dmpl__City__c', 'dmpl__State__c'];

    @api recordId;
    @api objectApiName
    @track showAccount = true;
    accountRecordTypeId;
    @track cityOptions;
    @track stateOptions;
    @track routeIdList;

    @wire(getFieldSalesType,{recordId: '$recordId'})
    dataTableColumns({data,error}){
        if (data === 'Van Delivery' || data === 'Pre-Bill') {
            this.columns = [
                { label: 'Name', fieldName: 'Name' },
                { label: 'Invoice Number', fieldName: 'InvoiceNumber' },
                { label: 'Invoice Amount', fieldName: 'InvoiceAmount' },
                { label: 'Invoice Date', fieldName: 'InvoiceDate' },
                { label: 'Invoice Status', fieldName: 'InvoiceStatus' },
                { label: 'Pincode', fieldName: 'BillingPincode' },
                { label: 'City', fieldName: 'BillingCity' },
                { label: 'State', fieldName: 'BillingState' }
            ];
        } else {
            this.columns = [
                { label: 'Name', fieldName: 'Name' },
                { label: 'Pincode', fieldName: 'BillingPincode' },
                { label: 'City', fieldName: 'BillingCity' },
                { label: 'State', fieldName: 'BillingState' }
            ]; // Handle other cases or set default columns
        }
    
        if (error) {
            console.error('Error fetching data:', error);
        }
    }

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$accountGroup_Fieldset' })
    accountGroupFields;
    get getFieldDetails() {
        if (this.accountGroupFields || this.accountGroupFields.data) {
            return this.accountGroupFields;
        }
    }
  

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$pincode_Fieldset' })
    pinCodeFields;
    get getPinCodeFieldDetails() {
        if (!this.pinCodeFields || !this.pinCodeFields.data) return [];
        return this.pinCodeFields.data.map((val) => {
            const isZipCodeField = val.apiName === 'dmpl__PinCode__c';
            const isDefaultValueFieldFlag = val &&
                ((this.postalCode && this.postalCode.length >= 6) && this.defaultStringArrTwo?.includes(val.apiName))
            return {
                ...val,
                isDefaultValueField: isDefaultValueFieldFlag,
                defaultValue: this.defaultValueSetter(isDefaultValueFieldFlag, val.apiName),
                disableField: isDefaultValueFieldFlag,
                isZipCodeField: isZipCodeField,
            };
        });
    }


    defaultValueSetter(flag = false, apiName = '') {
        const {
            postalCity,
            postalState,

        } = this;

        const defaultValues = {
            'dmpl__City__c': postalCity,
            'dmpl__State__c': postalState,

        };

        return flag ? defaultValues[apiName] : '';
    }
    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$routing_Fieldset' })
    routingFields;
    get getroutingFieldDetails() {
        if (this.routingFields || this.routingFields.data) {
           return this.routingFields;
        }
    }

    @wire(getObjectInfo, { objectApiName: POSTALCODE_OBJECT })
    results({ error, data }) {
        if (data) {
        this.accountRecordTypeId = data.defaultRecordTypeId;
        this.error = undefined;
        } else if (error) {
        this.error = error;
        this.accountRecordTypeId = undefined;
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountRecordTypeId", fieldApiName: CITY_FIELD })
    picklistResults({ error, data }) {
        if (data) {
        this.cityOptions = data.values;
        this.error = undefined;
        } else if (error) {
        this.error = error;
        this.cityOptions = undefined;
        }
    }

    @wire(getPicklistValues, { recordTypeId: "$accountRecordTypeId", fieldApiName: STATE_FIELD })
    picklistResultsForState({ error, data }) {
        if (data) {
        this.stateOptions = data.values;
        this.error = undefined;
        } else if (error) {
        this.error = error;
        this.stateOptions = undefined;
        }
    }

    resetValues() { 
        this.postalCity = null;
        this.postalState = null;

    }
    @wire(getPostalCodeDefaults, { postalCode: '$postalCode' })
    getBranchFromPostalCode({ error, data }) {
        if (data) {
            this.postalCity = data.dmpl__City__c;
            this.postalState = data.dmpl__State__c;

        }
        else {
            if (this.postalCode && this.postalCode.length == 6) {
                this.resetValues();
            }
        }
        if (error) {
            this.resetValues();
        }

    }

    get hasAccountFieldset() {
        return this.getAccountFieldset && this.getAccountFieldset.length > 0;
    }

    handleaccountGroup(event) {
        this.accountGroup = event.detail.value[0];

    }
    handlepinCode(event) {
        const changedFieldValue = event.target.value;
        const changedFieldId = event.target.id;
        const value = event.detail.value;
        if (value) {
            if ('dmpl__PinCode__c'.includes(changedFieldId.replace(/-\d+$/, ''))) {
                this.postalCode = value
                if (value && value.length < 6) {
                    this.zipError = false;
                    this.branchError = '';
                }
            }
            if ('dmpl__City__c'.includes(changedFieldId.replace(/-\d+$/, ''))) {
                this.postalCity = value
            }
            if ('dmpl__State__c'.includes(changedFieldId.replace(/-\d+$/, ''))) {
                this.postalState = value
            }
            if ('dmpl__VisitRouteId__c'.includes(changedFieldId.replace(/-\d+$/, ''))) {
                this.routeValue = value[0]
            }
        }
    }

    handleAccountGroupChange(event) {
        this.selectedAccountGroup = event.target.checked;
    }

    handleGeographyChange(event) {
        this.selectedGeography = event.target.checked;
    }

    handleAccountGroupTextChange(event) {
        this.accountGroupText = event.target.value;
    }

    handleFromDateChange(event) {
        this.fromDate = event.target.value;
    }
    
    handleToDateChange(event) {
        this.toDate = event.target.value;
    }
    
    refreshPage() {
        this.refreshStdComponents();
        window.location.reload();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    objectApiName = '';
    selectedRows = [];
    selectedRoutes = [];
    @track filteredRoutes = [];
    @track visitRoute = [];
    @track makeVisible = false;

    connectedCallback() {
        this.filteredRoutes = [...this.visitRoute];
    }

    handleSearch(event) {
        const searchKey = event.target.value.toLowerCase();
        this.searchValue = searchKey;

        if (searchKey) {
            this.filteredRoutes = this.visitRoute.filter(route => 
                route.Name.toLowerCase().includes(searchKey)
            );
        } else {
            this.filteredRoutes = [...this.visitRoute];
        }
    }
    

    @wire(CurrentPageReference)
    wiredCurrentPageReferance(currentPageReference) {
        if (currentPageReference) {
            this.objectApiName = currentPageReference?.attributes?.objectApiName;
        }
    }

    @wire(getAllRelatedVisitRoute, {ObjectName : '$objectApiName', recordId: '$recordId'})
    wiredVisitRoutes({ error, data }) {
        if (data) {
            this.visitRoute = data.map(route => ({
                ...route,
                selected: false
            }));
            this.filteredRoutes = [...this.visitRoute];
        } else if (error) {
            console.error('Error fetching visit routes:', error);
        }
    }

    handleRouteSelection(event) {
        const value = event.target.value;
        const isChecked = event.target.checked;

        this.visitRoute = this.visitRoute.map(route => {
            if (route.Id === value) {
                if (isChecked && !this.selectedRoutes.includes(route.Id)) {
                    this.selectedRoutes.push(route.Id);
                } else if (!isChecked) {
                    this.selectedRoutes = this.selectedRoutes.filter(id => id !== route.Id);
                }
                return { ...route, selected: isChecked };            
            }
            return route;
        });
        this.filteredRoutes = [...this.visitRoute];
        this.selectedRoutes = this.filteredRoutes.filter(route =>route.selected).map(route=>route.Id);
        this.routeIdList = this.selectedRoutes;
    }

    async getAccount(){
        let filters = await this.getFilters();
        console.log(filters,'Filters');
        

        this.isLoading = true;
        this.makeVisible = true;
        
        await getAccounts({
            recordId : this.recordId,
            objectName : this.objectApiName,
            visitRouteIds: this.routeIdList,
            postalCode : this.postalCode, 
            city : this.postalCity, 
            state : this.postalState,
            accountGroup : this.accountGroup,
            fromDate : this.fromDate,
            toDate : this.toDate
            })
        .then(result => {
                console.log(JSON.stringify(this.selectedRoutes),'hgj');
                console.log(result.length,'hgjdjabd');
                this.accountData= result
                console.log(result);
        })
        .catch(error => {
            console.error('Error:', error);
        })
        .finally(() => {
            this.isLoading = false;
        });
    }

    handleSave() {
        this.getAccount();
        console.log(JSON.stringify(this.accountData) + 'sace button');
    }

    createVisits(accounts) {
        createVisit({accountIds : accounts,PlanId : this.recordId,routeIds :this.selectedRoutes});
    }

    createFieldSalesInvoice(accounts,InvoiceNumbers) {
        createFieldSalesInvoice({
            accountIds : accounts, 
            fieldSalesId : this.recordId, 
            routeIds :this.selectedRoutes,
            invoiceNumber:InvoiceNumbers,
        });
    }

    saveData(){

        let selectedRecords = this.template.querySelector('lightning-datatable').getSelectedRows();
        if(!selectedRecords){
            this.showError('No Record Selected');
        }
        let InvoiceNumbers=selectedRecords?.map(row=>row.InvoiceNumber)
        let accIds = [...new Set(this.selectedRows.map(row => row.Id))];

        console.log('select row 33',JSON.stringify(accIds));
        if(this.objectApiName == 'dmpl__VisitPlan__c'){
            this.createVisits(accIds);
        }
        else{
            this.createFieldSalesInvoice(accIds,InvoiceNumbers);
        }
        this.makeVisible = false;
        window.location.reload();
    }

    closeModal() {
        this.makeVisible = false;
    }
    
    handleRowSelection(event) {
        this.selectedRows = [...event.detail.selectedRows];
    }

    handleCityChange(event) {
        this.postalCity = event.detail.value;
    }

    handlePincodeChange(event) {
        this.postalCode = event.detail.value;
    }

    handleStateChange(event) {
        this.postalState = event.detail.value;
    }

    handleAccountGroupChange(event) {
        this.accountGroup = event.detail.value;
    }

    async getFilters() {
        let filters = [];

        let allFields = this.template.querySelectorAll('lightning-input-field');
        allFields.forEach((field) => {
            if (field.value) {
                filters.push(this.parentLookupField + '.' + field.fieldName + ' = \'' + field.value + '\'');
            }
        })
        let Pincode = this.template.querySelectorAll(".pincode")[0]?.value;
        let City = this.template.querySelectorAll(".city")[0]?.value;
        let state = this.template.querySelectorAll(".state")[0]?.value;
        let accountGroup = this.template.querySelectorAll(".accountGroup")[0]?.value;
        console
    
        if (accountGroup) {
            filters.push(`dmpl__AccountId__c.dmpl__AccountGroupId__c = '${accountGroup}'`);
        }
        if (Pincode) {
            filters.push(`dmpl__AccountId__r.BillingPostalCode__c = '${Pincode}'`);
        }
        if (City) {
            filters.push(`dmpl__AccountId__r.BillingCity__c = '${City}'`);
        }
        if (state) {
            filters.push(`dmpl__AccountId__r.BillingState__c = '${state}'`);
        }
        if (this.defaultWhereClause && this.defaultWhereClause !== '') {
            filters.push(this.defaultWhereClause);
        }
        
        return filters.join(' AND ');
    }
    showError(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: message,
                variant: 'error',
            }),
        );
    }
    
}