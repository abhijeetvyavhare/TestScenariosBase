import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord, updateRecord, notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getTemplate from '@salesforce/apex/ChecklistController.getChecklistTemplates';
import getChecklistLines from '@salesforce/apex/ChecklistController.getChecklistLines';
import uploadFile from '@salesforce/apex/ChecklistController.uploadFile'
import FORM_FACTOR from '@salesforce/client/formFactor';

export default class ChecklistPanel extends NavigationMixin(LightningElement) {
    @api title;
    @api objectApiName; 
    @api recordId;
    
    templateId;
    templateData;

    @wire(getRecord, { recordId: '$recordId', fields: '$getRecordFields' })
    wiredRecord({ error, data }) {
        if(data){
            this.templateId = data.fields.dmpl__ChecklistTemplateId__c?.value;
        }
    }

    @wire(getTemplate, { templateId : '$templateId' })
    wiredTemplate({error, data}){
        if (data && data.length > 0) {
            let lineNumber = 0;
            let lines = data[0].dmpl__CheckList_Template_Lines__r?.map(v=>{ 
                let g = Object.assign({}, v);
                g.dmpl__GroupBy__c = g.dmpl__GroupBy__c ? g.dmpl__GroupBy__c : 'General';
                return g
            });
            let groups = [...new Set(lines.filter(v=>v.dmpl__GroupBy__c).map(m => m.dmpl__GroupBy__c))]; 
            this.templateData = groups.map((groupByName) => {
                let isExpanded = true;
                lineNumber += 1;
                return {
                    groupBy : groupByName,
                    lineSequence : lineNumber,
                    contentClass : isExpanded ? 'slds-summary-detail slds-is-open' : 'slds-summary-detail',
                    isExpanded : isExpanded,
                    records : lines.filter(v=>v.dmpl__GroupBy__c == groupByName).map(l=>{
                        let isPicklist = l.PicklistValues__c != undefined;
                        let record = {
                            id : l.Id,
                            name : l.Name,
                            isBoolean : (!isPicklist) && l.dmpl__DataType__c == 'Boolean',
                            isText : (!isPicklist) && l.dmpl__DataType__c == 'Text',
                            isNumeric : (!isPicklist) && l.dmpl__DataType__c == 'Numeric',
                            isDate : (!isPicklist) && l.dmpl__DataType__c == 'Date',
                            isDecimal : (!isPicklist) && l.dmpl__DataType__c == 'Decimal',
                            isCurrency : (!isPicklist) && l.dmpl__DataType__c == 'Currency',
                            isDateTime : (!isPicklist) && l.dmpl__DataType__c == 'DateTime',
                            isTime : (!isPicklist) && l.dmpl__DataType__c == 'Time',
                            isRAG : (!isPicklist) && l.dmpl__DataType__c == 'RAG',
                            isPhone : (!isPicklist) && l.dmpl__DataType__c == 'Phone',
                            isURL : (!isPicklist) && l.dmpl__DataType__c == 'URL',
                            isEmail : (!isPicklist) && l.dmpl__DataType__c == 'Email',
                            isPhoto : (!isPicklist) && l.dmpl__DataType__c == 'Take Picture',
                            isPicklistValue : isPicklist,
                            picklistValues : l.PicklistValues__c?.split(',').map(v=>
                                {return  { label: v, value: v }})
                        }
                        if(this.checklistLinesData){
                            let r = this.checklistLinesData.find(a=> l.Id == a.dmpl__CheckListTemplateLineId__c);
                            if(r){
                                this.setValue(r,record);
                            }
                        }
                        return record;
                    })
                }
            })
        }
    }

    @wire(getChecklistLines,{parentFieldName : '$getParentFieldName', parentRecordId : '$recordId'})
    wiredChecklistLines({error, data}){
        if(data){
            this.checklistLinesData = data;
            if(this.templateData){
                this.templateData.forEach(g=> {
                    g.records = g.records.map(v=>{
                        let l = Object.assign({}, v);
                        let r = data.find(a=> v.id == a.dmpl__CheckListTemplateLineId__c);
                        if(r){
                            l.lineRecordId  = r.Id; 
                            this.setValue(r,l);
                        }
                        return l;
                    })});
                this.templateData = this.templateData.slice();
            }
        }
    }

    get getRecordFields(){
        return [this.objectApiName + '.' + 'dmpl__ChecklistTemplateId__c'];
    }
    
    get getParentFieldName(){
        return this.objectApiName == 'dmpl__VisitTaskActivity__c' ? 'dmpl__VisitTaskActivityId__c' : 
            'dmpl__DeliveryOrder__c' ? 'dmpl__DeliveryOrderId__c' :
            'dmpl__GoodsReceipt__c' ? 'dmpl__GoodsReceiptId__c' :
            'dmpl__InspectionLine__c' ? 'dmpl__InspectionLineId__c' :
            'dmpl__RepairOrder__c' ? 'dmpl__RepairOrderId__c' :
            'dmpl__ServiceRequest__c' ? 'dmpl__ServiceRequestId__c' :
            'dmpl__Visit__c' ? 'dmpl__VisitId__c' :
            this.objectApiName.replace('__c', 'Id__c');
    }

    get isMobileView(){
        return FORM_FACTOR == 'Small';
    } 
    
