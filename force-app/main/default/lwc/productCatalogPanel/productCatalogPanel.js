import { LightningElement, api, wire,track } from 'lwc';
import getAllImages from '@salesforce/apex/ItemIamgeController.getAllItemWithImages';
import getImage from '@salesforce/apex/ItemIamgeController.getImage';

export default class ProductCatalogPanel extends LightningElement {
    @api recordId;
    
    selectOptions=[];
    maps=[];
    @track imageUrl;
    downloadUrl;
    error;
    selectedImage;
    detail;
    
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
                this.maps = data.Details;
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
}