import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getIncentiveResources from '@salesforce/apex/IncentiveController.getIncentiveResources';
import getIncentivePeriods from '@salesforce/apex/IncentiveController.getIncentivePeriods';
import getIncentiveResourcesTargets from '@salesforce/apex/IncentiveController.getIncentiveResourcesTargets';
import updateIncentiveResourcesTargets from '@salesforce/apex/IncentiveController.updateIncentiveResourcesTargets';
import getIncentiveKPI from '@salesforce/apex/IncentiveController.getIncentiveKPI';
import { refreshApex } from '@salesforce/apex';

const DELAY = 500;

export default class IncentiveResourcePeriod extends LightningElement {
    @track incentivePlanId;
    @track draftValues = [];
    @track selectedKPI = undefined;
    @track rows = [];
    kpiOptions = [];
    columns = undefined;
    resources = undefined;
    selectedKPI = undefined;
    error;
    KPICaption = '';
    targetData = undefined;
    searchKey = '';

    @wire(CurrentPageReference)
    handlePageReference(currentPageReference) {
        if (currentPageReference && currentPageReference.attributes) {
            this.incentivePlanId = currentPageReference.attributes.recordId;
        }
    }

    @wire(getIncentivePeriods, { incentiveId: '$incentivePlanId' })
    wiredIncentivePeriods({ error, data }) {
        if (data) {
            this.columns = [
                {
                    label: 'Resource',  
                    fieldName: 'resource', 
                    type: 'text',
                    editable: false,
                    initialWidth: 150,
                    hideDefaultActions: true
                }
            ];

            this.columns = this.columns.concat(data.map(period => ({
                label: period.Name,
                fieldName: period.Id,
                type: 'number',
                editable: true,
                initialWidth: 100,
                hideDefaultActions: true
            })));
            this.transposeData();
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getIncentiveResources, { incentiveId: '$incentivePlanId', searchKey: '$searchKey' })
    wiredIncentiveResources({ error, data }) {
        if (data) {
            this.resources = data.map(resource => {
                return { 
                    id: resource.Id,
                    resource: resource.Name,
                    resourceId: resource.dmpl__ResourceId__c,
                };
            });
            this.transposeData();
        } else if (error) {
            this.error = error;
        }
    }
    
    @wire(getIncentiveKPI, {
        incentiveId: '$incentivePlanId' 
    })wiredIncentiveKPI({ error, data }) {
        if (data) {
            this.kpiOptions = data;
            if(this.kpiOptions.length > 0){
                this.selectedKPI = this.kpiOptions[0].value;
                this.KPICaption = this.kpiOptions[0].label;
            }
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getIncentiveResourcesTargets, {
        kpiId: '$selectedKPI',
        incentiveId: '$incentivePlanId',
        searchKey: '$searchKey'
    })wiredIncentiveResourcesTargets(targetData) {
        this.wiredIncentiveResourcesTargets = targetData;
        const { data, error } = targetData;
        if (data) {
            this.targetData = data;
            this.transposeData();
        } else if (error) {
            this.error = error;
        }
    }

    transposeData(){
        if(this.targetData === undefined || this.resources === undefined || this.columns === undefined){
            this.rows = [];
            return;
        }
        this.rows = this.resources.map(row => {
            this.targetData.filter(target => target.dmpl__IncentiveResourceId__c === row.id)
            .forEach(target => {
                row[target.dmpl__IncentivePeriodId__c] = target.dmpl__Value__c;
            });
            return row;
        });
    }

    handleComboboxChange(event) {
        this.rows = [];
        this.selectedKPI = event.detail.value;
        this.KPICaption = this.kpiOptions.find(kpi => kpi.value === this.selectedKPI).label;
    }
    
    handleRefreshList(event){
        refreshApex(this.wiredIncentiveResourcesTargets);
    }

    async handleSearch(event) {
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(async() => {
            this.searchKey = searchKey;
        }, DELAY);
    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        let rowsToUpdate = [];
        updatedFields.forEach(row => {
            rowsToUpdate = rowsToUpdate.concat(Object.keys(row).filter(key => key !== 'resource' && key !== 'id').map(periodId => {
                const target = this.targetData.find(target => 
                    target.dmpl__IncentiveResourceId__c === row.id 
                    && target.dmpl__IncentivePeriodId__c === periodId);
                if(target === undefined){
                    return undefined;
                }
                return {
                    Id: target.Id,
                    dmpl__Value__c: row[periodId]
                };
            }).filter(row => row !== undefined));
        });
        updateIncentiveResourcesTargets({data:rowsToUpdate}).then(() => {
            refreshApex(this.wiredIncentiveResourcesTargets);
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Targets updated',
                    variant: 'success'
                })
            )})
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating targets',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
        this.draftValues = [];
    }
    
}