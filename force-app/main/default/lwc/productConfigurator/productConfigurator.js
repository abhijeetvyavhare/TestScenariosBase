import { LightningElement, api, wire, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';
import getConfigurableItems from '@salesforce/apex/ProductConfiguratorController.getConfigurableItems';
import getPackageConfiguration from '@salesforce/apex/ProductConfiguratorController.getPackageConfiguration';
import applyPackageConfiguration from '@salesforce/apex/ProductConfiguratorController.applyPackageConfiguration';

export default class ProductConfigurator extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api title;

    selectedLineId;
    configurableItems;
    configurableItemsValue;
    configurableComponents;
    configurableComponentsValue;
    errors;
    draftValues;
    dataSource;

    @wire(getConfigurableItems, { objectApiName: '$objectApiName', recordId: '$recordId' })
    wiredConfigurableItems(value) {
        this.configurableItemsValue = value;
        const { data, error } = value;
        if (data) {
            this.errors = undefined;
            this.configurableItems = data;
            if (this.configurableItems.length > 0) {
                this.selectedLineId = this.configurableItems[0].Id;
            }
        } else if (error) {
            this.errors = error;
            this.configurableItems = undefined;
            this.selectedProductId = undefined;
            this.selectedSKUId = undefined;
        }
    }

    @wire(getPackageConfiguration, { objectApiName: '$objectApiName', recordId: '$selectedLineId' })
    wiredComponents(value) {
        this.configurableComponentsValue = value;
        const { data, error } = value;
        if (data) {
            this.errors = undefined;
            this.configurableComponents = data;
            this.draftValues = data.map(v => {
                return {
                    Id: v.Id,
                    isSelected: v.IsSelected,
                    quantity: v.Quantity,
                    isQuantityEditable: v.IsQuantityEditable
                }
            });

            this.dataSource = this.getFeatureNames.map(f => {
                return {
                    "name": f,
                    "rowNumberOffset": this.configurableComponents.indexOf(this.configurableComponents
                        .find(v => v.FeatureName == f)),
                    "selectedComponents": this.configurableComponents
                        .filter((v, i, a) => v.FeatureName == f && v.IsSelected).map(v => v.Id),
                    "components": this.configurableComponents
                        .filter((v, i, a) => v.FeatureName == f)
                        .map(v => {
                            return {
                                "Id": v.Id,
                                "ComponentItemId": v.ComponentItemId,
                                "ComponentItemName": v.ComponentItemName,
                                "FeatureName": v.FeatureName,
                                "FeatureId": v.FeatureId,
                                "IsSelected": v.IsSelected,
                                "PackageType": v.PackageType,
                                "UnitPrice": v.UnitPrice,
                                "StockInHand": v.StockInHand,
                                "StockAvailable": v.StockAvailable,
                                "Quantity": v.Quantity,
                                "IsSelected": v.IsSelected,
                                "IsDisabled": v.IsMandatory || v.IsBundled,
                                "IsBundled": v.IsBundled,
                                "IsMandatory": v.IsMandatory,
                                "IsQuantityEditable": v.IsQuantityEditable,
                                "MaxQuantity": v.MaxQuantity,
                                "MinQuantity": v.MinQuantity
                            }
                        })
                }
            });
        } else if (error) {
            this.errors = error;
            this.configurableComponents = undefined;
            this.dataSource = undefined;
        }
    }

    columns = [
        {
            label: 'Selected', fieldName: 'IsSelected', type: 'toggleButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true,
            typeAttributes: {
                buttonDisabled: { fieldName: 'IsDisabled' },
                rowId: { fieldName: 'Id' },
            }
        },
        { label: 'Component', fieldName: 'ComponentItemName', hideDefaultActions: true },
        { label: 'In Hand', fieldName: 'StockInHand', type: 'number', initialWidth: 90, hideDefaultActions: true },
        { label: 'Available', fieldName: 'StockAvailable', type: 'number', initialWidth: 90, hideDefaultActions: true },
        { label: 'Quantity', fieldName: 'Quantity', type: 'number', initialWidth: 90, hideDefaultActions: true, editable: true },
        { label: 'Unit Price', fieldName: 'UnitPrice', type: 'currency', initialWidth: 150, hideDefaultActions: true }
    ];

    get isLoaded() {
        console.log('this.configurableItemsValue ' + JSON.parse(JSON.stringify(this.configurableItemsValue)));
        return this.configurableItemsValue
            && (this.configurableItemsValue.data || this.configurableItemsValue.error)
            && (this.configurableItemsValue.data?.length == 0 ||
                (this.configurableComponentsValue
                    && (this.configurableComponentsValue.data || this.configurableComponentsValue.error)));
    }

    get isNoData() {
        return this.configurableItemsValue.data?.length == 0
            || this.configurableComponentsValue && this.configurableComponentsValue.data && this.configurableComponentsValue.data.length == 0;
    }

    get getConfigurableItems() {
        if (this.configurableItems) {
            console.log('data ', this.configurableItems);
            return this.configurableItems.map(i => {
                if (this.objectApiName === 'dmpl__Quote__c ' ) {
                    return {
                        label: `${i.Name} - ${i.dmpl__AssetId__r?.dmpl__SKUId__r ? i.dmpl__AssetId__r?.dmpl__SKUId__r.Name : i.dmpl__AssetId__r?.dmpl__ItemId__r.Name}`,
                        value: i.Id
                    }
                }
                else {
                    return {
                        label: `${i.Name} - ${i.dmpl__SKUId__r ? i.dmpl__SKUId__r.Name : i.dmpl__ItemId__r.Name}`,
                        value: i.Id
                    }
                }
            });
        }
    }

    get getFeatureNames() {
        if (this.configurableComponents) {
            return this.configurableComponents.map(x => x.FeatureName).filter((v, i, a) => a.indexOf(v) === i);
        }
    }

    handleProductChange(event) {
        this.selectedLineId = event.detail.value;
    }

    handleSelectedRec(event) {
        let row = this.draftValues.find(v => v.Id == event?.detail?.value?.rowId);
        if (row) {
            row.isSelected = event?.detail?.value?.state;
        }
    }

    handleCellChange(event) {
        event.detail.draftValues.forEach((draftValue) => {
            let component = this.draftValues.find(v => v.Id == draftValue.Id);
            if (component && component.isQuantityEditable) {
                component.quantity = draftValue.Quantity
            }
        });
    }

    handleDialogClose() {
        refreshApex(this.configurableItemsValue);
        refreshApex(this.configurableComponentsValue);
        this.dispatchEvent(new CloseActionScreenEvent());
        this.dispatchEvent(new CustomEvent('recordsaved', { "detail": null }));
    }

    async handleSave(event) {
        try {
            const result = await applyPackageConfiguration({ objectApiName: this.objectApiName, recordId: this.selectedLineId, componentSettings: this.draftValues });
            var messsage = `Package Configuration applied created successfully.`;
            refreshApex(this.configurableItemsValue);
            refreshApex(this.configurableComponentsValue);
            notifyRecordUpdateAvailable([{ "recordId": this.selectedLineId }].concat(this.draftValues.map(v => { return { "recordId": v.Id } })));
            this.refreshStdComponents();
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(new CustomEvent('recordsaved', { "detail": event.detail }));
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: messsage,
                    variant: 'success',
                }),
            );
        } catch (error) {
            console.log('error ', error);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error updating or refreshing records',
                    message: error?.body?.message,
                    variant: 'error'
                })
            );
        };
    }
    
    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }
}