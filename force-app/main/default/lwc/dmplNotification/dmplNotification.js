import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import LightningAlert from 'lightning/alert';
import LightningConfirm from 'lightning/confirm';
import { updateRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class DmplNotification extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api message;
    @api messageFieldName;
    @api variant;
    @api isBlink;
    @api promptHeader;
    @api notificationStyle;
    @api popupTheme;
    @api promptField;

    recordFields = [];

    @wire(getRecord, { recordId: '$recordId', fields: '$getRecordFields' })
    wiredRecord;

    get isTile(){
        return this.notificationStyle == 'tile';
    }

    get isPrompt(){
        return this.notificationStyle == 'prompt';
    }

    get getRecordFields(){
        return [this.objectApiName + '.' + this.messageFieldName];
    }

    get getCardStyleCss(){
        return 'slds-scoped-notification slds-media slds-media_center slds-theme_' + this.variant;
    }

    get getBodyStyleCss(){
        return 'slds-media__body ' + this.isBlink ? 'dmpl-blink' : '';
    }

    get getIcon(){
        return "utility:" + this.variant;
    }

    get getMessage(){
        return (this.messageFieldName)? 
        this.getRecordMessage : this.message;
    }

    get getRecordMessage(){
        if(this.wiredRecord.data){
            return this.wiredRecord.data.fields[this.messageFieldName]?.value;
        }
        return null;
    }

    connectedCallback(){
        if(!this.notificationStyle){
            this.notificationStyle = 'tile';
        }
        if(this.notificationStyle == 'prompt'){
            LightningPrompt.open({
                variant: this.variant,
                message: this.getMessage,
                theme: this.popupTheme,
                label: this.promptHeader,
            }).then((result) => {
                this.updateResult(result);
                //Prompt has been closed
                //result is input text if OK clicked
                //and null if cancel was clicked
            });
        }
        if(this.notificationStyle == 'confirm'){
            const result = LightningConfirm.open({
                message: this.getMessage,
                variant: this.variant,
                theme: this.popupTheme,
                label: this.promptHeader,
            }).then((result) => {
                this.updateResult(result);
                //Confirm has been closed
                //result is true if OK was clicked
                //and false if cancel was clicked
            });

        }
        if(this.notificationStyle == 'alert'){
            LightningAlert.open({
                message: this.getMessage,
                variant: this.variant,
                theme: this.popupTheme, // a red theme intended for error states
                label: this.promptHeader, // this is the header text
            });
            this.updateResult('OK');
            //Alert has been closed
        }

        if(this.notificationStyle == 'toast'){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: this.promptHeader,
                    message: this.getMessage,
                    variant: this.variant
                })
            );
        }
    }

    updateResult(result){
        if(!this.promptField){
            return;
        }
        const fields = {};
        fields[this.promptField] = result;
        fields['Id'] = this.recordId;
        const recordInput = { fields };
        updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Updated successfully!',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error updating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}