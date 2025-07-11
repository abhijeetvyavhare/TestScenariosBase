import { LightningElement, track, wire, api } from 'lwc';
import getFieldsByFieldSetName from '@salesforce/apex/MetadataController.getFieldsByFieldSetName';
import Toast from 'lightning/toast';

const FIELD_BRANCHID = 'dmpl__BranchId__c';
const FIELD_PARTNER_ACCOUNTID = 'dmpl__PartnerAccountId__c';
const DELAY = 100;

export default class BulkOrderConversionConsole extends LightningElement {
    //data from apis xml file
    @api objectApiName;
    @api filterFieldSetName;
    @api relatedObjectApiName;
    @api relatedObjectFieldSetName;
    @api bulkActionTypeName;
    @api editProcessName;
    @api summaryName;

    @track showPopup = false;
    @track showFilters = true;
    @track filtersLabel = "Hide";
    @track showBulkActionSelection = true;
    @track showEditAndProcess = false;
    @track showReports = false;
    @track setActiveTab = "selectAllocationType";
    @track savedFiltersValue = 'inProgress';
    @track selectedConditionType = '';
    @track selectedConditionOperator = '';
    @track selectedObjectName = '';
    @track selectedConditionValue = '';
    @track customLogicData = [];
    @track showDocumentType = false;
    @track selectedHistoryFilter = 'total';
    @track selectedReportsFilter = 'total';
    @track showHistory = true;
    @track historySearchKey;
    @track saleOrderSearchKey;
    @track bulkReportsSearchKey;


    @track showBulkActionType = [
        {
            bulkActionTypeId: "1",
            title: "History",
            description: "View past batch processing records.",
            selected: true,
            iconName: "action:new_account"
        },
        {
            bulkActionTypeId: "2",
            title: "Processing",
            description: "Process invoices by earliest expiry to oldest orders",
            selected: false,
            iconName: "action:new_account",
        },
        {
            bulkActionTypeId: "3",
            title: "Printing",
            description: "Generate and print multiple documents to save time.",
            selected: false,
            iconName: "action:new_account"
        },
        {
            bulkActionTypeId: "4",
            title: "Approval",
            description: "Take action on several pending requests or tasks.",
            selected: false,
            iconName: "action:new_account"
        },
        {
            bulkActionTypeId: "5",
            title: "Cancellation",
            description: "Cancel unprocessed orders in Bulk.",
            selected: false,
            iconName: "action:new_account"
        },
        {
            bulkActionTypeId: "6",
            title: "Deletion",
            description: "Delete unprocessed line items in Bulk.",
            selected: false,
            iconName: "action:new_account"
        },
    ]

    @track documentTypeData = [
        {
            documentTypeId: "11",
            title: "Order",
            selected: false,
            description: "Oldest stock to oldest orders",
            iconName: "action:new_account",
            hasAllocationTypeData: false
        },
        {
            documentTypeId: "12",
            title: "Invoice",
            selected: false,
            description: "Oldest stock to oldest orders",
            iconName: "action:new_account",
            hasAllocationTypeData: true
        },
        {
            documentTypeId: "13",
            title: "Fullfilment",
            selected: false,
            description: "Oldest stock to oldest orders",
            iconName: "action:new_account",
            hasAllocationTypeData: false
        },
    ]

    @track allocationTypeData = [
        {
            allocationTypeId: "111",
            title: "FIFO",
            description: "Oldest stock to oldest orders",
            selected: false,
            iconName: "action:new_account",
        },
        {
            allocationTypeId: "112",
            title: "FEFO",
            description: "Earliest expiry to oldest orders",
            selected: false,
            iconName: "action:new_account"
        },
        {
            allocationTypeId: "113",
            title: "LIFO",
            description: "Newest stock to oldest orders",
            selected: false,
            iconName: "action:new_account"
        },
        {
            allocationTypeId: "114",
            title: "Fair Share",
            description: "Based on past 3 months buying pattern",
            selected: false,
            iconName: "action:new_account"
        },
        {
            allocationTypeId: "115",
            title: "Proportionate Allocation",
            description: "Based on order size",
            selected: false,
            iconName: "action:new_account"
        },
        {
            allocationTypeId: "116",
            title: "Equally Distributed",
            description: "Newest stock to oldest orders",
            selected: false,
            iconName: "action:new_account"
        },
        {
            allocationTypeId: "117",
            title: "Minimum Stock",
            description: "Based on past 3 months buying pattern",
            selected: false,
            iconName: "action:new_account"
        }
    ]