    setValue(source, destination){
        if(destination.isBoolean){
            destination.booleanValue = source.dmpl__BooleanValue__c;
        }else if(destination.isText || source.isPicklistValue){
            destination.textValue = source.dmpl__TextValue__c;
        }else if(destination.isDecimal){
            destination.decimalValue = source.dmpl__DecimalValue__c;
        }else if(destination.isNumeric){
            destination.numericValue = source.dmpl__NumericValue__c;
        }else if(destination.isDate){
            destination.dateValue = source.dmpl__DateValue__c;
        }else if(destination.isDateTime){
            destination.dateTimeValue = source.dmpl__DateTimeValue__c;
        }else if(destination.isTime){
            destination.timeValue = source.dmpl__TimeValue__c;     
        }else if(destination.isCurrency){
            destination.currencyValue = source.dmpl__CurrencyValue__c;
        }else if(destination.isRAG){
            destination.ragValue = source.dmpl__RAGValue__c;
        }else if(destination.isPhone){
            destination.ragValue = source.dmpl__Phone__c;
        }else if(destination.isURL){
            destination.ragValue = source.dmpl__URL__c;
        }else if(destination.isEmail){
            destination.ragValue = source.dmpl__Email__c;
        }
    }

    handleTextChange(event){
        let taskId = event.target.dataset.recordId;
        let value = event.target.value
        this.postValue(taskId, 'dmpl__TextValue__c', value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleNumericChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__NumericValue__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleBooleanChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__BooleanValue__c', event.target.checked, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleDecimalChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__DecimalValue__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleDateChange(event){
        let taskId = event.target.dataset.recordId;
        let dateValue = new Date(event.target.value);
        this.postValue(taskId, 'dmpl__DateValue__c', dateValue, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleDateTimeChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__DateTimeValue__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleTimeChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__TimeValue__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleCurrencyChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__CurrencyValue__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }
    
    handlePhoneChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__Phone__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }
    
    handleUrlChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__URL__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    handleEmailChange(event){
        let taskId = event.target.dataset.recordId;
        this.postValue(taskId, 'dmpl__Email__c', event.target.value, true);
        this.toggleTaskPanel(taskId, true);
    }

    async handleUploadFinished(event) {
        this.isLoading = true;
        try {
            let taskId = event.target.dataset.recordId;
            const file = event.target.files[0]
            var reader = new FileReader()
            reader.onload = () => {
                const {base64, filename, recordId} = {
                    'filename': file.name,
                    'base64': reader.result.split(',')[1],
                    'recordId': taskId
                }
                uploadFile({ base64, filename, recordId }).then(result=>{
                    this.showSuccess('Success', `${filename} uploaded successfully!!`);
                    this.postValue(taskId, 'dmpl__TextValue__c', file.name, true);
                    this.isLoading = false;
                }).catch(error =>{
                    this.isLoading = false;
                    this.showError(error);
                });
            }
            reader.readAsDataURL(file)   
        } catch (error) {
            this.isLoading = false;
        }
    }
    
    handleExpandClick(event){
        this.toggleTaskPanel(event.target?.name);
    }

    postValue(recordId, fieldName, fieldValue, forceRefresh){
        let lineRecord = this.checklistLinesData.find(a=> a.dmpl__CheckListTemplateLineId__c == recordId);
        if(lineRecord){
            this.updateFieldValue(lineRecord.Id, fieldName, fieldValue, forceRefresh);
        }else{
            this.createFieldValue(recordId, fieldName, fieldValue, forceRefresh);
        }
    }

    updateFieldValue(recordId, fieldName, fieldValue, forceRefresh){
        const fields = {};
        fields['Id'] = recordId;
        fields[fieldName] = fieldValue;
        const recordInput = { fields };
        updateRecord(recordInput).then(async() => {
            if(forceRefresh){
                refreshApex(this.wiredVisitTasks);
                await notifyRecordUpdateAvailable([{recordId: recordId}]);    
            }
            //this.showSuccess();
        }).catch(error => {
            this.showError(error);
        });
    }
    
    createFieldValue(recordId, fieldName, fieldValue, forceRefresh){
        const fields = {};
        fields[fieldName] = fieldValue;
        fields['dmpl__CheckListTemplateLineId__c'] = recordId;
        fields['dmpl__ChecklistTemplateId__c'] = this.templateId;
        fields[this.getParentFieldName] = this.recordId;
        // dmpl__BranchId__c
        // dmpl__PartnerAccountId__c
        const recordInput = { 
            apiName : 'dmpl__CheckListLines__c',
            fields };
        createRecord(recordInput).then(async() => {
            if(forceRefresh){
                refreshApex(this.wiredVisitTasks);
                await notifyRecordUpdateAvailable([{recordId: recordId}]);    
            }
            this.showSuccess();
        }).catch(error => {
            this.showError(error);
        });
    }

    showSuccess(message, title){
        this.dispatchEvent(
            new ShowToastEvent({
                title: title ? title : 'Success',
                message: message ? message : 'Data updated',
                variant: 'success'
            })
        );
    }

    showError(error){
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error updating record',
                message: error?.body?.message,
                variant: 'error'
            })
        );
    }

    toggleTaskPanel(groupName, forceExpand){
        this.templateData.forEach(v=>{
            if(v.groupBy == groupName){
                v.isExpanded = forceExpand == undefined ? (!v.isExpanded) : forceExpand ? forceExpand : false;
            }else if(this.isMobileView){
                v.isExpanded = false;
            }
            v.contentClass = v.isExpanded ? 'slds-summary-detail slds-is-open' : 'slds-summary-detail';
        });
        this.templateData = this.templateData.slice();
    }
}