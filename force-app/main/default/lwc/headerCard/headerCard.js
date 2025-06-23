import { LightningElement, api, track } from 'lwc';
import { classSet } from 'c/utils';
import { isNarrow, isBase } from './utils';
import { NavigationMixin } from 'lightning/navigation';
import FORM_FACTOR from '@salesforce/client/formFactor';
/**
 * @slot Content-Region
*/
export default class headerCard extends NavigationMixin(LightningElement) {
    @api title;
    @api iconName;
    @api showPageHeader;
    @api showHeaderBorder = false;
    @api showFooter = false;
    @api hideBodyMargin = false;
    @api navObjectApiName;
    @api navRecordId;
    @api viewStyle = 'page';

    @track privateVariant = 'base';

    showContent = true;

    set variant(value) {
        if (isNarrow(value) || isBase(value)) {
            this.privateVariant = value;
        } else {
            this.privateVariant = 'base';
        }
    }

    set isCollapsed(value) {
        this.showContent = value?false:true;
    }
    
    @api get isCollapsed() {
        return this.showContent?false:true;
    }

    @api get variant() {
        return this.privateVariant;
    }

    get computedWrapperClassNames() {
        return classSet('slds-card').add({
            'slds-card_boundary': true,
            'slds-card_narrow': isNarrow(this.privateVariant)
        });
    }
    
    get computedHeaderClassNames() {
        if(this.viewStyle == 'card'){
            return classSet('slds-grid').add({
                'slds-card__header': this.showPageHeader,
            });    
        }else{
            return classSet('slds-grid').add({
                'slds-page-header': this.showPageHeader && this.title,
                'dmpl-page-header': this.showHeaderBorder && this.isCollapsed!=true,
            });    
        }
    }
    
    get computedBodyClassNames() {
        return classSet('slds-card__body').add({
            'dmpl-card__body': this.hideBodyMargin
        });
    }

    get hasIcon() {
        return !!this.iconName;
    }

    get hasStringTitle() {
        return !!this.title;
    }

    get hasNavigation(){
        return this.navObjectApiName && this.navRecordId;
    }

    get isMobileView(){
        return FORM_FACTOR == 'Small';
    } 

    handleTitleClick(evt){
        evt.preventDefault();
        evt.stopPropagation();
        if(!this.hasNavigation){
            return;
        }
        let viewPageRef = {
            type: 'standard__recordPage',
            attributes: {
                objectApiName: this.navObjectApiName,
                recordId : this.navRecordId,
                actionName: 'view'
            }
        };
        this[NavigationMixin.Navigate](viewPageRef);
    }
}