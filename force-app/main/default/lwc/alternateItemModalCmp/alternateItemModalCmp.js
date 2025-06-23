import { LightningElement, api } from "lwc";

const CSS_CLASS = 'modal-hidden';

export default class AlternateItemModalCmp extends LightningElement {

    showModal = false;
    @api alternateItems;
    @api columns;
    @api maxRowSelection;
    @api preselectedRows = [];
    @api keyField = "id";
    @api hideSelectionColumn = false;


    @api set header(value) {
        this.hasHeaderString = value !== "";
        this._headerPrivate = value;
    }

    get header() {
        return this._headerPrivate;
    }

    hasHeaderString = false;
    _headerPrivate;

    @api setColumns(stringColumnsData) {
        this.columns = JSON.parse(stringColumnsData);
    }

    @api setAlternateItems(stringData) {
        this.alternateItems = JSON.parse(stringData);
    }

    @api setPreSelectedRows(stringData) {
        this.preselectedRows = JSON.parse(stringData);
    }

    @api show() {
        this.showModal = true;
    }

    @api hide() {
        this.showModal = false;
    }

    @api getSelectedRecords() {
        return this.template.querySelector('lightning-datatable').getSelectedRows();
    }

    handleDialogClose() {
        //Let parent know that dialog is closed (mainly by that cross button) so it can set proper variables if needed
        const closedialog = new CustomEvent("closedialog");
        this.dispatchEvent(closedialog);
        this.hide();
    }

    handleSlotTaglineChange() {
        const taglineEl = this.template.querySelector("p");
        taglineEl.classList.remove(CSS_CLASS);
    }

    handleSlotFooterChange() {
        const footerEl = this.template.querySelector("footer");
        if(footerEl && footerEl.classList){
            footerEl.classList.remove(CSS_CLASS);
        }
    }
}