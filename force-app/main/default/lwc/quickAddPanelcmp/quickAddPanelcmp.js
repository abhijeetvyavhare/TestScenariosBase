import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getRecordNotifyChange } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { publish, MessageContext } from 'lightning/messageService';
import { reduceErrors } from 'c/utils';
import { NavigationMixin } from 'lightning/navigation';
import { getBarcodeScanner } from 'lightning/mobileCapabilities';
import FORM_FACTOR from '@salesforce/client/formFactor'
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import getItemStock from '@salesforce/apex/QuickAddPanelController.getItemStock';
import getItemSKUStock from '@salesforce/apex/QuickAddPanelController.getItemSKUStock';
import getItemLotTypeStock from '@salesforce/apex/QuickAddPanelController.getItemLotTypeStock';
import getItemLotTypesStock from '@salesforce/apex/QuickAddPanelController.getItemLotTypesStock';
import getItemSKUBranchStock from '@salesforce/apex/QuickAddPanelController.getItemSKUBranchStock';
import getItemAlternateStock from '@salesforce/apex/QuickAddPanelController.getItemAlternateStock';
import getTaxGroup from "@salesforce/apex/QuickAddPanelController.getTaxGroup";
import getItemPrice from "@salesforce/apex/QuickAddPanelController.getItemPrice";
import getItem from "@salesforce/apex/ItemController.getItem";
import getAllFieldMappings from '@salesforce/apex/RecordFormController.getAllFieldMappings';
import getFieldMappingsData from '@salesforce/apex/RecordFormController.getFieldMappingsData';
import getAlternateItemTypes from '@salesforce/apex/QuickAddPanelController.getAlternateItemTypes';

import performSearch from '@salesforce/apex/SearchController.search';
import listView from '@salesforce/apex/SearchController.listView';
import getRecentlyViewed from '@salesforce/apex/SearchController.getRecentlyViewed';

import FORCEREFRESHMC from '@salesforce/messageChannel/ForceReset__c';

import skuLabel from '@salesforce/label/c.QuickAddPanelPanel_SKULabel';
import inHandLabel from '@salesforce/label/c.QuickAddPanelPanel_InHandLabel';
import availableLabel from '@salesforce/label/c.QuickAddPanelPanel_AvailableLabel';
import otherBranchesLabel from '@salesforce/label/c.QuickAddPanelPanel_OtherBranchesLabel';
import typeLabel from '@salesforce/label/c.QuickAddPanelPanel_TypeLabel';
import originalLabel from '@salesforce/label/c.QuickAddPanelPanel_OriginalType';
import alternateItemLabel from '@salesforce/label/c.QuickAddPanelPanel_AlternateItemLabel';
import projectedLabel from '@salesforce/label/c.QuickAddPanelPanel_ProjectedLabel';

const ITEM_FIELD = 'dmpl__ItemId__c';
const SKU_FIELD = 'dmpl__SKUId__c';
const BRANCH_FIELD = 'dmpl__BranchId__c';
const PARTNER_FIELD = 'dmpl__PartnerAccountId__c';
const UNITPRICE_FIELD = 'dmpl__UnitPrice__c';
const UNITCOST_FIELD = 'dmpl__UnitCost__c';
const TAXGROUPFIELD = 'dmpl__TaxGroupId__c';
const DOCUMENTDATE_FIELD = 'dmpl__DocumentDate__c';
const PRICINGASONDATE_FIELD = 'dmpl__PriceAsOnDate__c';
const PRICELIST_FIELD = 'dmpl__PriceListId__c';
const QUANTITY_FIELD = 'dmpl__Quantity__c';
const TAXSUPPLYTYPE = 'dmpl__TaxSupplyType__c';
const ITEMALIAS_FIELD = 'dmpl__ItemAliasId__c';
const ITEMLOTTYPE_FIELD = 'dmpl__ItemLotTypeId__c';

const DELAY = 50;