    saleOrderLines = [
        {
            id: '111',
            documentName: 'Invoice_001',
            documentDate: '2025-05-20',
            outletName: 'Outlet A',
            itemName: 'Brake Pad',
            itemCode: 'BP-001',
            quantity: 100,
            processingQuantity: 40,
            availableQuantity: 60,
            error: ''
        },
        {
            id: '112',
            documentName: 'Invoice_002',
            documentDate: '2025-05-21',
            outletName: 'Outlet B',
            itemName: 'Oil Filter',
            itemCode: 'OF-002',
            quantity: 80,
            processingQuantity: 20,
            availableQuantity: 60,
            error: 'Mismatch in quantity'
        },
        {
            id: '113',
            documentName: 'Invoice_003',
            documentDate: '2025-05-22',
            outletName: 'Outlet C',
            itemName: 'Air Filter',
            itemCode: 'AF-003',
            quantity: 50,
            processingQuantity: 10,
            availableQuantity: 40,
            error: ''
        }
    ];

    conditionTypeOptions = [
        { label: 'Text', value: 'text' },
        { label: 'Number', value: 'number' },
        { label: 'Date', value: 'date' }
    ];

    conditionOperatorOptions = [
        { label: 'Equals', value: 'equals' },
        { label: 'Not Equal', value: 'not_equal' },
        { label: 'Greater Than', value: 'greater_than' },
        { label: 'Less Than', value: 'less_than' }
    ];

    objectNameOptions = [
        { label: 'Text', value: 'text' },
        { label: 'Number', value: 'number' },
        { label: 'Date', value: 'date' }
    ];

    conditionValueOptions = [
        { label: 'Equals', value: 'equals' },
        { label: 'Not Equal', value: 'not_equal' },
        { label: 'Greater Than', value: 'greater_than' },
        { label: 'Less Than', value: 'less_than' }
    ];

    @wire(getFieldsByFieldSetName, { objectApiName: '$objectApiName', fieldSetName: '$filterFieldSetName' })
    fieldsetFields;

    @track selectedBulkActionValue = 'History';
    @track selectedDocumentTypeValue = '';
    @track selectedAllocationTypeValue = '';

    handleCardSelection(e) {
        const selectedValue = e.currentTarget.dataset.value;
        const selectedId = e.currentTarget.dataset.id;
        const selectedLabel = e.currentTarget.dataset.label;

        if (selectedLabel === "Bulk Action Type") {
            this.selectedBulkActionValue = selectedValue;
            this.showDocumentType = selectedId ? true : false;
            this.showBulkActionType = this.showBulkActionType.map((data) => {
                return {
                    ...data,
                    selected: data.title === selectedValue
                };
            });
            if (selectedValue === "History") {
                this.showDocumentType = false;
                this.showHistory = true;
            } else {
                this.showHistory = false;
                this.showDocumentType = true;
            }
        } else if (selectedLabel === "Document Type") {
            this.selectedDocumentTypeValue = selectedValue;
            this.showAllocationTypeData = this.documentTypeData.find((data) => data?.documentTypeId === selectedId).hasAllocationTypeData;
            this.documentTypeData = this.documentTypeData.map((data) => {
                return {
                    ...data,
                    selected: data.title === selectedValue
                };
            });
            this.documentTypeData.forEach((data) => {
                if (!data.hasAllocationTypeData && data.selected) {
                    setTimeout(() => {
                        this.showBulkActionSelection = false;
                        this.showEditAndProcess = true;
                    }, 1000);
                }
            })
        } else if (selectedLabel === "Allocation Type") {
            this.selectedAllocationTypeValue = selectedValue;
            this.allocationTypeData = this.allocationTypeData.map((data) => {
                return {
                    ...data,
                    selected: data.title === selectedValue
                };
            });
            setTimeout(() => {
                this.showBulkActionSelection = false;
                this.showEditAndProcess = true;
            }, 1000);
        }
    }

