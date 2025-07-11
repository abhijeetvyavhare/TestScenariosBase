import { LightningElement, wire, api } from 'lwc';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import { RefreshEvent } from 'lightning/refresh';

export default class FilterPanel extends LightningElement {
    @api title;
    @api objectApiName;
    @api recordFieldsetName;
    privateDefaultFieldValues;

    @api
    get defaultFieldValues() {
        return this.privateDefaultFieldValues;
    }
    set defaultFieldValues(value) {
        this.privateDefaultFieldValues = value;
        this.setAttribute('defaultFieldValues', this.privateDefaultFieldValues);
        this.populateDefaultValues();
    }

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$recordFieldsetName' })
    fieldsetFields;


    get getFieldsetFields(){
        if(this.fieldsetFields && this.fieldsetFields.data){
            return this.fieldsetFields.data;
        }    
    }

    get isLoaded(){
        return (this.fieldsetFields.data || this.fieldsetFields.error);
    }

    get isSubmitDisabled(){
        return (!this.fieldsetFields);
    }

    populateDefaultValues(fireChange){
        if(!this.privateDefaultFieldValues){
            return;
        }
        this.privateDefaultFieldValues.split(',').forEach(p=>
        {
            if(p){
                const nvPair = p.split("|");
                if(nvPair.length ==2){
                    this.setDefaultValue(nvPair[0], nvPair[1], fireChange);
                }    
            }
        }
        );
    }

    setDefaultValue(name, value, fireChange){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if (field.fieldName == name &&
                    field.value != value) {
                    field.value = value;
                    if(fireChange){
                        this.fireFilterChangeEvent(name, value);
                    }
                    return;
                }
            });
        }
    }
    
    async handleSuccess(event){
        var recordId = event.detail?event.detail.id:undefined;
        var messsage= recordId? `Document \'${recordId}\' created successfully.`:'Record created successfully.';
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: messsage,
                variant: 'success',
            }),
        );
        this.handleReset();
        notifyRecordUpdateAvailable([{"recordId": recordId}]);
        this.refreshStdComponents();
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    handleLoad(){
        this.handleReset(true);
    }

    handleError(event){
        console.log(event.detail);
    }
    
    handleReset(skipReset) {
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        const fsField = this.getFieldsetFields && this.getFieldsetFields.length >0 ? this.getFieldsetFields[0]:undefined;
        if (inputFields) {
            inputFields.forEach(field => {
                if((!skipReset)) {
                    field.reset();
                }
            });
        }
    }

    handleFieldChange(event){
        if((!event.target) || (!event.target.id))
            return;
        const target = event.target.id.slice(0, event.target.id.lastIndexOf('-'));
        var value = undefined;
        if(event.detail.value){
            if(Array.isArray(event.detail.value) && Array.from(event.detail.value).length>0){
                value = event.detail.value[0];
            }else if(!(typeof event.detail.value === 'object')){
                value = event.detail.value;
            }
        }else if ('checked' in event.detail){
            value = event.detail.checked;
        }
        this.fireFilterChangeEvent(target, value);
    }

    fireFilterChangeEvent(name, value) {
        const filters = {
            name: name,
            value: value
        };
        this.dispatchEvent(new CustomEvent('filterchanged', { "detail":filters }));
    }
}