export default class QuickAddPanelcmp extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @api title;
    @api relationName;
    @api childFieldsetName;
    @api childRecordTypeId;
    @api displayGridColumns;
    @api showScanOption;
    @api showImportOption;
    @api scannedFieldName;
    @api importFieldName;
    @api importActionName;
    @api barCodeType;
    @api disabledFields;
    @api itemInfo
    @api itemStock
    @api itemAlternateStock
    @api showStock;
    @api showSKUStock;
    @api showItemLotTypeStock;
    @api showAllItemLotTypeStock;
    @api showOtherBranchesStock;
    @api fetchPrices;
    @api fetchTaxes;
    @api showType;
    @api showAlternateItems;
    @api showMRP;

    @track alternateItemTypes = {};

    @api showCustomItemLookup;
    @api customItemLookupFilter;
    @api customItemLookupFieldsetName;

    @track newObjectData;
    @track parenObjectFields;
    @track hasSKU;
    @track hasAlternates;
    @track itemAliasId;
    @track itemLotTypeId;
    @track header = 'Alternate Items';
    @track restrictAlternateItemsDialog = false;
    @track alternateItemColums = [
        { label: 'Item Name', fieldName: 'dmpl__AlternateItemName__c' },
        { label: 'Type', fieldName: 'dmpl__AlternateItemType__c' },
        { label: 'Available', fieldName: 'QuantityAvailable' },
        { label: 'In Hand', fieldName: 'QuantityInHand' }
    ];
    ids = []

    @track itemAliasFields = [
        'dmpl__ItemAlias__c.dmpl__ItemId__c',
        'dmpl__ItemAlias__c.dmpl__SKUId__c',
        'dmpl__ItemAlias__c.dmpl__ItemLotTypeId__c',

    ]

    @track itemLotTypeFields = [
        'dmpl__ItemLotType__c.dmpl__ItemId__c'
    ]

    customLabel = {
        skuLabel,
        inHandLabel,
        availableLabel,
        otherBranchesLabel,
        typeLabel,
        originalLabel,
        alternateItemLabel,
        projectedLabel
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$parenObjectFields' })
    objectData;

    @wire(getRecord, { recordId: '$itemAliasId', fields: '$itemAliasFields' })
    handleItemAlias({ error, data }) {
        if (data) {
            this.setFieldValue(ITEM_FIELD, data.fields?.dmpl__ItemId__c?.value);
            this.setFieldValue(SKU_FIELD, data.fields?.dmpl__SKUId__c?.value);
            this.setFieldValue(ITEMLOTTYPE_FIELD, data.fields?.dmpl__ItemLotTypeId__c?.value);
            this.handleItemFieldChange({ detail: { value: [data.fields?.dmpl__ItemId__c?.value] } });
            this.handleItemSKUFieldChange({ detail: { value: [data.fields?.dmpl__SKUId__c?.value] } });
            this.handleItemLotTypeFieldChange({ detail: { value: [data.fields?.dmpl__ItemLotTypeId__c?.value] } });
        }
        if (error) {
            console.log('Item Alias Error', error);
        }
    }

    @wire(getRecord, { recordId: '$itemLotTypeId', fields: '$itemLotTypeFields' })
    handleItemLotType({ error, data }) {
        if (data) {
            this.setFieldValue(ITEM_FIELD, data.fields?.dmpl__ItemId__c?.value);
            this.handleItemFieldChange({ detail: { value: [data.fields?.dmpl__ItemId__c?.value] } });
        }
        if (error) {
            console.log('Item Lot Type Error', error);
        }
    }

    @wire(getObjectInfo, { objectApiName: '$objectApiName' })
    objectInfo;

    @wire(getFieldsByFieldSetName, { objectApiName: '$getChildObjectApiName', fieldSetName: '$getChildFieldsetName' })
    fieldsetFields;

    @wire(getFieldsByFieldSetName, { objectApiName: '$getChildObjectApiName', fieldSetName: '$scannedFieldName' })
    scanFieldsetFields;

    @wire(getItem, { itemId: '$getItemId' })
    itemInfo;

    @wire(getItemStock, { itemId: '$getItemId', partnerId: '$getPartnerId', branchId: '$getBranchId' })
    itemStock;

    @wire(getItemSKUStock, { itemId: '$getItemId', partnerId: '$getPartnerId', branchId: '$getBranchId' })
    itemSKUStock;

    @wire(getItemLotTypeStock, { itemId: '$getItemId', itemLotTypeId: '$getItemLotTypeId', branchId: '$getBranchId' })
    itemLotTypeStock;

    @wire(getItemLotTypesStock, { itemId: '$getItemId', branchId: '$getBranchId' })
    itemLotTypesStock;

    @wire(getItemSKUBranchStock, { itemId: '$getItemId', SKUId: '$getSKUId', partnerId: '$getPartnerId' })
    itemSKUBranchStock;

    @wire(getItemAlternateStock, { itemId: '$getItemId', partnerId: '$getPartnerId', branchId: '$getBranchId' })
    itemAlternateStock;

    @wire(MessageContext)
    messageContext;
    
    @wire(getAllFieldMappings, { destinationObjectApiName: '$getChildObjectApiName' })
    wiredFieldMapping(d) {
        if (d.data && d.data.length > 0) {
            this.fieldMappings = d.data;
        }
    };

    isPanelVisible = false;
    isScanPanelVisible = false;
    error;

    get isLoaded() {
        return (this.fieldsetFields.data || this.fieldsetFields.error || this.relationInfo || this.scanFieldsetFields.data || this.scanFieldsetFields.error)
            && (this.objectInfo.data || this.objectInfo.error);
    }

    get getFieldsetFields() {
        if (this.fieldsetFields && this.fieldsetFields.data) {
            return this.extendDisabledValues(this.fieldsetFields.data);
        }
    }

    get getScanFieldsetFields() {
        if (this.scanFieldsetFields && this.scanFieldsetFields.data) {
            return this.scanFieldsetFields.data;
        }
    }

    get isSubmitDisabled() {
        return (!this.relationInfo) && (!this.fieldsetFields);
    }

    get isScanButtinAvailable() {
        return this.showScanOption
            && this.scanFieldsetFields;
    }

    get isCameraAvailable() {
        return this.myScanner && this.myScanner.isAvailable();
    }

    get getChildObjectApiName() {
        return this.relationInfo ? this.relationInfo.childObjectApiName : undefined;
    }

    get getParentFieldName() {
        return this.relationInfo ? this.relationInfo.fieldName : undefined;
    }

    get getChildFieldsetName() {
        return this.childFieldsetName;
    }

    get relationInfo() {
        if (this.objectInfo && this.objectInfo.data) {
            return this.objectInfo.data.childRelationships.find(rls => rls.relationshipName == this.relationName);
        }
    }

    get fieldsetInfo() {
        if (this.objectInfo && this.objectInfo.data) {
            return this.objectInfo.data.childRelationships.find(rls => rls.relationshipName == this.relationName);
        }
    }

    get getItemId() {
        if (this.newObjectData)
            return this.newObjectData.ItemId__c;
    }

    get getSKUId() {
        if (this.newObjectData)
            return this.newObjectData.SKUId__c;
    }

    get getItemLotTypeId() {
        if (this.newObjectData)
            return this.newObjectData.ItemLotTypeId__c;
    }

    get getHostError(){
        if(this.objectData && this.objectData.error){
            return reduceErrors(this.objectData.error);
        }
    }

    get getBranchId() {
        if (this.objectData && this.objectData.data && this.objectData.data.fields[BRANCH_FIELD])
            return this.objectData.data.fields[BRANCH_FIELD].value;
    }

    get getPartnerId() {
        if (this.objectData && this.objectData.data && this.objectData.data.fields[PARTNER_FIELD])
            return this.objectData.data.fields[PARTNER_FIELD].value;
    }

    get getPriceListId() {
        let priceListId = this.getFieldValue(PRICELIST_FIELD);
        if(priceListId){
            return priceListId;
        }else if (this.objectData && this.objectData.data && this.objectData.data.fields[PRICELIST_FIELD])
            return this.objectData.data.fields[PRICELIST_FIELD].value;
    }

    get getPricingDate() {
        if (this.objectData && this.objectData.data){
            if(this.objectData.data.fields[PRICINGASONDATE_FIELD] && this.objectData.data.fields[PRICINGASONDATE_FIELD]?.value){
                return this.objectData.data.fields[PRICINGASONDATE_FIELD].value;  
            }else if(this.objectData.data.fields[DOCUMENTDATE_FIELD]){
                return this.objectData.data.fields[DOCUMENTDATE_FIELD].value;  
            } else {
                return null;  
            }
        } 
        return null;
    }

    get getTaxSupplyType() {
        if (this.objectData && this.objectData.data && this.objectData.data.fields[TAXSUPPLYTYPE])
            return this.objectData.data.fields[TAXSUPPLYTYPE].value;
    }

    get getMyBranchStock() {
        if (this.getItemId && this.getPartnerId && this.getBranchId) {
            if (this.showStock && this.showSKUStock) {
                if (this.getSKUId) {
                    if (this.itemSKUBranchStock.data)
                        return this.itemSKUBranchStock.data;
                }
                else if (this.itemSKUStock && this.itemSKUStock.data)
                    return this.itemSKUStock.data.filter(is => is.BranchId == this.getBranchId);
            }
            else if (this.showStock && this.showItemLotTypeStock && this.getItemLotTypeId) {
                if (this.getItemLotTypeId) {
                    if (this.itemLotTypeStock.data)
                        return this.itemLotTypeStock.data;
                }
            }
            else if (this.showStock && this.showAllItemLotTypeStock) {
               if (this.itemLotTypesStock && this.itemLotTypesStock.data)
                    return this.itemLotTypesStock.data;
            }
            else if (this.showStock) {
                if (this.itemStock && this.itemStock.data)
                    return this.itemStock.data.filter(is => is.BranchId == this.getBranchId);
            }
        }
    }

    get getOtherBranchStock() {
        if (this.getItemId && this.getPartnerId && this.getBranchId) {
            if (this.showStock && this.showSKUStock) {
                if (this.itemSKUStock && this.itemSKUStock.data && (!this.getSKUId))
                    return this.itemSKUStock.data.filter(is => is.BranchId != this.getBranchId);
            }
            else if (this.showStock) {
                if (this.itemStock && this.itemStock.data)
                    return this.itemStock.data.filter(is => is.BranchId != this.getBranchId);
            }
        }
    }

    get getAlternateItems() {
        if (this.getItemId && this.getPartnerId && this.getBranchId) {
            if (this.showStock || this.showSKUStock) {
                if (this.itemAlternateStock && this.itemAlternateStock.data) {
                    this.showAlternateItemsDialog(this.itemInfo.data?.dmpl__ItemsAlternates__r);
                    return this.itemAlternateStock.data.filter(is => is.BranchId == this.getBranchId);
                }
            }
        }
    }

    get getOtherBranchAlternateItems() {
        if (this.getItemId && this.getPartnerId && this.getBranchId) {
            if (this.showStock || this.showSKUStock) {
                if (this.itemAlternateStock && this.itemAlternateStock.data)
                    return this.itemAlternateStock.data.filter(is => is.BranchId == undefined);
            }
        }
    }

    get getFooterDataAvailable() {
        return (this.getMyBranchStock && this.getMyBranchStock.length > 0)
            || (this.getOtherBranchStock && this.getOtherBranchStock.length > 0);
    }

    get getIsPanelCollapsed() {
        return !this.isPanelVisible && !this.isScanPanelVisible;
    }

    get getStockDataAvailable() {
        return (this.showStock || this.showSKUStock) && (this.getMyBranchStock || this.getOtherBranchStock);
    }

    get getDisplayGridColumns() {
        if (FORM_FACTOR == 'Small') {
            return 12;
        } else if (FORM_FACTOR == 'Medium') {
            return 6;
        } else {
            return this.displayGridColumns > 0 ? this.displayGridColumns : 2;
        }
    }

    get getIsDesktop() {
        return FORM_FACTOR == 'Large';
    }

    get getFieldToScanFor() {
        if (this.getScanFieldsetFields && this.getScanFieldsetFields.length > 0) {
            return this.getScanFieldsetFields[this.getScanFieldsetFields.length - 1];
        }
    }

    extendDisabledValues(data) {
        if(this.showCustomItemLookup){
            data = data.filter(v=> v.apiName != 'dmpl__ItemId__c');
        }
        if (!this.disabledFields) {
            return data;
        }
        data = JSON.parse(JSON.stringify(data));
        return data.map(v => {
            v['disabled'] = this.disabledFields.indexOf(v['apiName']) >= 0;
            return v;
        });
    }

    connectedCallback() {
        if (this.objectApiName == undefined) {
            this.objectApiName = '';
        }
        this.newObjectData = {};
        let fields = [];
        fields.push(this.objectApiName.concat('.', BRANCH_FIELD));
        fields.push(this.objectApiName.concat('.', PARTNER_FIELD));
        if(this.fetchPrices || this.fetchTaxes){
            fields.push(this.objectApiName.concat('.', DOCUMENTDATE_FIELD));
        }
        if(this.fetchTaxes){
            fields.push(this.objectApiName.concat('.', TAXSUPPLYTYPE));
        }
        if(this.fetchPrices){
            fields.push(this.objectApiName.concat('.', PRICELIST_FIELD));
            fields.push(this.objectApiName.concat('.', PRICINGASONDATE_FIELD));
        }
        if(this.showCustomItemLookup){
            fields = fields.concat(this.getDynamicFields(this.customItemLookupFilter));
        }
        this.parenObjectFields = fields;
        this.myScanner = getBarcodeScanner();
    }

    async handleSuccess(event) {
        var recordId = event.detail ? event.detail.id : undefined;
        var messsage = recordId ? `Document \'${recordId}\' created successfully.` : 'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        this.handleReset(false);
        getRecordNotifyChange(new Array({ "recordId": recordId }));
        getRecordNotifyChange(new Array({ "recordId": this.recordId }));
        eval("$A.get('e.force:refreshView').fire();");
        refreshApex(this.itemStock);
        refreshApex(this.itemSKUStock);
        refreshApex(this.itemSKUBranchStock);
        refreshApex(this.itemLotTypeStock);
        refreshApex(this.itemLotTypesStock);
        this.fireForceRefreshEvent();
    }

    handleLoad() {
        this.handleReset(true);
    }

    handleError(event) {
        // this.dispatchEvent(
        //     new ShowToastEvent({
        //         title: 'Error',
        //         message: reduceErrors(error),
        //         variant: 'error'
        //     }),
        // );
        this.restrictAlternateItemsDialog = false;
    }

    handleReset(skipReset) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        var fsField = undefined;
        if (this.isScanPanelVisible) {
            fsField = this.getFieldToScanFor;
        } else {
            fsField = this.getFieldsetFields && this.getFieldsetFields.length > 0 ? this.getFieldsetFields[0] : undefined;
        }
        
        const searchField  = this.getSearchField('dmpl__ItemId__c');
        if(searchField){
            searchField.clearSelection();
        }

        if (inputFields) {
            inputFields.forEach(field => {
                if ((!skipReset) && field.fieldName != this.getParentFieldName) {
                    field.reset();
                }
                if (fsField && field.fieldName == fsField.apiName) {
                    setTimeout(() => {
                        if(searchField){
                            searchField.focus();
                        }else{
                            field.focus();
                        }
                    });
                }
            });
        }

        setTimeout(() => {
            this.newObjectData = {};
            this.restrictAlternateItemsDialog = false;
            this.copyFieldMapping(this.getParentFieldName, this.recordId);
        }, 500);
    }

    handleItemFieldChange(event) {
        this.newObjectData.ItemId__c = event.detail.value[0];
        this.newObjectData = this.newObjectData;
        this.resetItemDependentFields();
        this.defaultItemSettings();
        this.defaultItemValuesImperatively();
    }

    handleItemSKUFieldChange(event) {
        this.newObjectData.SKUId__c = event.detail.value[0];
        this.newObjectData = this.newObjectData;
        this.resetSKUDependentFields();
        this.defaultItemValuesImperatively();
    }

    handleItemAliasFieldChange(event) {
        this.itemAliasId = event.detail.value[0];
    }

    handleItemLotTypeFieldChange(event) {
        this.itemLotTypeId = event.detail.value[0];
        this.newObjectData.ItemLotTypeId__c = event.detail.value[0];
        this.newObjectData = this.newObjectData;
    }

    handlePriceListFieldChange(event) {
        this.defaultItemValuesImperatively();
    }
    
    handleFieldChange(event) {
        if ((!event.target) || (!event.target.id))
            return;
        const target = event.target.id.slice(0, event.target.id.lastIndexOf('-'));
        switch (target) {
            case ITEM_FIELD:
                this.handleItemFieldChange(event)
                break;
            case SKU_FIELD:
                this.handleItemSKUFieldChange(event)
                break;
            case ITEMALIAS_FIELD:
                this.handleItemAliasFieldChange(event)
                break;
            case ITEMLOTTYPE_FIELD:
                this.handleItemLotTypeFieldChange(event)
                break;
            case PRICELIST_FIELD:
                this.handlePriceListFieldChange(event)
                break;
        }

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
        setTimeout(() => {
            this.copyFieldMapping(target, value);
        }, DELAY);
    }

    handlePanelVisibility(event) {
        event.preventDefault();
        event.stopPropagation();
        this.isPanelVisible = !this.isPanelVisible;
        if (this.isPanelVisible) {
            this.isScanPanelVisible = false;
        }
    }

    handleScanPanelVisibility(event) {
        event.preventDefault();
        event.stopPropagation();
        this.isScanPanelVisible = !this.isScanPanelVisible;
        if (this.isScanPanelVisible) {
            this.isPanelVisible = false;
        }
    }

    handleImportClick(event) {
        let url = '/lightning/action/quick/'
                    + this.objectApiName
                    +'.'+ this.importActionName +'?objectApiName&context=RECORD_DETAIL&recordId='
                    + this.recordId 
                    +'&defaultFieldValues=relationName%3D'
                    + (this.relationName ? this.relationName : '')
                    + '%26fsName%3D'
                    + (this.importFieldName ? this.importFieldName : '') 
                    + '&backgroundContext=%2Flightning%2Fr%2F'
                    + this.objectApiName 
                    +'%2F'+ this.recordId+'%2Fview'
        this[NavigationMixin.Navigate]({
            type : 'standard__webPage',
            attributes: {
                url
            },
        });
    }

    resetItemDependentFields() {
        const inputFields = this.template.querySelectorAll("lightning-input-field");
        if (inputFields) {
            inputFields.forEach((field) => {
                if (field.fieldName == SKU_FIELD
                    || field.fieldName == UNITPRICE_FIELD
                    || field.fieldName == UNITCOST_FIELD
                    || field.fieldName == TAXGROUPFIELD
                    || field.fieldName == ITEMALIAS_FIELD
                    || field.fieldName == QUANTITY_FIELD) {
                    //field.reset();
                }
            });
        }
    }

    resetSKUDependentFields() {
        const inputFields = this.template.querySelectorAll("lightning-input-field");
        if (inputFields) {
            inputFields.forEach((field) => {
                if (field.fieldName == UNITPRICE_FIELD
                    || field.fieldName == UNITCOST_FIELD
                    || field.fieldName == TAXGROUPFIELD
                    || field.fieldName == QUANTITY_FIELD) {
                    //field.reset();
                }
            });
        }
    }

    defaultItemSettings() {
        getItem({
            itemId: this.getItemId
        })
            .then((result) => {
                this.hasSKU = result?.dmpl__SKUs__r?.length > 0;
                this.hasAlternates = result?.dmpl__ItemsAlternates__r?.length > 0;
                this.setFieldValue(
                    SKU_FIELD,
                    result?.dmpl__SKUs__r?.slice().find(v => v.dmpl__IsDefault__c)?.Id
                )
            })
            .catch((e) => {

            })
    }

    defaultItemAliasSettings() {
        getItem({
            itemId: this.getItemId
        })
            .then((result) => {
                this.hasSKU = result.dmpl__SKUs__r?.length > 0;
                this.hasAlternates = result.dmpl__ItemsAlternates__r?.length > 0;
                this.setFieldValue(
                    SKU_FIELD,
                    result?.dmpl__SKUs__r?.slice().find(v => v.dmpl__IsDefault__c)?.Id
                )
            })
            .catch((e) => {

            })
    }

    defaultItemValuesImperatively() {
        getItemPrice({
            itemId: this.getItemId,
            SKUId: this.getSKUId,
            priceListId: this.getPriceListId,
            pricingDate: this.getPricingDate
        })
            .then((result) => {
                this.setFieldValue(UNITPRICE_FIELD, result);
                this.setFieldValue(UNITCOST_FIELD, result);
            })
            .catch((e) => {
                this.error = e;
            })

        getItemPrice({
            itemId: this.getItemId,
            SKUId: this.getSKUId,
            priceListId: this.getPriceListId,
            pricingDate: this.getPricingDate
        })
            .then((result) => {
                this.setFieldValue(UNITPRICE_FIELD, result);
                this.setFieldValue(UNITCOST_FIELD, result);
            })
            .catch((e) => {
                this.error = e;
            })

        getTaxGroup({
            itemId: this.getItemId,
            SKUId: this.getSKUId,
            partnerId: this.getPartnerId,
            branchId: this.getBranchId,
            pricingDate: this.getPricingDate,
            taxSupplyType: this.getTaxSupplyType
        })
            .then((result) => {
                this.setFieldValue(TAXGROUPFIELD, result);
            })
            .catch((e) => {
                this.error = e;
            })
    }

    setFieldValue(fieldName, fieldValue) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );

        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == fieldName) {
                    field.value = fieldValue;
                }
            })
        }

        if(fieldName == 'dmpl__ItemId__c'){
            const searchField  = this.getSearchField('dmpl__ItemId__c');
            if(searchField){
                if(fieldValue){
                    searchField.selection = [{id: fieldValue}];
                }else if(searchField.getSelection?.length > 0){
                    searchField.clearSelection();
                }
            }
        }
    }

    getFieldValue(name) {
        const inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        return inputFields && inputFields.find(f => f.fieldName == name)?.value;
    }

    getHostFieldValue(name) {
        if(this.objectData && this.objectData.data && this.objectData.data.fields[name]){
            return this.objectData.data.fields[name].value;
        }
    }

    handleAlternateItemSave(event) {
        const modal = this.template.querySelector('c-alternate-item-modal-cmp');
        if (modal) {
            let selectedItemId = JSON.parse(JSON.stringify(modal.getSelectedRecords()))[0]['dmpl__AlternateItemId__c'];
            console.log('selectedItemId ', selectedItemId);
            this.restrictAlternateItemsDialog = true;
            modal.hide();
            this.setFieldValue(ITEM_FIELD, selectedItemId);
            this.handleItemFieldChange({ detail: { value: [selectedItemId] } });
            // setTimeout(() => {
            //     this.itemInfo.data = undefined;
            //     const currentForm = this.template.querySelector('lightning-record-edit-form');
            //     if (currentForm) {
            //         currentForm.submit();
            //     }
            // }, 1500);
        }
    }

    @wire(getAlternateItemTypes, { itemId: '$getItemId' })
    wiredAlternateItemTypes({ error, data }) {
        if (data) {
            this.alternateItemTypes = data;
            console.log('sann' + JSON.stringify(this.alternateItemTypes))
            this.showAlternateItemsDialog();
        } else if (error) {
            console.error('Error fetching alternate item types', error);
        }
    }

    showAlternateItemsDialog(relatedItems) {    
        if (!this.restrictAlternateItemsDialog && relatedItems && relatedItems.length > 0) {
            let data = this.itemAlternateStock.data.map(x => {
                let newRow = this.alternateItemTypes[x.dmpl__ItemId__c] ?this.alternateItemTypes[x.dmpl__ItemId__c]:this.alternateItemTypes[x.dmpl__AlternateItemId__c];
                return {
                    dmpl__AlternateItemId__c: x.dmpl__ItemId__c,
                    dmpl__AlternateItemName__c: x.Name,
                    QuantityAvailable: x.QuantityAvailable ?? 0,
                    QuantityInHand: x.QuantityInHand ?? 0,
                    dmpl__BranchId__c: x.BranchId,
                    dmpl__AlternateItemType__c: newRow || 'Unknown'
                };
            });
            let currentItemStock = this.itemStock.data.find(x => x.BranchId === this.getBranchId) || {};
            data.push({
                dmpl__AlternateItemId__c: this.itemInfo.data.Id,
                dmpl__AlternateItemName__c: this.itemInfo.data.Name,
                QuantityAvailable: currentItemStock.QuantityAvailable ?? 0,
                QuantityInHand: currentItemStock.QuantityInHand ?? 0,
                dmpl__BranchId__c: currentItemStock.BranchId || '',
                dmpl__AlternateItemType__c: 'Original'
            });

            const modal = this.template.querySelector('c-alternate-item-modal-cmp');
            if (modal) {
                let selectedIds = [this.itemInfo.data.Id];
                modal.setColumns(JSON.stringify(this.alternateItemColums));
                modal.uniqueKey = `alternate-item-modal-${this.itemInfo.data.Id}-${Date.now()}`; 
                modal.setAlternateItems(JSON.stringify(data));
                modal.keyField = "dmpl__AlternateItemId__c";
                modal.setPreSelectedRows(JSON.stringify(selectedIds))
                modal.maxRowSelection = 1;
                modal.show();
            }
        }
    }

    hideAlternateItemsDialog() {
        const modal = this.template.querySelector('c-alternate-item-modal-cmp');
        if (modal) {
            this.itemInfo.data = undefined;
            modal.hide();
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

    handleBeginScanClick(event) {
        const scanFieldToUse = this.getFieldToScanFor;
        if (!this.myScanner || !scanFieldToUse) {
            return;
        }
        const scanningOptions = {
            barcodeTypes: [this.barCodeType ? this.barCodeType : this.myScanner.barcodeTypes.QR]
        };
        this.myScanner
            .beginCapture(scanningOptions)
            .then((result) => {
                this.setFieldValue(
                    scanFieldToUse?.apiName,
                    result.value
                )
                setTimeout(() => {
                    this.template.querySelector("lightning-record-edit-form[data-my-id=line]").submit();
                }, DELAY);
            })
            .catch((error) => {
                if (error && error.code && error.code == 'USER_DISMISSED') {
                    console.error(error);
                } else {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Scan Failed',
                            message:
                                'Scan Failed : ' +
                                JSON.stringify(error),
                            variant: 'warning',
                            mode: 'sticky'
                        })
                    );
                }
            })
            .finally(() => {
                this.myScanner.endCapture();
            });
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
            v.dmpl__SourceObjectNameId__r?.QualifiedApiName == sourceApiName);
        if(mappings && mappings.length>0){
            if(objectId){
                try{
                    const result = await getFieldMappingsData({ 
                        sourceObjectApiName: sourceApiName,
                        destinationObjectApiName: this.getChildObjectApiName,
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
                                            this.setFieldValue(
                                                m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                                source[m.dmpl__SourceFieldNameId__r.QualifiedApiName], false);
                                        }
                            }
                        });
                    }   
                } catch(error){
                    this.error = error;
                }
            } else {
                mappings.forEach(m=>{
                    if(m.dmpl__DestinationFieldName__r.QualifiedApiName
                        && m.dmpl__SourceFieldNameId__r.QualifiedApiName){                            
                            this.setFieldValue(
                                m.dmpl__DestinationFieldName__r?.QualifiedApiName, 
                                undefined, false);
                    }
                });
            }        
        }
    }

    async handleSearch(event){
        let fieldName = event.detail.name;
        let fieldsetName = this.customItemLookupFieldsetName ? this.customItemLookupFieldsetName : '' ;
        try{
            const result = await performSearch({ 
                searchTerm: event.detail.searchTerm, 
                selectedIds: event.detail.selectedIds, 
                objectApiName: 'dmpl__Item__c',
                fieldset: fieldsetName,
                filter: this.parseDynamicString(this.customItemLookupFilter)
            });

            if (result) {
                let field = this.getSearchField(fieldName);
                if(field){
                    if(fieldsetName){
                        getFieldsByFieldSetName({ 
                            objectApiName: 'dmpl__Item__c', 
                            fieldSetName: fieldsetName })
                        .then(fsResult => {
                            this.customLookupColumns = fsResult.map(v=> {
                                return {
                                    label: v.label,
                                    fieldName: v.apiName, 
                                    hideDefaultActions: true,
                                }
                            });
                            field.setSearchCoulmns(this.customLookupColumns);
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
                }
            }
        }catch(error){
            this.error = error;
        }
    }

    async handleSearchFocus(event){
        let fieldName = event.detail.name;
        let fieldsetName = this.customItemLookupFieldsetName ? this.customItemLookupFieldsetName : '' ;
        if(this.defaultedSearch){
            return;
        }
        let field = this.getSearchField(fieldName);
        if(field){
            try{
                let result = undefined;
                if(this.customItemLookupFilter){
                    result = await listView({ 
                        selectedIds: [], 
                        objectApiName: 'dmpl__Item__c',
                        fieldset: fieldsetName,
                        filter: this.parseDynamicString(this.customItemLookupFilter)
                    });
                }else {
                    result = await getRecentlyViewed({ 
                        objectApiName: 'dmpl__Item__c'});
                }
                if (result) {
                    field.setDefaultResults(result);
                    this.defaultedSearch = true;
                }
            }catch(e){
                this.handleError(e);
            }
        }
    }

    handleSelectionChange(event){
        if(event.detail.selectedIds && event.detail.selectedIds.length>0){
            this.setFieldValue(
                event.detail.name, 
                event.detail.selectedIds[0],
                true);
                this.handleFieldChange({ 
                    target: { id:'dmpl__ItemId__c-' },
                    detail: { value: [event.detail.selectedIds[0]] } });
        }else{
            this.setFieldValue(
                event.detail.name, 
                null,
                true);
                this.handleFieldChange({ 
                    target: { id:'dmpl__ItemId__c-' },
                    detail: { value: [] } });
        }

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

    parseDynamicString(query){
        if(!query){
            return '';
        }
        const matches = query.match(/\{(.*?)\}/g);
        const result = [];
        if (matches) {
            for (let i = 0; i < matches.length; ++i) {
                const match = matches[i];
                const fiedlName = match.substring(1, match.length - 1);
                let fv = '';
                if(fiedlName.startsWith('host.')){
                    fv = this.getHostFieldValue(fiedlName.replace('host.', ''));
                }else {
                    fv = this.getFieldValue(fiedlName);
                }
                if(!fv){
                    return '';
                }
                query = query.replace(match, fv);
            }
        }
        return query;
    }

    getDynamicFields(query){
        const result = [];
        if(!query){
            return result;
        }
        const matches = query.match(/\{(.*?)\}/g);
        if (matches) {
            for (let i = 0; i < matches.length; ++i) {
                const match = matches[i];
                const fiedlName = match.substring(1, match.length - 1);
                result.push(fiedlName.replace('host', this.objectApiName));
            }
        }
        return result;
    }
}