import { LightningElement, api, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import { updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class AutoOrderPanel extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api title;

    @api showInventoryProjectionOptions;
    @api showInventoryAttributeOptions;
    @api showAIRecommendationOptions
    @api showFSNOptions;
    @api showABCOptions;
    @api showBudgetOptions;

    sections = ['showInventoryProjectionOptions','showAIRecommendationOptions','showInventoryAttributeOptions','showFSNOptions','showABCOptions','showBudgetOptions'];

    @track recordDetails = {}

    @track defaultFields = ['dmpl__IncludeInTransitShipments__c', 
        'dmpl__IncludeHighProbabilityQuote__c', 
        'dmpl__IncludeOpenSaleOrders__c', 
        'dmpl__IncludePendingPurchaseOrders__c', 
        'dmpl__IncludePurchaseRequisition__c', 
        'dmpl__ApplyInventoryAttributeSettings__c', 
        'dmpl__ExcludeACategoryItems__c', 
        'dmpl__ExcludeBCategoryItems__c', 
        'dmpl__ExcludeCCategoryItems__c', 
        'dmpl__ExcludeFastMovingItems__c', 
        'dmpl__ExcludeNonMovingItems__c', 
        'dmpl__ExcludeSlowMovingItems__c', 
        'dmpl__BudgetAmount__c',
        'dmpl__AIRecommendation__c'
    ];

    get minMaxOptions() {
        return [
            { label: 'Auto Min Max Settings', value: 'Auto Min Max Settings' },
            { label: 'Manual Min Max Settings', value: 'Manual Min Max Settings' },
            { label: 'Average Of Auto & Manual Settings', value: 'Average of Auto & Manual Settings' },
            { label: 'Prefer Auto', value: 'Prefer Auto' },
        ];
    }

    get aiOptions() {
        return [
            { label: 'Einstein 1', value: 'Einstein 1' },
            { label: 'Einstein 2', value: 'Einstein 2' },
            { label: 'Einstein 3', value: 'Einstein 3' },
            { label: 'Einstein 4', value: 'Einstein 4' }
        ];
    }

    get getDefaultFields() {
        let result = [];
        this.defaultFields.forEach(field => {
            result.push(this.objectApiName + '.' + field);
        })
        return result;
    }

    get getAIRecommendationIndex(){
        return this.getIndex('showAIRecommendationOptions');
    }

    get getInventoryAttributesIndex(){
        return this.getIndex('showInventoryAttributeOptions');
    }

    get getShowFSNIndex(){
        return this.getIndex('showFSNOptions');
    }

    get getShowABCIndex(){
        return this.getIndex('showABCOptions');
    }

    get getBudgetIndex(){
        return this.getIndex('showBudgetOptions');
    }

    getIndex(option){
        let defaultIndex = this.sections.indexOf(option) + 1;
        let totalFalse = 0;
        let currentIndex = 1;
        this.sections.forEach(section =>{
            if(!this[section] && currentIndex < defaultIndex)
                totalFalse++;
            currentIndex++;
        })
        defaultIndex = defaultIndex - totalFalse;
        return defaultIndex;
    }

    get getInventoryAttributeIndex(){
        let currentIndex = 2;
        if(!this.showInventoryProjectionOptions)
            currentIndex
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$getDefaultFields' })
    handleRecord({ data, error }) {
        if (data) {
            
            this.recordDetails['includeInTransitShipments'] = data?.fields?.dmpl__IncludeInTransitShipments__c?.value;
            this.recordDetails['includeHighProbabilityQuote'] = data?.fields?.dmpl__IncludeHighProbabilityQuote__c?.value;
            this.recordDetails['includeOpenSaleOrders'] = data?.fields?.dmpl__IncludeOpenSaleOrders__c?.value;
            this.recordDetails['includePendingPurchaseOrders'] = data?.fields?.dmpl__IncludePendingPurchaseOrders__c?.value;
            this.recordDetails['includePurchaseRequisition'] = data?.fields?.dmpl__IncludePurchaseRequisition__c?.value;

            this.recordDetails['applyInventoryAttributeSettings'] = data?.fields?.dmpl__ApplyInventoryAttributeSettings__c?.value;
            this.recordDetails['AIRecommendations'] = data?.fields?.dmpl__AIRecommendation__c?.value;

            this.recordDetails['excludeACategoryItems'] = data?.fields?.dmpl__ExcludeACategoryItems__c?.value;
            this.recordDetails['excludeBCategoryItems'] = data?.fields?.dmpl__ExcludeBCategoryItems__c?.value;
            this.recordDetails['excludeCCategoryItems'] = data?.fields?.dmpl__ExcludeCCategoryItems__c?.value;

            this.recordDetails['exclueFastMovingItems'] = data?.fields?.dmpl__ExcludeFastMovingItems__c?.value;
            this.recordDetails['excludeNonMovingItems'] = data?.fields?.dmpl__ExcludeNonMovingItems__c?.value;
            this.recordDetails['excludeSlowMovingItems'] = data?.fields?.dmpl__ExcludeSlowMovingItems__c?.value;

            this.recordDetails['budgetAmount'] = data?.fields?.dmpl__BudgetAmount__c?.value;
        }
        else if (error) {
            console.log(' error ' + JSON.stringify(error));
        }
    }

    handleShowDetailsClick() {
        this.viewDetails = !this.viewDetails;
    }

    handleToggle(event) {
        let fields = {}
        fields['Id'] = this.recordId;
        fields[event.currentTarget.dataset.fieldname] = event.target.checked;
        const recordInput = { fields };
        this.update(recordInput);
    }

    handleValueChange(event){
        let fields = {}
        fields['Id'] = this.recordId;
        fields[event.currentTarget.dataset.fieldname] = event.target.value;
        const recordInput = { fields };
        this.update(recordInput);
    }

    async update(recordDetails)
    {
        updateRecord(recordDetails)
        .then((result) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Record has been updated.',
                    variant: 'success'
                })
            );
        }).catch((error) => {
            console.log('Update Error ', JSON.stringify( error));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Something went wrong',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        })
    }

}