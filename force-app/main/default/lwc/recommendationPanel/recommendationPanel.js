import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, updateRecord, createRecord, deleteRecord } from "lightning/uiRecordApi";
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import queryServiceRecommendations from '@salesforce/apex/ServiceRecommendationController.getChecklistServiceRecommendations';

export default class RecommendationPanel extends LightningElement {
    @api title = 'Service Recommendations';
    @api recordId;
    @api targetObjectApiName;
    @api parentLookupField;
    @api chidlLookupField;
    @api selectionColumnName;

    @track currentAssetActions = [];

    @track isLoading = true;
    @track isVisible = true;
    @track masterRecord;
    @track serviceRecommendations = [];
    @track currentAssetId;
    @track currentDocumentDate;
    @track renderData = [];
    @track isMasterDataLoaded = false;
    @track isTransactedRecordLoaded = false;

    connectedCallback() {
        this.isLoading = false;
    }

    @wire(getRecord, { recordId: '$recordId', fields: ['Name'], layoutTypes: ['Full'], modes: ['View'] })
    handle({ error, data }) {
        if (data) {
            this.masterRecord = data;
            this.currentAssetId = this.masterRecord.fields.dmpl__AssetId__c.value;
            if (this.masterRecord.fields.CreatedDate)
                this.currentDocumentDate = this.masterRecord.fields.CreatedDate.value;

            this.getTransactedData();
        }
        else
            console.log('error', error)
    }

    @track distinctItemType = [];

    getTransactedData() {
        this.isLoading = true;
        queryServiceRecommendations({ assetId: this.masterRecord.fields.dmpl__AssetId__c.value, parentId: this.recordId }).then((result) => {
            this.serviceRecommendations = [];
            this.currentAssetActions = [];
            this.distinctItemType = [];
            this.distinctItemType.push('General');
            if (result) {
                result.forEach((record) => {
                    let newRecord = { ...record }
                    newRecord['IsRed'] = record.dmpl__Condition__c === 'Red';
                    newRecord['IsAmber'] = record.dmpl__Condition__c === 'Amber';
                    newRecord['IsGreen'] = record.dmpl__Condition__c === 'Green';
                    newRecord['IsNone'] = record.dmpl__Condition__c ? false : true;
                    this.currentAssetActions.push(newRecord);
                })
                if (this.currentAssetActions) {
                    this.currentAssetActions.forEach((internalRecord) => {
                        if (!this.distinctItemType.includes(internalRecord.dmpl__RecommendationType__c))
                            this.distinctItemType.push(internalRecord.dmpl__RecommendationType__c);
                    });
                }
                this.distinctItemType.forEach((recordType) => {
                    let internalResult = { RecordType: recordType, Items: [] };
                    this.currentAssetActions.forEach((internalRecord) => {
                        if (internalResult.Items.filter(x => x.RecommendationId == internalRecord.Id).length == 0 && this.currentAssetId == internalRecord.dmpl__AssetId__c && ((recordType == internalRecord.dmpl__RecommendationType__c) || (recordType == 'General' && internalRecord.dmpl__RecommendationType__c == null))) {
                            internalResult.Items.push({ RecommendationId: internalRecord.Id, Id: internalRecord.dmpl__ItemId__c, Name: internalRecord.dmpl__ItemId__r.Name, IsNone: internalRecord.dmpl__Condition__c ? false : true, IsRed: internalRecord.dmpl__Condition__c == 'Red', IsAmber: internalRecord.dmpl__Condition__c == 'Amber', IsGreen: internalRecord.dmpl__Condition__c == 'Green', addedInParentId: internalRecord[this.parentLookupField], addedInLineId: internalRecord[this.chidlLookupField], IsPresent: internalRecord[this.chidlLookupField] != null, IsPresentOld: internalRecord[this.chidlLookupField] != null, IsAssetActionPresent: false, IsAssetActionPresentOld: false });
                        }
                    })
                    this.serviceRecommendations.push(internalResult);
                })
                this.isLoading = false;
                this.isMasterDataLoaded = true;
                this.isTransactedRecordLoaded = true;
            }
        }).catch((error) => {
            console.log('Error :', error);
        })
    }


    get renderRecords() {
        return this.isMasterDataLoaded && this.isTransactedRecordLoaded;
    }

    addOrRemoveRelatedObject(event) {
        let recommendationId = event.target.id.split('-')[0];
        if (event.target.value === "true") {
            this.updatePastRecommendationData(recommendationId, 'IsPresent', true);
        }
        else {
            this.updatePastRecommendationData(recommendationId, 'IsPresent', false);
        }
    }

    updatePastRecommendationData(recommendationId, fieldName, value) {
        this.serviceRecommendations.forEach((internalRecord) => {
            internalRecord.Items.forEach((item) => {
                if (item.RecommendationId === recommendationId) {
                    item[fieldName] = value;
                }
            })
        })
    }



    refresh() {
        this.getTransactedData();
    }

    handleSave() {
        this.serviceRecommendations.forEach((internalRecord) => {
            internalRecord.Items.forEach((item) => {
                if (item.IsPresent != item.IsPresentOld && item.IsPresent) {
                    let itemId = item.Id;
                    let fields = {};
                    fields["dmpl__ItemId__c"] = itemId;
                    fields[this.parentLookupField] = this.recordId;
                    fields['dmpl__Quantity__c'] = 1;
                    fields['dmpl__ServiceRecommendationId__c'] = item.RecommendationId;
                    createRecord({ apiName: this.targetObjectApiName, fields })
                        .then((result) => {
                            item.IsPresent = true;
                            item.IsPresentOld = true;
                            item['addedInLineId'] = result.id;
                            item['addedInParentId'] = this.recordId;
                            fields = {};
                            fields['Id'] = item.RecommendationId;
                            fields[this.parentLookupField] = this.recordId;
                            fields[this.chidlLookupField] = result.id;
                            updateRecord({ fields }).then((updateResult) => {
                                this.getTransactedData();
                                this.showMessage('Success', 'Item Added Successfully', 'success');
                                this.refreshStdComponents();
                            }).catch((error) => {
                                this.getTransactedData();
                                this.showMessage('Error', error.body.message, 'error');
                            })
                            this.refreshStdComponents();
                        })
                        .catch(error => {
                            this.getTransactedData();
                            this.showMessage('Error', error.body.message, 'error');
                        });
                }
                else if (item.IsPresent != item.IsPresentOld && !item.IsPresent) {
                    deleteRecord(item['addedInLineId']).then((deleteResult) => {
                        item.IsPresent = false;
                        item.IsPresentOld = false;
                        let fields = {};
                        fields['Id'] = item['RecommendationId'];
                        fields[this.parentLookupField] = '';
                        updateRecord({ fields }).then((updateResponse) => {
                            item['addedInLineId'] = null;
                            item['addedInParentId'] = null;
                            item.IsPresent = false;
                            item.IsPresentOld = false;
                            this.getTransactedData();
                            this.showMessage('Success', 'Item Removed Successfully', 'success');
                            this.refreshStdComponents();
                        }).catch((error) => {
                            this.getTransactedData();
                            this.showMessage('Error', error.body.message, 'error');
                        })
                    }).catch((error) => {
                        this.getTransactedData();
                        this.showMessage('Error', error.body.message, 'error');
                    })
                }
            })
        })
        this.refreshStdComponents();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    showMessage(title, message, variant) {
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message: message,
                variant: variant
            })
        );
    }

    handleVisibleClick() {
        this.isVisible = !this.isVisible;
    }
}