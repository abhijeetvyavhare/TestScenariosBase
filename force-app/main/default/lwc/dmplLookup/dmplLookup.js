import { LightningElement, api, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';

const SEARCH_DELAY = 300; // Wait 300 ms after user stops typing then, peform search

const KEY_ARROW_UP = 38;
const KEY_ARROW_DOWN = 40;
const KEY_ENTER = 13;

const VARIANT_LABEL_STACKED = 'label-stacked';
const VARIANT_LABEL_INLINE = 'label-inline';
const VARIANT_LABEL_HIDDEN = 'label-hidden';

const REGEX_SOSL_RESERVED = /(\?|&|\||!|\{|\}|\[|\]|\(|\)|\^|~|\*|:|"|\+|-|\\)/g;
const REGEX_EXTRA_TRAP = /(\$|\\)/g;

export default class Lookup extends NavigationMixin(LightningElement) {
    // Public properties
    //columns = columns;
    @api variant = VARIANT_LABEL_STACKED;
    @api label = '';
    @api required = false;
    @api disabled = false;
    @api placeholder = '';
    @api isMultiEntry = false;
    @api scrollAfterNItems = null;
    @api newRecordOptions = [];
    @api minSearchTermLength = 2;
    @api name;

    // Template properties
    searchResultsLocalState = [];
    searchResultsTable =[];
    loading = false;
    showPopup = false;
    selectColumn = { label: 'Select?', fieldName: 'isSelected', type: 'checkButton', initialWidth: 75, hideLabel: true, hideDefaultActions: true, typeAttributes: { rowId: { fieldName: 'id' } } };
    comonColumns = [
        { label: 'Title', fieldName: 'title', hideDefaultActions: true},
        { label: 'Sub Title', fieldName: 'subtitle', hideDefaultActions: true}
    ]
    resultColumns =[this.selectColumn, this.comonColumns[0], this.comonColumns[1]];

    // Private properties
    _errors = [];
    _hasFocus = false;
    _isDirty = false;
    _searchTerm = '';
    _cleanSearchTerm;
    _cancelBlur = false;
    _searchThrottlingTimeout;
    _searchResults = [];
    _defaultSearchResults = [];
    _curSelection = [];
    _focusedResultIndex = null;

    _selectedRecordId = '';
    _selectedRecordName = '';
    _fieldNames = [];

    @wire(getRecord, { recordId: '$_selectedRecordId', fields: '$_fieldNames' })
    wiredRecord({ error, data }){
        if(data){
            this._selectedRecordName = data.fields.Name.value;
        }else if(error){
            console.error(error);
        }
    };

    // PUBLIC FUNCTIONS AND GETTERS/SETTERS
    @api
    set selection(initialSelection) {
        const newSelection = Array.isArray(initialSelection) ? initialSelection : [initialSelection];
        if(this._curSelection.length == 1 && newSelection.length ==1 && this._curSelection[0].id == newSelection[0].id){
            return;
        }
        if(newSelection.length == 1 && newSelection[0].id != null && newSelection[0].title == null){
            this._selectedRecordId = newSelection[0].id;
        }else{
            this._selectedRecordId = '';
        }
        this._curSelection = newSelection;
        this.processSelectionUpdate(false);
    }

    get selection() {
        return this._curSelection;
    }

    @api
    set errors(value) {
        this._errors = value;
        // Blur component if errors are passed
        if (this._errors?.length > 0) {
            this.blur();
        }
    }

    get errors() {
        return this._errors;
    }

    @api setSearchCoulmns(columns){
        this.searchColumns = columns;
        if(this.searchColumns && Array.from(this.searchColumns).length>0){
            this.resultColumns = [this.selectColumn].concat(this.searchColumns);
        }else{
            this.searchColumns = null;
            this.resultColumns = [this.selectColumn].concat(this.comonColumns);
        }
    }

    @api
    setSearchResults(results) {
        this.searchResults = results;
        // Reset the spinner
        this.loading = false;
        // Clone results before modifying them to avoid Locker restriction
        let resultsLocal = JSON.parse(JSON.stringify(results));
        // Remove selected items from search results
        const selectedIds = this._curSelection.map((sel) => sel.id);
        resultsLocal = resultsLocal.filter((result) => selectedIds.indexOf(result.id) === -1);
        // Format results
        const cleanSearchTerm = this._searchTerm.replace(REGEX_SOSL_RESERVED, '.?').replace(REGEX_EXTRA_TRAP, '\\$1');
        const regex = new RegExp(`(${cleanSearchTerm})`, 'gi');
        this._searchResults = resultsLocal.map((result) => {
            // Format title and subtitle
            if (this._searchTerm.length > 0) {
                result.titleFormatted = result.title
                    ? result.title.replace(regex, '<strong>$1</strong>')
                    : result.title;
                result.subtitleFormatted = result.subtitle
                    ? result.subtitle.replace(regex, '<strong>$1</strong>')
                    : result.subtitle;
            } else {
                result.titleFormatted = result.title;
                result.subtitleFormatted = result.subtitle;
            }

            // Add icon if missing
            if (typeof result.icon === 'undefined') {
                result.icon = 'standard:default';
            }
            return result;
        });
        // Add local state and dynamic class to search results
        this._focusedResultIndex = null;
        const self = this;
        if(results == this._defaultSearchResults){
            this.setSearchCoulmns(null);
        }
        this.searchResultsTable = this._searchResults.map(v=>
            {
                let row = Object.assign({}, v);
                row.isSelected = false;
                if(this.searchColumns && v.sourceObject){
                    this.searchColumns.forEach(c=>{
                        row[c.fieldName] = v.sourceObject[c.fieldName];
                    })
                }
                return row;
            }).slice();
        this.searchResultsLocalState = this._searchResults.map((result, i) => {
            return {
                result,
                state: {},
                get classes() {
                    let cls = 'slds-media slds-media_center slds-listbox__option slds-listbox__option_entity';
                    if (result.subtitleFormatted) {
                        cls += ' slds-listbox__option_has-meta';
                    }
                    if (self._focusedResultIndex === i) {
                        cls += ' slds-has-focus';
                    }
                    return cls;
                }
            };
        });
    }

    @api
    getSelection() {
        return this._curSelection;
    }

    @api
    setDefaultResults(results) {
        this._defaultSearchResults = [...results];
        //if (this._searchResults.length === 0) {
            this.setSearchResults(this._defaultSearchResults);
        //}
    }

    @api
    blur() {
        this.template.querySelector('input')?.blur();
    }

    @api
    clearSelection(){
        if(this._curSelection.length > 0){
            this.handleClearSelection();
        }
    }

    @api
    focus(){
        this.template.querySelector('input').focus();
    }
    // INTERNAL FUNCTIONS

    updateSearchTerm(newSearchTerm) {
        this._searchTerm = newSearchTerm;

        // Compare clean new search term with current one and abort if identical
        const newCleanSearchTerm = newSearchTerm.trim().replace(REGEX_SOSL_RESERVED, '?').toLowerCase();
        if (this._cleanSearchTerm === newCleanSearchTerm) {
            return;
        }

        // Save clean search term
        this._cleanSearchTerm = newCleanSearchTerm;

        // Ignore search terms that are too small after removing special characters
        if (newCleanSearchTerm.replace(/\?/g, '').length < this.minSearchTermLength) {
            this.setSearchResults(this._defaultSearchResults);
            return;
        }

        // Apply search throttling (prevents search if user is still typing)
        if (this._searchThrottlingTimeout) {
            clearTimeout(this._searchThrottlingTimeout);
        }
        // eslint-disable-next-line @lwc/lwc/no-async-operation
        this._searchThrottlingTimeout = setTimeout(() => {
            // Send search event if search term is long enougth
            if (this._cleanSearchTerm.length >= this.minSearchTermLength) {
                // Display spinner until results are returned
                this.loading = true;

                const searchEvent = new CustomEvent('search', {
                    detail: {
                        name:this.name,
                        searchTerm: this._cleanSearchTerm,
                        rawSearchTerm: newSearchTerm,
                        selectedIds: this._curSelection.map((element) => element.id)
                    }
                });
                this.dispatchEvent(searchEvent);
            }
            this._searchThrottlingTimeout = null;
        }, SEARCH_DELAY);
    }

    isSelectionAllowed() {
        if (this.isMultiEntry) {
            return true;
        }
        return !this.hasSelection();
    }

    hasSelection() {
        return this._curSelection.length > 0;
    }

    processSelectionUpdate(isUserInteraction) {
        // Reset search
        // this._cleanSearchTerm = '';
        // this._searchTerm = '';
        if(this.searchResults){
            this.setSearchResults([...this.searchResults]);
        }else{
            this.setSearchResults([...this._defaultSearchResults]);
        }
        // Indicate that component was interacted with
        this._isDirty = isUserInteraction;
        // Blur input after single select lookup selection
        if (!this.isMultiEntry && this.hasSelection()) {
            this._hasFocus = false;
        }
        // If selection was changed by user, notify parent components
        if (isUserInteraction) {
            const selectedIds = this._curSelection.map((sel) => sel.id);
            this.dispatchEvent(new CustomEvent('selectionchange', { detail: {selectedIds: selectedIds, name:this.name} }));
        }
    }

    // EVENT HANDLING
    connectedCallback() {
        this._fieldNames = [this.name + '.Name'];
    }

    handleInput(event) {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this.updateSearchTerm(event.target.value);
    }

    handleKeyDown(event) {
        if (this._focusedResultIndex === null) {
            this._focusedResultIndex = -1;
        }
        if (event.keyCode === KEY_ARROW_DOWN) {
            // If we hit 'down', select the next item, or cycle over.
            this._focusedResultIndex++;
            if (this._focusedResultIndex >= this._searchResults.length) {
                this._focusedResultIndex = 0;
            }
            event.preventDefault();
        } else if (event.keyCode === KEY_ARROW_UP) {
            // If we hit 'up', select the previous item, or cycle over.
            this._focusedResultIndex--;
            if (this._focusedResultIndex < 0) {
                this._focusedResultIndex = this._searchResults.length - 1;
            }
            event.preventDefault();
        } else if (event.keyCode === KEY_ENTER && this._hasFocus && this._focusedResultIndex >= 0) {
            // If the user presses enter, and the box is open, and we have used arrows,
            // treat this just like a click on the listbox item
            const selectedId = this._searchResults[this._focusedResultIndex].id;
            this.template.querySelector(`[data-recordid="${selectedId}"]`).click();
            event.preventDefault();
        }
    }

    handleResultClick(event) {
        //const recordId = event.currentTarget.dataset.recordid;
        let recordId = undefined;
        if(event.detail.selectedRows && event.detail.selectedRows.length>0){
            recordId = event.detail.selectedRows[0].id;
        }
        if(!recordId){
            recordId = event.currentTarget.dataset.recordid;
        }
        
        // Save selection
        const selectedItem = this._searchResults.find((result) => result.id === recordId);
        if (!selectedItem) {
            return;
        }
        const newSelection = [...this._curSelection];
        newSelection.push(selectedItem);
        this._curSelection = newSelection;

        // Process selection update
        this.processSelectionUpdate(true);
    }

    handleComboboxMouseDown(event) {
        const mainButton = 0;
        if (event.button === mainButton) {
            this._cancelBlur = true;
        }
    }

    handleComboboxMouseUp() {
        this._cancelBlur = false;
        // Re-focus to text input for the next blur event
        this.template.querySelector('input').focus();
    }

    handleFocus() {
        // Prevent action if selection is not allowed
        if (!this.isSelectionAllowed()) {
            return;
        }
        this._hasFocus = true;
        this._focusedResultIndex = null;
        this.dispatchEvent(new CustomEvent('focusacquired', { detail: {
            name:this.name
        } }));
    }

    handleBlur() {
        // Prevent action if selection is either not allowed or cancelled
        if (!this.isSelectionAllowed() || this._cancelBlur) {
            return;
        }
        this._hasFocus = false;
    }

    handleRemoveSelectedItem(event) {
        if (this.disabled) {
            return;
        }
        const recordId = event.currentTarget.name;
        this._curSelection = this._curSelection.filter((item) => item.id !== recordId);
        // Process selection update
        this.processSelectionUpdate(true);
    }

    handleClearSelection() {
        this._curSelection = [];
        this._hasFocus = false;
        this._selectedRecordId = '';

        //since commented the process selection upate serach keyword reset
        this._cleanSearchTerm = '';
        this._searchTerm = '';
        // Process selection update
        this.processSelectionUpdate(true);
    }
    
    handleSelectedRec(event) {
        if(event?.detail?.value?.state == true){
            // Save selection
            const selectedItem = this._searchResults.find((result) => result.id === event?.detail?.value?.rowId);
            if (!selectedItem) {
                return;
            }
            const newSelection = [...this._curSelection];
            newSelection.push(selectedItem);
            this._curSelection = newSelection;

            if(!this.isMultiEntry){
                // Process selection update
                this.processSelectionUpdate(true);
                this.handleCloseClick({});
            }else{
                setTimeout(()=>{
                    this.processSelectionUpdate(true);
                });
            }
        }else{
            const recordId = event?.detail?.value?.rowId;
            this._curSelection = this._curSelection.filter((item) => item.id !== recordId);
            // Process selection update
            this.processSelectionUpdate(true);
        }
    }

    handleNewRecordClick(event) {
        const objectApiName = event.currentTarget.dataset.sobject;
        const selection = this.newRecordOptions.find((option) => option.value === objectApiName);

        const preNavigateCallback = selection.preNavigateCallback
            ? selection.preNavigateCallback
            : () => Promise.resolve();
        preNavigateCallback(selection).then(() => {
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName,
                    actionName: 'new'
                },
                state: {
                    defaultFieldValues: selection.defaults
                }
            });
        });
    }

    handlePoupClick(event){
        this.showPopup = true;
    }

    handleCloseClick(event){
        this.showPopup = false;
    }
    
    // STYLE EXPRESSIONS

    get hasResults() {
        return this._searchResults.length > 0;
    }

    get getFormElementClass() {
        return this.variant === VARIANT_LABEL_INLINE
            ? 'slds-form-element slds-form-element_horizontal dmpl-lookup'
            : 'slds-form-element dmpl-lookup';
    }

    get getLabelClass() {
        return this.variant === VARIANT_LABEL_HIDDEN
            ? 'slds-form-element__label slds-assistive-text'
            : 'slds-form-element__label';
    }

    get getContainerClass() {
        let css = 'slds-combobox_container ';
        if (this._errors.length > 0) {
            css += 'has-custom-error';
        }
        return css;
    }

    get getDropdownClass() {
        let css = 'slds-combobox slds-dropdown-trigger slds-dropdown-trigger_click ';
        const isSearchTermValid = this._cleanSearchTerm && this._cleanSearchTerm.length >= this.minSearchTermLength;
        if (
            this._hasFocus &&
            this.isSelectionAllowed() &&
            (isSearchTermValid || this.hasResults || this.newRecordOptions?.length)
        ) {
            css += 'slds-is-open';
        }
        return css;
    }

    get getInputClass() {
        let css = 'slds-input slds-combobox__input has-custom-height ';
        if (this._hasFocus && this.hasResults) {
            css += 'slds-has-focus ';
        }
        if (this._errors.length > 0 || (this._isDirty && this.required && !this.hasSelection())) {
            css += 'has-custom-error ';
        }
        if (!this.isMultiEntry) {
            css += 'slds-combobox__input-value ' + (this.hasSelection() ? 'has-custom-border' : '');
        }
        return css;
    }

    get getComboboxClass() {
        let css = 'slds-combobox__form-element slds-input-has-icon ';
        if (this.isMultiEntry) {
            css += 'slds-input-has-icon_right';
        } else {
            css += this.hasSelection() ? 'slds-input-has-icon_left-right' : 'slds-input-has-icon_right';
        }
        return css;
    }

    get getSearchIconClass() {
        let css = 'slds-input__icon slds-input__icon_right ';
        if (!this.isMultiEntry) {
            css += this.hasSelection() ? 'slds-hide' : '';
        }
        return css;
    }
    
    get getDetailsIconClass() {
        return ( 
            'slds-button slds-button_icon slds-input__icon slds-input__icon_right ' +
            (this.hasSelection() ? 'slds-hide' : '')
        );
    }

    get getClearSelectionButtonClass() {
        return (
            'slds-button slds-button_icon slds-input__icon slds-input__icon_right ' +
            (this.hasSelection() ? '' : 'slds-hide')
        );
    }

    get getSelectIconName() {
        return this.hasSelection() && this._curSelection[0] ? this._curSelection[0].icon : 'standard:default';
    }

    get getSelectIconClass() {
        return 'slds-combobox__input-entity-icon ' + (this.hasSelection() ? '' : 'slds-hide');
    }

    get getInputValue() {
        if (this.isMultiEntry) {
            return this._searchTerm;
        }
        if(this.hasSelection()){
            return this._curSelection[0].title ? this._curSelection[0].title  :
                (this._curSelection[0].id == this._selectedRecordId && this._selectedRecordName ? this._selectedRecordName : '');
        }else{
            return this._searchTerm;
        }
    }

    get getInputTitle() {
        if (this.isMultiEntry) {
            return '';
        }
        return this.hasSelection() ? this._curSelection[0].title : '';
    }

    get getListboxClass() {
        return (
            'slds-dropdown dmpl-dropdown ' +
            (this.scrollAfterNItems ? `slds-dropdown_length-with-icon-${this.scrollAfterNItems} ` : '') +
            'slds-dropdown_fluid'
        );
    }

    get isInputReadonly() {
        if (this.isMultiEntry) {
            return false;
        }
        return this.hasSelection();
    }
}