    get computedDocumentTypeClasses() {
        return `slds-col slds-grid ${this.showAllocationTypeData ? 'slds-size_1-of-3' : 'slds-size_2-of-3'}`
    }

    get computedDocumentCardClasses() {
        return `slds-col slds-m-top_small ${this.showAllocationTypeData ? 'slds-size_1-of-1' : 'slds-size_1-of-2'}`
    }

    get getRandomColor() {
        const hue = Math.floor(Math.random() * 360);
        const saturation = Math.floor(Math.random() * 30) + 40;
        const lightness = Math.floor(Math.random() * 20) + 30;
        return `--sds-c-icon-color-background : hsl(${hue}, ${saturation}%, ${lightness}%)`;
    }

    handleBack(event) {
        let currentTab = event.currentTarget.dataset.label;
        if (currentTab === "All Sale Orders") {
            this.showBulkActionSelection = true;
            this.showHistory = true;
            this.showEditAndProcess = false;
            this.showDocumentType = false;
            this.showBulkActionType = this.showBulkActionType.map((data) => {
                return {
                    ...data,
                    selected: data.title == "History" ? true : false
                };
            });
            this.documentTypeData = this.documentTypeData.map((data) => {
                return {
                    ...data,
                    selected: false
                };
            });
            this.allocationTypeData = this.allocationTypeData.map((data) => {
                return {
                    ...data,
                    selected: false
                };
            });
            this.selectedBulkActionValue = 'History';
            this.selectedDocumentTypeValue = '';
            this.selectedAllocationTypeValue = '';
            this.showDocumentType = false;
            this.showAllocationTypeData = false;
        } else if (currentTab === "Bulk Processing Report") {
            this.showEditAndProcess = true;
            this.showReports = false;
        }
    }

    toggleFilters() {
        this.showFilters = !this.showFilters;
        this.filtersLabel = this.showFilters ? "Hide" : "Show";
    }

    handleSearchClick() { }

    openPopup() {
        this.showPopup = true;
    }

    closePopup() {
        this.showPopup = false;
    }

    handleConditionTypeChange(event) {
        this.selectedConditionType = event.detail.value;
    }

    handleConditionOperatorChange(event) {
        this.selectedConditionOperator = event.detail.value;
    }

    handleObjectNameChange(event) {
        this.selectedObjectName = event.detail.value;
    }

    handleConditionValueChange(event) {
        this.selectedConditionValue = event.detail.value;
    }

    get showAdditionalConditions() {
        if (this.selectedConditionType || this.customLogicData.length) {
            return true;
        }
    }

    handleCustomFilterSave() {
        if (this.selectedConditionType && this.selectedConditionOperator && this.selectedObjectName && this.selectedConditionValue) {
            this.customLogicData.push({
                Id: this.customLogicData.length + 1,
                conditionName: `Condition ${this.customLogicData.length + 1}`,
                conditionType: this.selectedConditionType,
                conditionOperator: this.selectedConditionOperator,
                objectName: this.selectedObjectName,
                conditionValue: this.selectedConditionValue,
            })
        }
        this.selectedConditionType = '';
        this.selectedConditionOperator = '';
        this.selectedObjectName = '';
        this.selectedConditionValue = '';
        console.log(JSON.stringify(this.customLogicData), "customLogicData");
    }

    handleConditionDelete() { }

    handleSaleOrdersSearch(event) {
        this.saleOrderSearchKey = event.target.value.toLowerCase();
    }

    handlePillRemove(event) {
        const nameToRemove = event.detail.name;
        this.customLogicData = this.customLogicData.filter(name => name.conditionName !== nameToRemove);
    }

    handleClearAllPills() {
        this.customLogicData = [];
    }

