import { LightningElement, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import getLedgerData from '@salesforce/apex/InventoryConsoleController.getLedgerData';
import getOpeningStock from '@salesforce/apex/InventoryConsoleController.getOpeningStock';
import getStock from '@salesforce/apex/InventoryConsoleController.getStock';
import getUserDefaults from '@salesforce/apex/RecordFormController.getUserDefaults';
import getUserOrgDefaultFiscalPeriod from '@salesforce/apex/UserDefaultsController.getUserOrgDefaultFiscalPeriod';
import documentDateLabel from '@salesforce/label/c.InventoryConsole_Ledger_DocumentDateLabel';
import ledgerNameLabel from '@salesforce/label/c.InventoryConsole_Ledger_LedgerNameLabel';
import sourceDocumentLabel from '@salesforce/label/c.InventoryConsole_Ledger_SourceDocumentLabel';
import ledgerTypeLabel from '@salesforce/label/c.InventoryConsole_Ledger_LedgerTypeLabel';
import quantityLabel from '@salesforce/label/c.InventoryConsole_Ledger_QuantityLabel';
import availableLabel from '@salesforce/label/c.InventoryConsole_Ledger_AvailableLabel';
import inHandLabel from '@salesforce/label/c.InventoryConsole_Ledger_InHandLabel';
import itemNameLabel from '@salesforce/label/c.InventoryConsole_Stock_ItemNameLabel';
import availableQtyLabel from '@salesforce/label/c.InventoryConsole_Stock_AvailableQuantityLabel';
import inHandQtyLabel from '@salesforce/label/c.InventoryConsole_Stock_InHandQuantityLabel';

export default class InventoryConsole extends LightningElement {

    customLabel = {
        documentDate: documentDateLabel || 'Document Date',
        ledgerName: ledgerNameLabel || 'Ledger Name',
        sourceDocument: sourceDocumentLabel || 'Source Document',
        ledgerType: ledgerTypeLabel || 'Ledger Type',
        quantity: quantityLabel || 'Quantity',
        available: availableLabel || 'Available',
        inHand: inHandLabel || 'In Hand',
        itemName: itemNameLabel || 'Item Name',
        availableQty: availableQtyLabel || 'Available Quantity',
        inHandQty: inHandQtyLabel || 'In Hand Quantity'
    };

    viewType = 'ledger';
    hasData = false;
    isLoading = false;
    isFormLoading = true;
    viewOptions = [
        { label: 'Ledger', value: 'ledger' },
        { label: 'Stock As On', value: 'stock' },
        // { label: 'Valuation As On', value: 'value' },
    ];
    
    ledgerColumns = [
        { label: this.customLabel.documentDate, fieldName: 'dmpl__DocumentDate__c', type: 'date', hideDefaultActions: true },
        { 
            label: this.customLabel.ledgerName, 
            fieldName: 'nameUrl', 
            type: 'url', 
            target: '_self', 
            hideDefaultActions: true,
            typeAttributes: { label: { fieldName: 'Name' } }
        },
        { label: this.customLabel.sourceDocument, fieldName: 'dmpl__SourceDocument__c', type: 'text', hideDefaultActions: true },
        { label: this.customLabel.ledgerType, fieldName: 'dmpl__InventoryLedgerType__c', type: 'text', hideDefaultActions: true },
        { 
            label: this.customLabel.quantity, 
            fieldName: 'dmpl__Quantity__c', 
            type: 'number', 
            hideDefaultActions: true,
            cellAttributes: {
                class: { fieldName: 'QuantityColor' },
                alignment: 'left'
            }
        },
        { 
            label: this.customLabel.available, 
            fieldName: 'inHandQty', 
            type: 'number', 
            hideDefaultActions: true,
            cellAttributes: {
                class: { fieldName: 'availableColor' },
                alignment: 'left'
            }
        },
        { 
            label: this.customLabel.inHand, 
            fieldName: 'availableQty', 
            type: 'number', 
            hideDefaultActions: true,
            cellAttributes: {
                class: { fieldName: 'inHandColor' },
                alignment: 'left'
            }
        }
    ];

    stockColumns = [
        { 
            label: this.customLabel.itemName, 
            fieldName: 'ItemName', 
            type: 'text', 
            hideDefaultActions: true,
            cellAttributes: { alignment: 'left' }
        },
        { 
            label: this.customLabel.availableQty, 
            fieldName: 'availableQty', 
            type: 'number', 
            hideDefaultActions: true,
            cellAttributes: { alignment: 'left' }
        },
        { 
            label: this.customLabel.inHandQty, 
            fieldName: 'inHandQty', 
            type: 'number', 
            hideDefaultActions: true,
            cellAttributes: { alignment: 'left' }
        },
    ];
    
    ledgerData =[];
    stockData =[];
    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            if (currentPageReference.state?.defaultFieldValues) {
                this.urlStateParameters = currentPageReference.state?.defaultFieldValues;
            }
        }
    }
    
    @wire(getObjectInfo, { objectApiName: 'dmpl__InventoryLedger__c' })
    objectInfo;
    
    @wire(getUserDefaults, {})
    userDefaults;
    
    @wire(getUserOrgDefaultFiscalPeriod, {})
    defaultFiscalPeriod;

    get isLedgerView(){
        return this.viewType == 'ledger';
    }
    
    renderedCallback(){
        this.setDataTableHeight();
    }

    connectedCallback(){
        window.onresize = (e)=>{
            this.setDataTableHeight()
        };
    }

    setDataTableHeight(){
        let container = this.template.querySelector('.dmpl-fullpage-container');
        if(container){
            const viewportOffset = container.getBoundingClientRect();
            container.style = `height: ${window.innerHeight - viewportOffset?.top - 12}px;`;
        }
    }

    setFieldValue(name, value) {
        this[name] = value;
        let inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        let field = inputFields && inputFields.find(v => v.fieldName == name);
        if (field) {
            if(field.value != value){
                field.value = value;
            }
            return;
        }
        inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input'
        ));
        field = inputFields && inputFields.find(v => v.name == name);
        if (field && field.value != value){
            field.value = value;
        }
    }

    getFieldValue(name) {
        const inputFields = Array.from(this.template.querySelectorAll(
            'lightning-input-field'
        ));
        return inputFields && inputFields.find(f => f.fieldName == name)?.value;
    }

    populateUrlValues(urlValues) {
        if(!this.urlStateParameters){
            return;
        }
        urlValues.split(',').forEach(p => {
            if (p) {
                const nvPair = p.split("=");
                if (nvPair.length == 2) {
                    this.setFieldValue(nvPair[0], nvPair[1]=='undefined'?null:nvPair[1]);
                }
            }
        });
      }

    loadUserDefaults(){
        if (!this.userDefaults || !this.userDefaults.data) {
            return
        }
        if (this.userDefaults.data.dmpl__DefaultBranchId__c) {
            this.setFieldValue('dmpl__BranchId__c', this.userDefaults.data.dmpl__DefaultBranchId__c);
        }
        if (this.userDefaults.data.dmpl__DefaultPartnerAccountId__c) {
            this.setFieldValue('dmpl__PartnerAccountId__c', this.userDefaults.data.dmpl__DefaultPartnerAccountId__c);
        }
    }

    loadFiscalPeriodDefaults(){
        this.setFieldValue('asOnDate', new Date());
        if (!this.defaultFiscalPeriod || !this.defaultFiscalPeriod.data) {
            return
        }
        if (this.defaultFiscalPeriod.data.StartDate) {
            this.setFieldValue('fromDate', this.defaultFiscalPeriod.data.StartDate);
        }
        if (this.defaultFiscalPeriod.data.EndDate) {
            this.setFieldValue('toDate', this.defaultFiscalPeriod.data.EndDate);
        }
    }

    async showLedger(){
        this.hasData = false;
        this.isLoading = true;
        try {
            let openingDataPromise = getOpeningStock({
                    itemId: this.dmpl__ItemId__c, 
                    branchId: this.dmpl__BranchId__c, 
                    partnerAccountId: this.dmpl__PartnerAccountId__c,
                    asOnDate : this.fromDate
                });
            let ledgerDataPromise = getLedgerData({ 
                    itemId: this.dmpl__ItemId__c, 
                    branchId: this.dmpl__BranchId__c, 
                    partnerAccountId: this.dmpl__PartnerAccountId__c,
                    fromDate : this.fromDate,
                    toDate : this.toDate
                });
            let results = await Promise.all([openingDataPromise, ledgerDataPromise]);
            let openingData = JSON.parse(JSON.stringify(results[0]));
            let ledgerData = JSON.parse(JSON.stringify(results[1]));
                        
            let runningInHand = this.getOpeningInHand(openingData);
            let runningAvailable = this.getOpeningAvailable(openingData);
            const openingStockRow = {
                dmpl__InventoryLedgerType__c: 'Opening Stock',
                availableQty: runningAvailable,
                inHandQty: runningInHand
            };
            ledgerData = ledgerData.map(item => {
                let avialbleQty = this.getAvailableQty(item);
                let inHandQty = this.getInHandQty(item);
                runningAvailable += avialbleQty;
                runningInHand += inHandQty;
                item.dmpl__InventoryLedgerType__c = item.dmpl__InventoryLedgerType__c 
                    + ((item.dmpl__InventoryLedgerType__c == 'Sold' 
                        && (item.dmpl__AllocatedQuantity__c == undefined || item.dmpl__AllocatedQuantity__c == 0) 
                        && (item.dmpl__PickedQuantity__c == undefined || item.dmpl__PickedQuantity__c == 0)
                        && (item.dmpl__DeliveredQuantity__c == undefined ||  item.dmpl__DeliveredQuantity__c == 0)) ? ' (OTC)'  : '');
                if(item.dmpl__InventoryLedgerType__c == 'Outward' 
                    && (item.dmpl__Quantity__c == undefined || item.dmpl__Quantity__c == 0)){
                    item.dmpl__Quantity__c = item.dmpl__PendingDeliveriesQuantity__c;
                }
                return {
                    ...item,
                    availableQty: runningAvailable,
                    inHandQty: runningInHand,
                    sourceUrl: '/'+ item.dmpl__SourceDocument__c,
                    nameUrl: '/'+ item.Id,
                    QuantityColor: avialbleQty < 0 || inHandQty < 0 ? "slds-text-color_error":"slds-text-color_success",
                    availableColor:avialbleQty < 0 ? "slds-text-color_error" : avialbleQty > 0 ? "slds-text-color_success" : null,
                    inHandColor: inHandQty < 0 ? "slds-text-color_error" : inHandQty > 0 ? "slds-text-color_success" : null
                };
            });
            const closingStockRow = {
                dmpl__InventoryLedgerType__c: 'Closing Stock',
                availableQty: runningAvailable,
                inHandQty: runningInHand
            };
            ledgerData = [openingStockRow, ...ledgerData];
            ledgerData = [...ledgerData, closingStockRow];
            this.ledgerData = ledgerData;               
            this.hasData = ledgerData.length > 0;
            this.isLoading = false;
        } catch (error) {
            this.isLoading = false;
        }
    }    
    
    async showStock(){
        this.hasData = false;
        this.isLoading = true;
        try {
            let openingDataPromise = getStock({
                    branchId: this.dmpl__BranchId__c, 
                    partnerAccountId: this.dmpl__PartnerAccountId__c,
                    asOnDate : this.asOnDate
                });
            let results = await Promise.all([openingDataPromise]);
            let stockData = JSON.parse(JSON.stringify(results[0]));                        
            
            let itemIds = [...new Set(stockData.map(item => item.ItemId))];
            stockData = itemIds.map(itemId => {
                let itemRows = stockData.filter(v=>v.ItemId == itemId)
                let avialbleQty = this.getOpeningInHand(itemRows);
                let inHandQty = this.getOpeningAvailable(itemRows);
                return {
                    ...itemId,
                    availableQty: avialbleQty,
                    inHandQty: inHandQty,
                    ItemName: itemRows[0]['ItemName']
                };
            });
            this.stockData = stockData;               
            this.hasData = stockData.length > 0;
            this.isLoading = false;
        } catch (error) {
            this.isLoading = false;
        }
    }   

    getOpeningInHand(data){
        if(!data || !data.length>0){
            return 0;
        }
        return data.reduce((total, row)=>
            total + 
                (row['LedgerType'] == 'Allocation' ? 0 : 
                row['LedgerType'] == 'Sold' ? (-1 * (row['TotalQty'] 
                    - (row['TotalDeliveredQuantity'] ? row['TotalDeliveredQuantity'] : 0))) : 
                row['LedgerType'] == 'Picked' ? 0 : 
                row['LedgerType'] == 'SoftCommit' ? 0 : 
                row['LedgerType'] == 'Outward' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'Pipeline' ? 0 : 
                row['LedgerType'] == 'Damaged' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'Shortage' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'Excess' ? row['TotalQty'] :
                row['LedgerType'] == 'Inward' ? row['TotalQty'] : 
                row['LedgerType'] == 'Purchased' ? 0 : 
                row['LedgerType'] == 'PurchaseReturn' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'TransferOutward' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'TransferInward' ? (1 * row['TotalQty']) : 
                row['LedgerType'] == 'Adjustment' ? row['TotalQty'] : 
                row['LedgerType'] == 'SaleReturn' ? row['TotalQty'] : 
                0)
        , 0);
    }

    getOpeningAvailable(data){
        if(!data || !data.length>0){
            return 0;
        }
        return data.reduce((total, row)=>
            total + 
                (row['LedgerType'] == 'Allocation' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'Sold' ? (-1 * (row['TotalQty'] 
                    - (row['TotalAllocatedQty'] ? row['TotalAllocatedQty'] : 0)
                    - (row['TotalPickedQty'] ? row['TotalPickedQty'] : 0)
                    - (row['TotalDeliveredQuantity'] ? row['TotalDeliveredQuantity'] : 0))): 
                row['LedgerType'] == 'Picked' ? 0 : 
                row['LedgerType'] == 'Outward' ? 0 : 
                row['LedgerType'] == 'SoftCommit' ? 0 : 
                row['LedgerType'] == 'Pipeline' ? 0 : 
                row['LedgerType'] == 'Damaged' ? 0 : 
                row['LedgerType'] == 'Shortage' ? 0 : 
                row['LedgerType'] == 'Excess' ? row['TotalQty'] :
                row['LedgerType'] == 'Inward' ? row['TotalQty'] : 
                row['LedgerType'] == 'Purchased' ? 0 : 
                row['LedgerType'] == 'PurchaseReturn' ? (-1 * row['TotalQty']) : 
                row['LedgerType'] == 'TransferOutward' ? (-1 * row['TotalQty']) :
                row['LedgerType'] == 'TransferInward' ? (1 * row['TotalQty']) : 
                row['LedgerType'] == 'Adjustment' ? row['TotalQty'] : 
                row['LedgerType'] == 'SaleReturn' ? row['TotalQty'] : 
                0)
        , 0);
    }

    getAvailableQty(item) {
        return item.dmpl__Quantity__c * 
            (item.dmpl__InventoryLedgerType__c == 'Allocation' ? -1 :
            item.dmpl__InventoryLedgerType__c == 'Sold' ? 
                ((item.dmpl__AllocatedQuantity__c > 0 
                    || item.dmpl__PickedQuantity__c > 0
                    || item.dmpl__DeliveredQuantity__c > 0) ? 0 : -1) : 
            item.dmpl__InventoryLedgerType__c == 'Picked' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'SoftCommit' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'Shortage' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'Damaged' ? 0 :
            item.dmpl__InventoryLedgerType__c == 'Excess' ? 1 : 
            item.dmpl__InventoryLedgerType__c == 'Outward' ? 0 :
            item.dmpl__InventoryLedgerType__c == 'Pipeline' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'Inward' ? 1 : 
            item.dmpl__InventoryLedgerType__c == 'Purchased' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'PurchaseReturn' ? -1 : 
            item.dmpl__InventoryLedgerType__c == 'TransferInward' ? 
                (this.dmpl__BranchId__c == item.dmpl__BranchId__c ? 1 : 0) : 
            item.dmpl__InventoryLedgerType__c == 'TransferOutward' ? 
                (this.dmpl__BranchId__c == item.dmpl__BranchId__c ? -1 : 0) : 
            item.dmpl__InventoryLedgerType__c == 'Adjustment' ? 1 : 
            item.dmpl__InventoryLedgerType__c == 'SaleReturn' ? (item.dmpl__PendingDeliveriesQuantity__c > 0 ? 0: 1) : 
            1)
    }

    getInHandQty(item) {
        return item.dmpl__Quantity__c * 
            (item.dmpl__InventoryLedgerType__c == 'Allocation' ? 0 :
            item.dmpl__InventoryLedgerType__c == 'Sold' ? 
                (item.dmpl__DeliveredQuantity__c > 0 ? 0 : -1) : 
            item.dmpl__InventoryLedgerType__c == 'Picked' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'SoftCommit' ? 0 :
            item.dmpl__InventoryLedgerType__c == 'Shortage' ? -1 : 
            item.dmpl__InventoryLedgerType__c == 'Damaged' ? -1 : 
            item.dmpl__InventoryLedgerType__c == 'Excess' ? 1 :
            item.dmpl__InventoryLedgerType__c == 'Outward' ? -1 : 
            item.dmpl__InventoryLedgerType__c == 'Pipeline' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'Inward' ? 1 : 
            item.dmpl__InventoryLedgerType__c == 'Purchased' ? 0 : 
            item.dmpl__InventoryLedgerType__c == 'PurchaseReturn' ? -1 : 
            item.dmpl__InventoryLedgerType__c == 'TransferInward' ? 
                (this.dmpl__BranchId__c == item.dmpl__BranchId__c ? 1 : 0) : 
            item.dmpl__InventoryLedgerType__c == 'TransferOutward' ? 
                (this.dmpl__BranchId__c == item.dmpl__BranchId__c ? -1 : 0) : 
            item.dmpl__InventoryLedgerType__c == 'Adjustment' ? 1 : 
            item.dmpl__InventoryLedgerType__c == 'SaleReturn' ? (item.dmpl__PendingDeliveriesQuantity__c > 0 ? 0: 1) : 
            1)
    }

    connectedCallback(){
        this.handleLoad();
    }

    handleFormLoad(event){
        this.isFormLoading = false;
        this.handleLoad();
    }

    handleLoad(){
        this.populateUrlValues(this.urlStateParameters);
        this.loadUserDefaults();
        this.loadFiscalPeriodDefaults();
    }

    handleViewChanged(event) {
        this.viewType = event.detail.value;
    }

    async handleSubmit(event){
        if(this.viewType == 'ledger'){
            await this.showLedger();
        }else if(this.viewType == 'stock'){
            await this.showStock();
        }else if(this.viewType == 'value'){
            await this.showValuation();
        }
        return false;
    }

    handleFieldChange(event) {
        if(event.target.fieldName){
            this[event.target.fieldName] = event.target.value;
        }else {
            this[event.target.name] = event.detail.value;
        }
    }
}