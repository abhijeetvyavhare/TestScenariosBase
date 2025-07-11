import { api, LightningElement } from 'lwc';

export default class DmplCard extends LightningElement {
    @api selectable;
    @api showMrp;
    @api showType;
}