import { LightningElement, api, wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { RefreshEvent } from 'lightning/refresh';
import getAllImages from '@salesforce/apex/ItemIamgeController.getAllItemWithImages';
import getImage from '@salesforce/apex/ItemIamgeController.getImage';

export default class ProductCatalogView extends LightningElement {
    @api recordId;
    @api objectApiName;
    @api title;
    selectOptions=[];
    maps=[];
    @track imageUrl;
    downloadUrl;

    error;
    selectedImage;
    detail;
    columns = [
        { label: 'Component', fieldName: 'Name', type: 'text'},
        { label: 'Qty', fieldName: 'Qauntity', type: 'text' },
    ];
        
    handleMap(e){
        var itemId = e.target.dataset.item;
        e.preventDefault();
        
        var items=this.maps.filter(m=>m.Id==itemId);
        if(items!=undefined)
        {
            var item=items[0];
            if(item.LinkUrl__c!=undefined)
            {
                var win = window.open(item.LinkUrl__c, '_blank');
                win.focus();
            }
            else
            {
                this.detail=item.Detail__c;
            }
        }
    };

    @wire(getAllImages)
    lists({ error, data }) {
        if (data) {
            for(const list of data){
                const option = {
                    label: list.Name,
                    value: list.Id
                };
                this.selectOptions = [ ...this.selectOptions, option ];
            }
            this.selectedImage = this.selectOptions.find(v=> v.value == 'a1C1y000000Wb6uEAC')?.value;
            this.handleImageChange({detail : {value : this.selectedImage}});
        } else if (error) {
            console.error(error);
        }
        this.isLoaded=true;
    }

    handleImageChange(e)
    {
        getImage({id: e.detail.value})
        .then((data,error) => {
            if (data) {
                this.imageUrl=data.PublicUrl;
                this.downloadUrl=data.DownloadableUrl;
                this.maps = data.Details?.map(v => 
                    {
                         return { 
                        Id : v.Id,
                        Coordinate__c : v.dmpl__Coordinate__c,
                        Shape__c : v.dmpl__Shape__c, 
                        LinkUrl__c : v.dmpl__LinkUrl__c,
                        Detail__c : v.dmpl__Detail__c,
                        ComponentItemId__c : v.dmpl__ComponentItemId__c,
                        Name : v.dmpl__ComponentItemId__r?.Name,
                        ItemComponentId__c : v.dmpl__ItemComponentId__c,
                        ItemComponentName: v.dmpl__ItemComponentId__r?.Name,
                        Qauntity : 1
                    }});
                console.log(JSON.stringify(data));
            } else if (error) {
                this.error = error;
                console.log('Error:'+ JSON.stringify(error));
                this.isLoaded=true;
            }
        });
    }

    connectedCallback(){
        this.selectedImage = this.selectOptions.find(v=> v.value == 'a1C1y000000Wb6uEAC')?.value;
        this.handleImageChange({detail : {value : this.selectedImage}});
    }
    
    handleDialogClose() {
        //refreshApex(this.configurableItemsValue);
        //refreshApex(this.configurableComponentsValue);
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    async handleSave(){
        try{
            const result = null;//await applyPackageConfiguration({objectApiName : this.objectApiName, recordId : this.selectedLineId, componentSettings: this.draftValues});
            var messsage= `Package Configuration applied created successfully.`;
            //refreshApex(this.configurableItemsValue);
            //refreshApex(this.configurableComponentsValue);
            notifyRecordUpdateAvailable([{"recordId": this.recordId}]);
            this.refreshStdComponents();
            this.dispatchEvent(new CloseActionScreenEvent());
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: messsage,
                    variant: 'success',
                }),
            );
        } catch(error) {
           this.dispatchEvent(
               new ShowToastEvent({
                   title: 'Error updating or refreshing records',
                   message: error?.body?.message,
                   variant: 'error'
               })



            );
        };
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

}