    get columnsData() {
        let columns = [
            { label: 'Document Name', fieldName: 'documentName', initialWidth: 150 },
            { label: 'Document Date', fieldName: 'documentDate', initialWidth: 150 },
            { label: 'Outlet Name', fieldName: 'outletName', initialWidth: 150 },
            { label: 'Item Name', fieldName: 'itemName' },
            { label: 'Item Code', fieldName: 'itemCode' },
            { label: 'Quantity', fieldName: 'quantity' },
            { label: 'Processing Quantity', fieldName: 'processingQuantity' },
            { label: 'Available Quantity', fieldName: 'availableQuantity' },
            { label: 'Error', fieldName: 'error' },
            {
                type: 'action',
                typeAttributes: {
                    rowActions: [
                        { label: 'Show details', name: 'show_details' },
                        { label: 'Delete', name: 'delete' },
                    ]
                },
            },
        ];
        if (this.showReports) {
            columns.push({ label: 'Status', fieldName: 'status' },)
        }
        return columns;
    }

    get saleOrderLinesData() {
        let filteredData = [...this.saleOrderLines]
        if (this.saleOrderSearchKey) {
            filteredData = filteredData.filter(item =>
                item.outletName && item.outletName.toLowerCase().includes(this.saleOrderSearchKey)
            );
        }
        return filteredData;
    }

    handleProcessInvoice() {
        this.showEditAndProcess = false;
        this.showReports = true;
        Toast.show({
            label: 'Success',
            message: 'N order(s) submitted for invoicing.',
            mode: 'dismissible ',
            variant: 'success'
        }, this);
    }

