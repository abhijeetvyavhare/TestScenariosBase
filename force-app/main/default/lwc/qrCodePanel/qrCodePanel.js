import { LightningElement, api, wire} from 'lwc';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import qrcode from './qrcode.js';

export default class QrCodePanel extends LightningElement {
    valueInternal;
    
    @api objectApiName;
    @api recordId;
    @api recordFieldsetName;
    @api showQrCode;

    @api
    get value() {
        return this.valueInternal;
    }

    set value(value) {
       this.valueInternal = value;
       this.renderQRCode();
    }
    
    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$recordFieldsetName' })
    fieldsetFields;
    
    get getFieldsetFields(){
        if(this.fieldsetFields && this.fieldsetFields.data){
            return this.fieldsetFields.data;
        }    
    }

    renderedCallback() {
        this.renderQRCode();
   }

   renderQRCode(){
       if(this.valueInternal == undefined || !this.showQrCode){
           return;
       }
        const qrCodeGenerated = new qrcode(0, 'H');
        qrCodeGenerated.addData(this.valueInternal);
        qrCodeGenerated.make();
        let element = this.template.querySelector('div');
        //let element = this.template.querySelector("qrcode2");
        if(element){
            element.innerHTML = qrCodeGenerated.createSvgTag({});
        }
   }
}