import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { reduceErrors } from 'c/utils';
import { RefreshEvent } from 'lightning/refresh';
import { publish, MessageContext } from 'lightning/messageService';
import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';
import getQualifiedSchemeSlabs from '@salesforce/apex/SchemeController.getQualifiedSchemeSlabs';
import getQualifiedBenefits from '@salesforce/apex/SchemeController.getQualifiedBenefits';
import applyScheme from '@salesforce/apex/SchemeController.applyScheme';
import resetScheme from '@salesforce/apex/SchemeController.resetScheme';
import noQualifiedSchemesFound from '@salesforce/label/c.SchemeApplication_NoQualifiedSchemesFound';
import applySchemeTitle from '@salesforce/label/c.SchemeApplication_applySchemeTitle';

const FIELD_PARTNERACCOUNTID = 'dmpl__PartnerAccountId__c';
const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_ACCOUNTID = 'dmpl__AccountId__c';
const FIELD_NAME = 'Name';
const DELAY = 500;

export default class SchemeApplicationPanel extends NavigationMixin(LightningElement) {
    schemeLineId;
    recordFieldNames;
    qualifiedSchemes;

    customLabel = {
        noQualifiedSchemesFound,
        applySchemeTitle
    }

    itemListColumns = [
        { label: 'Item', fieldName: 'itemName',  hideLabel: true, hideDefaultActions: true },
        { label: 'Description', fieldName: 'itemDescription',  hideLabel: true, hideDefaultActions: true },
        { label: 'Item Group', fieldName: 'itemGroup',  hideLabel: true, hideDefaultActions: true },
        { label: 'Disc. Qty', fieldName: 'quantityDiscounted', type: 'number', initialWidth: 90, hideDefaultActions: true},
        { label: 'Disc. %', fieldName: 'discountPercent', type: 'number', initialWidth: 90, hideDefaultActions: true},
        { label: 'Select?', fieldName: 'isSelected', type: 'toggleButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true, typeAttributes: { rowId: { fieldName: 'Id' } } },
        { label: 'Quantity', fieldName: 'quantity', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: true, cellAttributes: { class: 'slds-theme_shade' } }
    ]

    @track isLoaded = false;
    @track isLinesDataLoaded = false;
    @track benefitOptions = [];
    selectedBenefit;
    searchKey = '';
    controllingField = 'quantityDiscounted';
    isSaveDisabled = false;
    
    itemListData;
    draftValues;
    tableErrors;

    applySchemeResult;
    navigationUrl;

    @wire(getRecord, {
        recordId: '$recordId',
        fields: '$recordFieldNames'
    })
    getRecordDetails;

    @wire(MessageContext)
    messageContext;

    _recordId;
    @api set recordId(value) {
        this._recordId = value;
        this.handleInit();
    }

    get recordId() {
        return this._recordId;
    }

    _objectApiName;
    @api set objectApiName(value) {
        this._objectApiName = value;
        this.handleInit();
    }

    get objectApiName() {
        return this._objectApiName;
    }

    get getDocumentTitle() {
        if (this.getRecordDetails.data && this.getRecordDetails.data.fields[FIELD_NAME])
            return `${this.customLabel.applySchemeTitle} : ${this.getRecordDetails.data.fields[FIELD_NAME].value}`;
        return this.customLabel.applySchemeTitle;
    }

    get getSelectedBenefitTitle(){
        return this.selectedBenefit?.title;
    }

    get getSelectedBenefitSubTitle(){
        return this.selectedBenefit?.subTitle;
    }

    get benefitHasItemGroup(){
        return this.itemGroups && this.itemGroups.length>0;
    }

    get hasQualifiedSchemes() {
        return this.qualifiedSchemes && this.qualifiedSchemes.length > 0;
    }

    get isSchemeSelected(){
        return this.schemeLineId;
    }

    get isSaveVisible() {
        var wizard = Array.from(this.template.querySelectorAll('c-wizard'));
        if (wizard && wizard.length > 0) {
            return wizard[0].currentStep == 'step-2' && this.isSaveDisabled == false;
        }
        return false;
    }

    get noItemListData() {
        return (this.isLinesDataLoaded && this.itemListData && this.itemListData.length == 0);
    }

    connectedCallback() {
        this.handleInit();
    }

    moveWizard(direction) {
        var step = Array.from(this.template.querySelectorAll('c-wizard'));
        step.forEach(element => {
            element.moveStep(direction);
        });
    }

    initItemListData() {
        if (this.loadedBenefitId == this.benifitId
            && this.loadedItemGroups == this.itemGroups
            && this.loadedsearchKey == this.searchKey) {
            return;
        }
        this.isLinesDataLoaded = false;
        
        getQualifiedBenefits({
            benefitId: this.benifitId,
            searchKey: this.searchKey,
            itemGroupIds : this.itemGroups.map(c=> {
                    return c.dmpl__DiscountedItemGroupId__c
                })
        }).then(result => {
            let selectedData = this.itemListData && this.itemListData.slice().filter(v => v.isSelected);
            let newData = Array.from(result).map(v => {
                let selectedRow = selectedData && selectedData.find(s => s.Id == v.Id);
                let v1 = JSON.parse(JSON.stringify(v));
                let v2 = JSON.parse(JSON.stringify(this.itemGroups));
                let returnGroups = v2.filter(c=>c.dmpl__DiscountedItemGroupId__c == v.dmpl__ItemGroupId__c);
                v1.itemId = v.dmpl__ItemId__c;
                v1.itemGroup = v.dmpl__ItemGroupId__r?.Name;
                v1.itemName = v.dmpl__ItemId__r?.Name;
                v1.itemDescription = v.dmpl__ItemId__r?.dmpl__Description__c;
                v1.quantityDiscounted = returnGroups.length>0?returnGroups[0].dmpl__DiscountedItemQuantity__c : 0
                v1.discountPercent= returnGroups.length>0?returnGroups[0].dmpl__DiscountPercent__c : 0
                v1.quantity = selectedRow ? selectedRow.quantity : undefined;
                v1.isSelected = selectedRow ? selectedRow.isSelected : false;
                return v1;
            });
            if (selectedData) {
                newData = newData.concat(selectedData.filter(v => newData.find(v1 => v1.Id == v.Id) == undefined));
            }
            this.itemListData = newData;
            this.isLinesDataLoaded = true;
            this.loadedBenefitId = this.benifitId;
            this.loadedsearchKey = this.searchKey
            this.loadedItemGroupIds = this.itemGroups;
        })
            .catch(error => {
                this.isLinesDataLoaded = true;
                this.showError(error);
            });
    }

    handleInit() {
        let fields = this.objectApiName && this.recordId ? [this.objectApiName.concat('.', FIELD_PARTNERACCOUNTID),
        this.objectApiName.concat('.', FIELD_BRANCHID),
        this.objectApiName.concat('.', FIELD_ACCOUNTID),
        this.objectApiName.concat('.', FIELD_NAME)] : undefined;
        this.recordFieldNames = fields;
        this.loadedsearchKey = this.searchKey;

        if (!this.isLoaded && this.recordId && this.objectApiName) {
            getQualifiedSchemeSlabs(
                { 
                    objectApiName: this.objectApiName,
                    recordId: this.recordId 
                })
                .then(result => {
                    if(result){                        
                        this.qualifiedSchemes = result.map(v => {
                                return {
                                    value: v.Id,
                                    title: v.dmpl__Title__c,
                                    subTitle: `Scheme Name : ${v.dmpl__SchemeId__r?.Name}. Slab Name : ${v.Name}`,
                                    heading: v.dmpl__Heading__c,
                                    subHeading: v.dmpl__SubHeading__c,
                                    benefitOptions : this.splitBenefits(v)
                                }
                            });
                        }else{
                            this.qualifiedSchemes = [];
                        }
                    this.isLoaded = true;
                })
                .catch(error => {
                    this.isLoaded = true;
                    this.showError(error);
                });
        }
    }

    splitBenefits(schemeLine){
        if(!schemeLine){
            return [];
        }
        if(schemeLine.dmpl__RewardApplicability__c == 'All Rewards'){
            if(schemeLine.dmpl__SchemeBenefits__r.length>0){
                return [{
                    value: Array.from(schemeLine.dmpl__SchemeBenefits__r)[0].Id,
                    title: Array.from(schemeLine.dmpl__SchemeBenefits__r).map( v=>
                        {
                            return `${v.Name}${v.dmpl__Title__c?' : '+v.dmpl__Title__c:''}`
                        }).join(" and "),
                    subTitle: Array.from(schemeLine.dmpl__SchemeBenefits__r).map( v=>
                        {
                            return this.getBenefitVerbatim(v)
                        }).join(" and "),
                    itemGroups : Array.from(schemeLine.dmpl__SchemeBenefits__r).filter(v=>
                        v.dmpl__RewardType__c == 'Discounted Item Group' && v.dmpl__DiscountedItemGroupId__c),
                }]
            }else{
                return [];
            }
        }else if(schemeLine.dmpl__RewardApplicability__c == 'Custom Logic'){
            if(!schemeLine.dmpl__RewardCustomLogic__c){
                return [];
            }
            return schemeLine.dmpl__RewardCustomLogic__c.split('OR').map(o => 
                {
                    return {
                        value : schemeLine.dmpl__RewardCustomLogic__c.split('OR').indexOf(o),
                        title: o.split('AND').map(a=>{
                                let v = this.getIndexedBenefit(a,schemeLine.dmpl__SchemeBenefits__r);
                                return v?`${v.Name}${v.dmpl__Title__c?' : '+v.dmpl__Title__c:''}` : 'missing';
                            }).join(" and "),
                        subTitle: o.split('AND').map(a=>{
                                let v = this.getIndexedBenefit(a,schemeLine.dmpl__SchemeBenefits__r);
                                return v?this.getBenefitVerbatim(v):'missing';
                            }).join(" and "),
                        itemGroups: o.split('AND').map(a=> {
                                return this.getIndexedBenefit(a,schemeLine.dmpl__SchemeBenefits__r)
                            }).filter(v=> v.dmpl__RewardType__c == 'Discounted Item Group' 
                                    && v.dmpl__DiscountedItemGroupId__c),
                        isCustomGroup:true
                    }
                });
        }else {
            return Array.from(schemeLine.dmpl__SchemeBenefits__r).map( v=>
                {
                    return {
                        value: v.Id,
                        title: `${v.Name} : ${v.dmpl__Title__c?v.dmpl__Title__c:''}`,
                        subTitle: this.getBenefitVerbatim(v),
                        itemGroups : v.dmpl__RewardType__c == 'Discounted Item Group' ? [v] : []
                    }
                }
            );
        }
    }

    getIndexedBenefit(position, benefits){
        var matches = position.match(/\{(.*?)\}/)
        if(matches){
            let index = matches[1];
            if(index>0 && index <= benefits.length){
                return benefits[index-1];
            }    
        }
    }

    getBenefitVerbatim(v){
        if(v.dmpl__RewardType__c == 'Line Level Discount Percent'){
            return `${v.dmpl__DiscountPercent__c}% discount on the document`;
        } else if(v.dmpl__RewardType__c == 'Line Level Discount Amount'){
            return `Total Discount Amount of ${v.dmpl__DiscountAmount__c} on the document`;
        } else if(v.dmpl__RewardType__c == 'Discounted Item'){
            return `${v.dmpl__DiscountedItemQuantity__c} Quantity of Item: "${v.dmpl__DiscountedItemId__r?.Name}" with discount of ${v.dmpl__DiscountPercent__c}%`;
        } else if(v.dmpl__RewardType__c == 'Discounted Item Group'){
            return `${v.dmpl__DiscountedItemQuantity__c} Quantity from Item Group: "${v.dmpl__DiscountedItemGroupId__r?.Name}" with discount of ${v.dmpl__DiscountPercent__c}%`;
        } else if(v.dmpl__RewardType__c == 'Reward Points'){
            return `${v.dmpl__RewardPoints__c} Reward Points`;
        }
    }

    handleSchemeLineChanged(event) {
        this.schemeLineId = event.detail.value;
        let selectedSchemeLine = this.qualifiedSchemes.find(v => v.value == this.schemeLineId);
        if (selectedSchemeLine) {
            this.benefitOptions = selectedSchemeLine.benefitOptions;
        }
    }

    handleBenefitChanged(event) {
        let value = event.detail.value;
        this.selectedBenefit = this.benefitOptions.find(v => v.value == value);
        if (this.selectedBenefit) {
            this.itemGroups = this.selectedBenefit?.itemGroups;
            if(this.selectedBenefit.isCustomGroup){
                this.benifitIndex = value;
            }else{
                this.benifitId = this.selectedBenefit.value;
            }
            this.moveWizard('next');
            this.initItemListData();    
        }
    }

    handleCellChange(event) {
        event.detail.draftValues.forEach((row) => {
            let sourceRow = this.itemListData.find(v => v.Id == row.Id);
            if (sourceRow) {
                if (row.quantity > sourceRow[this.controllingField]) {
                    row.quantity = sourceRow[this.controllingField]
                    sourceRow.quantity = sourceRow[this.controllingField];
                    this.showWarning('Quantity to release can not be in excess of pending quantity!');
                }
                else {
                    sourceRow.quantity = row.quantity;
                    sourceRow.isSelected = row.quantity > 0;
                }
            }
        });
        this.draftValues = [];
        event.detail.draftValues = [];
        this.itemListData = this.itemListData.slice();
    }

    handleSelectedRec(event) {
        let row = this.itemListData.find(v => v.Id == event?.detail?.value?.rowId);
        if (row && event?.detail?.value?.state == true) {
            row.isSelected = true;
            row.quantity = row[this.controllingField];
        } else {
            row.isSelected = false;
            row.quantity = undefined;
        }
        this.itemListData = this.itemListData.slice();
    }

    handleSearch(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
            this.initItemListData();
        }, DELAY);
    }

    handleClose() {
        this.dispatchEvent(new CustomEvent('closeclicked', { "detail": '{}' }));
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleReset(){
        try {
            this.isSaveDisabled = true;
            let result = await resetScheme(
                {
                    objectApiName : this.objectApiName,
                    recordId: this.recordId
                });
            if (result) {
                this.applySchemeResult = result;
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
                this.refreshStdComponents();
                this.showMessage('Scheme Reset Successfully!');
                this.handleClose();
            } else {
                this.showError(result.error);
            }
        }
        finally {
            this.isSaveDisabled = false;
        }
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    async handleSave() {
        try {
            this.isSaveDisabled = true;
            let result = undefined;
            if(this.itemGroups && this.itemGroups.length>0){
                var selectedRecords = this.itemListData?.filter(v => v.isSelected).map(v => {
                    return {
                        objectId: v.itemId,
                        quantity: v.quantity,
                        objectGroupId : v.dmpl__ItemGroupId__c
                    }
                });
                if (!selectedRecords || selectedRecords.length == 0) {
                    this.showWarning('Please select the Quantity to discount as per Benefits');
                    return;
                }
                this.itemGroups.forEach(v=>
                    console.debug(selectedRecords.filter(d=> d.objectGroupId == v.dmpl__DiscountedItemGroupId__c)
                        .reduce((partialSum, a) => partialSum + Number(a.quantity), 0)));

                if(this.itemGroups.filter(v=>
                    v.dmpl__DiscountedItemQuantity__c != selectedRecords.filter(d=>
                        d.objectGroupId == v.dmpl__DiscountedItemGroupId__c)
                        .reduce((partialSum, a) => partialSum + Number(a.quantity), 0)).length>0){
                                    this.showWarning('Please select the Quantity to discount as per Benefits');
                                    return;
                            }
            }
            result = await applyScheme(
                {
                    objectApiName : this.objectApiName,
                    recordId: this.recordId,
                    schemeLineId: this.schemeLineId,
                    benefitId: this.benifitId,
                    benefitIndex: this.benifitIndex,
                    selectedItemInfo: selectedRecords
                });

            if (result) {
                this.applySchemeResult = result;
                this.moveWizard('next');
                notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
                this.refreshStdComponents();
                // this.fireForceRefreshEvent();
                this.showMessage('Scheme Applied Successfully!');
            } else {
                this.showError(result.error);
            }
            this.isSaveDisabled = false;
        } catch (error) {
            this.isSaveDisabled = false;
            this.showError(error);
        }
    }

    fireForceRefreshEvent() {
        const filters = {
            recordApiName: this.objectApiName,
            recordApiId: this.recordId,
            state: '',
        };
        publish(this.messageContext, FORCEREFRESHMC, filters);
    }

    showError(error) {
        console.log('error ', error);
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: reduceErrors(error),
                variant: 'error',
                mode: 'sticky'
            })
        );
    }

    showWarning(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Not Allowed!',
                message: message,
                variant: 'warning'
            }),
        );
    }

    showMessage(message) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: message,
                variant: 'success',
            }),
        );
    }
}