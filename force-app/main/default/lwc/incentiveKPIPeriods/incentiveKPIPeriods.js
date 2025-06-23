import { LightningElement, track, wire } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getIncentiveResources from '@salesforce/apex/IncentiveController.getIncentiveResources';
import getIncentivePeriods from '@salesforce/apex/IncentiveController.getIncentivePeriods';
import getIncentiveKPITargets from '@salesforce/apex/IncentiveController.getIncentiveKPITargets';
import updateIncentiveResourcesTargets from '@salesforce/apex/IncentiveController.updateIncentiveResourcesTargets';
import getIncentiveKPI from '@salesforce/apex/IncentiveController.getIncentiveKPI';
import { refreshApex } from '@salesforce/apex';

export default class IncentiveResourcePeriod extends LightningElement {
    @track incentivePlanId;
    @track draftValues = [];
    @track selectedResource = undefined;
    @track rows = [];
    resourceOptions = [];
    columns = undefined;
    kpis = undefined;
    error;
    ResourceName = '';
    targetData = undefined;

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
                    label: 'KPI',  
                    fieldName: 'kpi', 
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

    @wire(getIncentiveResources, { incentiveId: '$incentivePlanId' })
    wiredIncentiveResources({ error, data }) {
        if (data) {
            this.resourceOptions = data.map(resource => {
                return { 
                    value: resource.Id,
                    label: resource.Name
                };
            });
            if(this.resourceOptions.length > 0){
                this.selectedResource = this.resourceOptions[0].value;
                this.ResourceName = this.resourceOptions[0].label;
            }
        } else if (error) {
            this.error = error;
        }
    }
    
    @wire(getIncentiveKPI, {
        incentiveId: '$incentivePlanId' 
    })wiredIncentiveKPI({ error, data }) {
        if (data) {
            this.kpis = data.map(kpi => {
                return { 
                    id: kpi.value,
                    name : kpi.label,
                    kpi: kpi.label
                };
            });
        } else if (error) {
            this.error = error;
        }
    }

    @wire(getIncentiveKPITargets, {
        resourceId: '$selectedResource',
        incentiveId: '$incentivePlanId' 
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
        if(this.targetData === undefined || this.kpis === undefined || this.columns === undefined){
            this.rows = [];
            return;
        }
        this.rows = this.kpis.map(row => {
            this.targetData.filter(target => target.dmpl__KPIConfigurationId__c === row.id)
            .forEach(target => {
                row[target.dmpl__IncentivePeriodId__c] = target.dmpl__Value__c;
            });
            return row;
        });
    }

    handleComboboxChange(event) {
        this.rows = [];
        this.selectedResource = event.detail.value;
        this.ResourceName = this.resourceOptions.find(resource => resource.value === this.selectedResource).label;
    }
    
    handleRefreshList(event){
        refreshApex(this.wiredIncentiveResourcesTargets);
    }

    handleSave(event) {
        const updatedFields = event.detail.draftValues;
        let rowsToUpdate = [];
        updatedFields.forEach(row => {
            rowsToUpdate = rowsToUpdate.concat(Object.keys(row).filter(key => key !== 'kpi' && key !== 'id').map(periodId => {
                const target = this.targetData.find(target => 
                    target.dmpl__KPIConfigurationId__c === row.id 
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