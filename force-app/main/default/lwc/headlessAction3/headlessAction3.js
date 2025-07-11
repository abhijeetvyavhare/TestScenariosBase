import { LightningElement, api, wire } from 'lwc';
import callHeadlessAction from '@salesforce/apex/HeadlessCallableController.callHeadlessAction';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { RefreshEvent } from 'lightning/refresh';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { reduceErrors } from 'c/utils';

export default class headlessAction3 extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api actionName;
    
    @api invoke() {
        callHeadlessAction(
            {
                actionName : this.actionName,
                objectApiName : this.objectApiName,
                recordId : this.recordId
            })
            .then(headlessActionResult=>
                {
                    if(headlessActionResult && headlessActionResult.result){
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Success',
                                message: headlessActionResult.message 
                                ? headlessActionResult.message : 'Executed Successfully!',
                                variant: 'success'
                            }),
                        );
                        this.refreshPage();    
                    }else{
                        this.dispatchEvent(
                            new ShowToastEvent({
                                title: 'Error',
                                mode : 'sticky',
                                message: headlessActionResult.message 
                                ? headlessActionResult.message : 'Execution Failed!',
                                variant: 'error'
                            }),
                        );
                    }
                })
            .catch(error=>{
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        mode : 'sticky',
                        message: reduceErrors(error),
                        variant: 'error'
                    }),
                );
                this.refreshPage();
            });
      }

    connectedCallback(){
        if(!this.actionName){
            this.actionName = 'headlessAction3';
        }
    }

    refreshPage(){
        notifyRecordUpdateAvailable([{ "recordId": this.recordId }]);
        this.refreshStdComponents();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }
}