    handleRetryFailed() { }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        switch (action.name) {
            case 'show_details':
                console.log('Show details for', row);
                break;
            case 'delete':
                console.log('Delete row', row);
                break;
        }
    }

    handleSelectedRows(event) {
        const selectedRows = event.detail.selectedRows;
        console.log('Selected rows:', selectedRows);
    }

    renderedCallback() {
        const historyFilters = this.template.querySelectorAll('.history-filter');
        historyFilters.forEach(filter => filter.classList.remove('dmpl-active'));
        const selectedHistoryFilter = this.template.querySelector(`.history-filter[data-value="${this.selectedHistoryFilter}"]`);
        if (selectedHistoryFilter) {
            selectedHistoryFilter.classList.add('dmpl-active');
        }
        const reportsFilter = this.template.querySelectorAll('.reports-filter');
        reportsFilter.forEach(filter => filter.classList.remove('dmpl-active'));
        const selectedReportsFilter = this.template.querySelector(`.reports-filter[data-value="${this.selectedReportsFilter}"]`);
        if (selectedReportsFilter) {
            selectedReportsFilter.classList.add('dmpl-active');
        }
        const bulkActionType = this.template.querySelectorAll('.bulk-action-type[data-label="Bulk Action Type"]');
        bulkActionType.forEach(card => card.classList.remove('dmpl-active-border'));
        const selectedBulkActionType = this.template.querySelector(`.bulk-action-type[data-label="Bulk Action Type"][data-value="${this.selectedBulkActionValue}"]`);
        if (selectedBulkActionType) {
            selectedBulkActionType.classList.add('dmpl-active-border');
        }
        const documentType = this.template.querySelectorAll('.bulk-action-type[data-label="Document Type"]');
        documentType.forEach(card => card.classList.remove('dmpl-active-border'));
        const selectedDocumentType = this.template.querySelector(`.bulk-action-type[data-label="Document Type"][data-value="${this.selectedDocumentTypeValue}"]`);
        if (selectedDocumentType) {
            selectedDocumentType.classList.add('dmpl-active-border');
        }
        const allocationType = this.template.querySelectorAll('.bulk-action-type[data-label="Allocation Type"]');
        allocationType.forEach(card => card.classList.remove('dmpl-active-border'));
        const selectedAllocationType = this.template.querySelector(`.bulk-action-type[data-label="Allocation Type"][data-value="${this.selectedAllocationTypeValue}"]`);
        if (selectedAllocationType) {
            selectedAllocationType.classList.add('dmpl-active-border');
        }
    }

    handleBulkReportsSearch(event) {
        this.bulkReportsSearchKey = event.target.value.toLowerCase();
    }

    bulkReports = [
        {
            id: '1',
            documentName: 'Invoice_001',
            documentDate: '2025-05-20',
            outletName: 'Outlet A',
            itemName: 'Brake Pad',
            itemCode: 'BP-001',
            quantity: 100,
            processingQuantity: 40,
            availableQuantity: 60,
            error: '',
            status: "Failure"
        },
        {
            id: '2',
            documentName: 'Invoice_002',
            documentDate: '2025-05-21',
            outletName: 'Outlet B',
            itemName: 'Oil Filter',
            itemCode: 'OF-002',
            quantity: 80,
            processingQuantity: 20,
            availableQuantity: 60,
            error: 'Mismatch in quantity',
            status: "Success"
        },
        {
            id: '3',
            documentName: 'Invoice_003',
            documentDate: '2025-05-22',
            outletName: 'Outlet C',
            itemName: 'Air Filter',
            itemCode: 'AF-003',
            quantity: 50,
            processingQuantity: 10,
            availableQuantity: 40,
            error: '',
            status: "Failure"
        }
    ];

    handleReportsFilter(event) {
        this.selectedReportsFilter = event.currentTarget.dataset.value;
    }

    get bulkReportsLogs() {
        let filteredData = [...this.bulkReports];
        switch (this.selectedReportsFilter) {
            case 'total': filteredData = this.bulkReports; break;
            case 'completed': filteredData = this.bulkReports.filter(record => record.status === 'Success'); break;
            case 'pending': filteredData = this.bulkReports.filter(record => record.status === 'Failure'); break;
            default: filteredData = this.bulkReports; break;
        }
        if (this.bulkReportsSearchKey) {
            filteredData = filteredData.filter(item =>
                item.documentName && item.documentName.toLowerCase().includes(this.bulkReportsSearchKey)
            );
        }
        return filteredData;
    }

    get allBulkReportsLength() {
        return this.bulkReports.length;
    }

    get completedBulkReportsLength() {
        return this.bulkReports.filter(record => record.status === 'Success').length;
    }

    get failedBulkReportsLength() {
        return this.bulkReports.filter(record => record.status === 'Failure').length;
    }

    handleRowActionReport(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        if (actionName === 'view') {
            console.log('Viewing row:', row);
        }
    }

    handleSelectedRowsReport(event) {
        const selectedRows = event.detail.selectedRows;
        console.log('Selected rows:', selectedRows);
    }

    handleHistorySearch(event) {
        this.historySearchKey = event.target.value.toLowerCase();
    }

    historyColumns = [
        { label: 'Batch Number', fieldName: 'batchNumber', initialWidth: 120 },
        { label: 'Start Date & Time', fieldName: 'startDate', initialWidth: 120 },
        { label: 'Complete Date & Time', fieldName: 'completeDate', initialWidth: 120 },
        { label: 'Submitted By', fieldName: 'submittedBy' },
        { label: 'Failed', fieldName: 'failed', initialWidth: 80 },
        { label: 'Success', fieldName: 'success', initialWidth: 80 },
        { label: 'Status', fieldName: 'status' },
    ];

    historyData = [
        {
            id: '1',
            batchNumber: 'BATCH-001',
            startDate: '2025-06-18 09:00 AM',
            completeDate: '2025-06-18 11:00 AM',
            submittedBy: 'Rohit Sharma',
            failed: 2,
            success: 8,
            status: 'Completed'
        },
        {
            id: '2',
            batchNumber: 'BATCH-002',
            startDate: '2025-06-18 12:00 PM',
            completeDate: '2025-06-18 02:00 PM',
            submittedBy: 'Mohit Sharma',
            failed: 0,
            success: 10,
            status: 'Completed'
        },
        {
            id: '3',
            batchNumber: 'BATCH-003',
            startDate: '2025-06-18 03:00 PM',
            completeDate: '',
            submittedBy: 'Anjali Verma',
            failed: 1,
            success: 5,
            status: 'In Progress'
        },
        {
            id: '4',
            batchNumber: 'BATCH-004',
            startDate: '2025-06-18 04:00 PM',
            completeDate: '',
            submittedBy: 'Aman Gupta',
            failed: 3,
            success: 0,
            status: 'Failed'
        },
        {
            id: '5',
            batchNumber: 'BATCH-005',
            startDate: '2025-06-18 05:00 PM',
            completeDate: '2025-06-18 07:00 PM',
            submittedBy: 'Riya Mehta',
            failed: 1,
            success: 9,
            status: 'Completed'
        },
        {
            id: '6',
            batchNumber: 'BATCH-006',
            startDate: '2025-06-19 08:00 AM',
            completeDate: '',
            submittedBy: 'Sanjay Kapoor',
            failed: 0,
            success: 0,
            status: 'In Progress'
        },
        {
            id: '7',
            batchNumber: 'BATCH-007',
            startDate: '2025-06-19 10:00 AM',
            completeDate: '2025-06-19 12:00 PM',
            submittedBy: 'Neha Sharma',
            failed: 2,
            success: 7,
            status: 'Completed'
        },
        {
            id: '8',
            batchNumber: 'BATCH-008',
            startDate: '2025-06-19 01:00 PM',
            completeDate: '',
            submittedBy: 'Rahul Singh',
            failed: 4,
            success: 2,
            status: 'In Progress'
        },
        {
            id: '9',
            batchNumber: 'BATCH-009',
            startDate: '2025-06-19 03:00 PM',
            completeDate: '2025-06-19 04:30 PM',
            submittedBy: 'Pooja Chauhan',
            failed: 0,
            success: 10,
            status: 'Completed'
        },
        {
            id: '10',
            batchNumber: 'BATCH-010',
            startDate: '2025-06-20 09:00 AM',
            completeDate: '',
            submittedBy: 'Karan Patel',
            failed: 3,
            success: 5,
            status: 'Failed'
        },
        {
            id: '11',
            batchNumber: 'BATCH-011',
            startDate: '2025-06-20 11:00 AM',
            completeDate: '2025-06-20 12:30 PM',
            submittedBy: 'Meena Yadav',
            failed: 1,
            success: 9,
            status: 'Completed'
        },
        {
            id: '12',
            batchNumber: 'BATCH-012',
            startDate: '2025-06-20 01:00 PM',
            completeDate: '',
            submittedBy: 'Sumit Rana',
            failed: 0,
            success: 0,
            status: 'In Progress'
        },
        {
            id: '13',
            batchNumber: 'BATCH-013',
            startDate: '2025-06-21 10:00 AM',
            completeDate: '',
            submittedBy: 'Ankita Desai',
            failed: 5,
            success: 2,
            status: 'Failed'
        },
        {
            id: '14',
            batchNumber: 'BATCH-014',
            startDate: '2025-06-21 12:00 PM',
            completeDate: '2025-06-21 02:00 PM',
            submittedBy: 'Deepak Sinha',
            failed: 0,
            success: 10,
            status: 'Completed'
        },
        {
            id: '15',
            batchNumber: 'BATCH-015',
            startDate: '2025-06-21 03:00 PM',
            completeDate: '',
            submittedBy: 'Kavya Menon',
            failed: 2,
            success: 6,
            status: 'In Progress'
        }
    ];

    handleHistoryFilter(event) {
        this.selectedHistoryFilter = event.currentTarget.dataset.value;
    }

    get historyLogs() {
        let filteredData = [...this.historyData];
        switch (this.selectedHistoryFilter) {
            case "total": filteredData = this.historyData; break;
            case "processed": filteredData = this.historyData.filter(e => e.status === 'Completed'); break;
            case "failed": filteredData = this.historyData.filter(e => e.status === 'Failed'); break;
            case "queued": filteredData = this.historyData.filter(e => e.status === 'In Progress'); break;
            case "pending": filteredData = this.historyData.filter(e => e.status === 'In Progress'); break;
            default: filteredData = this.historyData; break;
        }
        if (this.historySearchKey) {
            filteredData = filteredData.filter(item =>
                item.batchNumber && item.batchNumber.toLowerCase().includes(this.historySearchKey)
            );
        }
        return filteredData;
    }

    get allHistoryLogsLength() {
        return this.historyData.length;
    }

    get processedHistoryLogsLength() {
        return this.historyData.filter(e => e.status === 'Completed').length;
    }

    get failedHistoryLogsLength() {
        return this.historyData.filter(e => e.status === 'Failed').length;
    }

    get queuedHistoryLogsLength() {
        return this.historyData.filter(e => e.status === 'In Progress').length;
    }

    get pendingHistoryLogsLength() {
        return this.historyData.filter(e => e.status === 'In Progress').length;
    }
}