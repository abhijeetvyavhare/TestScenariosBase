import { api, wire, track, LightningElement } from 'lwc';
import getIncentivePeriods from '@salesforce/apex/IncentiveController.getIncentivePeriods';
import createSimulation from '@salesforce/apex/IncentiveController.createSimulation';
import processCompensation from '@salesforce/apex/IncentiveController.processCompensation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class IncentivePanel extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    @track selectedPeriodId;
    incentivePeriods = [];
    processOptions = [
        { label: 'Simulation', value: 'Simulation' },
        { label: 'Compensation', value: 'Compensation' },
    ]
    processValue = 'Simulation';
    isSimulation = true;
    displayInfo = {
        primaryField: 'dmpl__IncentivePeriod__c.Name',
        additionalFields: ['dmpl__DateFrom__c','dmpl__DateTo__c'],
    };
    filter = {
        criteria: [
            {
                fieldPath: 'dmpl__IncentivePlanId__c',
                operator: 'eq',
                value: this.recordId,
            },
        ],
    };

    @wire(getIncentivePeriods, { incentiveId: '$recordId' })
    wiredIncentivePeriods({ error, data }) {
        if (data) {
            this.incentivePeriods = data.map(period => ({
                label: period.Name,
                id: period.Id,
            }));
        } else if (error) {
            this.error = error;
        }
    }

    handleProcessChange(event) {
        this.processValue = event.detail.value;
        if(this.processValue === 'Simulation') {
            this.isSimulation = true;
        } else if(this.processValue === 'Compensation') {
            this.isSimulation = false;
        }
    }
    
    handleRecordSelect(event){
        this.selectedPeriodId = event.detail.recordId;
    }

    handleSimulationSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        createSimulation({ recordData : fields })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Simulation Created!',
                    variant: 'success'
                })
            );
            this.navigateTo(
                'dmpl__IncentivePeriod__c', 
                result);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating simulation',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
        
    }

    handleOkay(event){
        if(this.isSimulation) {
            
            this.template.querySelector('lightning-button').click();
            // this.template.querySelector('lightning-record-edit-form').submit();
            // this.template.querySelector('lightning-record-edit-form').submit();
        }else {
            this.processIncetive();
        }
    }

    processIncetive(){
        processCompensation({ periodId: this.selectedPeriodId })
        .then(result => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Processing Submitted!',
                    variant: 'success'
                })
            );
            this.navigateTo(
                'dmpl__IncentivePeriod__c', 
                this.selectedPeriodId);
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error processing incentive.',
                    message: error.body.message,
                    variant: 'error'
                })
            );
        });
    }

    navigateTo(objectApiName, recordId){
        let viewPageRef = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: objectApiName,
                recordId : recordId,
                actionName: 'view'
            }
        };
        this[NavigationMixin.Navigate](viewPageRef);
    }
}