import { LightningElement, api } from 'lwc';
import { classSet } from 'c/utils';
import { isSmall, isLarge, isDesert } from './utils';
import templateDesert from './NoDataDesert.html';
import templateOpenRoad from './NoDataOpenRoad.html';
import templateError from './NoDataError.html';
import { reduceErrors } from 'c/utils';

export default class IllustrationNoDataDesert extends LightningElement {
    @api message;
    @api errors;
    @api size='small';
    @api view='desert';
    errorTitle = 'Errors occured while processing the request. If problem persists contact support!'
    viewDetails;
    
    get errorMessages() {
        return reduceErrors(this.errors);
    }

    render() {
        return this.errors ? templateError : isDesert(this.view) ? templateDesert : templateOpenRoad;
    }

    get computedWrapperClassNames() {
        return classSet('slds-illustration').add({
            'slds-illustration_small': isSmall(this.size),
            'slds-illustration_large': isLarge(this.size)
        });
    }

    handleShowDetailsClick(){
        this.viewDetails = !this.viewDetails;
    }
}