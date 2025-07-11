import { LightningElement, api } from 'lwc';
import performAction from '@salesforce/apex/InterfaceServiceProviderController.performAction';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/utils';

export default class InterfacePanelHeadless extends LightningElement {
    
    @api recordId;
    

    @api invoke() {
        performAction(
            {
                queueId : this.recordId
            })
            .then(result=>
                {
                    this.dispatchEvent(
                        new ShowToastEvent({
                            title: 'Success',
                            message: 'Executed Successfully!',
                            variant: 'success'
                        }),
                    );
                    this.refreshPage();
                })
            .catch(error=>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: reduceErrors(error),
                        variant: 'error'
                    }),
                );
                this.refreshPage();
            });
            
      }

      refreshPage(){
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
      }
}