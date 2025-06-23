import { LightningElement, api } from 'lwc';

export default class DmplTile extends LightningElement {

    @api navigationUrl="#";
    @api showAvatar;
    @api avatarIconName = "utility:serialized_product";
    @api title;
    @api heading;
    @api subHeading;
    @api leftTopValue;
    @api leftTopLabel;
    @api rightTopValue;
    @api rightTopLabel;
    @api leftBottomValue;
    @api leftBottomLabel;
    @api rightBottomValue;
    @api rightBottomLabel;

    get computedBorderClassNames() {
        return this.showAvatar?'slds-border_left':'';
    }
    get showLeftTop() {
        return this.leftTopLabel || this.leftTopValue;
    }
    get  showRightTop() {
        return this.rightTopLabel || this.rightTopValue;
    }
    get  showLeftBottom() {
        return this.leftTopLabel || this.leftTopValue;
    }
    get  showRightBottom() {
        return this.rightBottomLabel || this.rightBottomValue;
    }

}