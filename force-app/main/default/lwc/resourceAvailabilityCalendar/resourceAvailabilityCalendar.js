import { LightningElement, track, api, wire } from 'lwc';
import getResourceDetailsByBranch from '@salesforce/apex/ResourceAvailabilityController.getResourceDetailsByBranch';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';

export default class ResourceAvailabilityCalendar extends NavigationMixin(LightningElement)  {

    @track currentDate = new Date();
    @track weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    @track calendarDates = [];
    @api recordId;
    @track startDate;
    @track endDate;
    @track resouceData = []
    @track currentWeek;
    @track searchKeyword = '';
    @track isPresentWeek = false;
    @track isLoading = false;
    @track selectedBranch;

    handleFieldChange(event) {
        const fieldValue = event.detail.value;
        if(fieldValue != null){
            this.selectedBranch = fieldValue.toString();
        }
        else this.selectedBranch = '';

        this.daysToShow = 7;
        this.fetchData(this.daysToShow);
    }


    statusOptions = [
        { value: 'currentmonth', label: 'Current Month' },
        { value: 'nextmonth', label: 'Next Month' },
        { value: 'previousmonth', label: 'Previous Month' },
    ];
   
     connectedCallback() {
        this.daysToShow = 7;
        this.isAppPage = true;
        this.fetchData(this.daysToShow);
    }

    renderedCallback() {
        const inputField = this.template.querySelector('lightning-input-field');
        if (inputField) {
            inputField.addEventListener('change', this.handleFieldChange.bind(this));
        }
    }       

    getMonthDiff(date) {
        const today = new Date();
        const currentMonth = today.getMonth();
        const targetMonth = date.getMonth();
        const diff = targetMonth - currentMonth;
        if (targetMonth === currentMonth) {
            return 'currentmonth';
        } else if (targetMonth > currentMonth && targetMonth <= 11) {
            return 'nextmonth';
        } else if (targetMonth < currentMonth && targetMonth >= 0) {
            return 'previousmonth';
        }
        return 'currentmonth';
    }

    handleMonthChange(event) {
        const selectedValue = event.detail.value;
        const today = new Date();
        let newDate;

        switch (selectedValue) {
            case 'currentmonth':
                newDate = today;
                break;
            case 'nextmonth':
                newDate = new Date(today.getFullYear(), today.getMonth() + 1, 1);
                break;
            case 'previousmonth':
                newDate = new Date(today.getFullYear(), today.getMonth() - 1, 1);
                break;
            default:
                newDate = today;
                break;
        }

        this.currentDate = newDate;
        this.fetchData(this.daysToShow);
    }

    markers = [
        { Name: "Present", class: "slds-p-right_xx-small green-utility-icon" },
        { Name: "Absent", class: "slds-p-right_xx-small red-utility-icon" },
        { Name: "Leave", class: "slds-p-right_xx-small yellow-utility-icon" },
        { Name: "Holiday", class: "slds-p-right_xx-small blue-utility-icon" },
        { Name: "Weekend", class: "slds-p-right_xx-small gray-utility-icon" },
        { Name : "Half Day", class: "slds-p-right_xx-small purple-utility-icon"}
    ];



    @wire(CurrentPageReference)
    getPageReferenceParameters(currentPageReference) {
        if (currentPageReference) {
            this.recordId = currentPageReference.attributes.recordId;
        }
    }

    fetchData(daysToShow) {
        this.getFormattedWeek(daysToShow);
        this.getResourceDetailsData();
        this.checkIfPresentWeek();
    }



    getCurrentWeek(startDate, endDate, daysToShow) {
        const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        const start = new Date(startDate);
        const end = new Date(endDate);
        const week = [];
        let currentDate = new Date(start);

        for (let i = 0; i < daysToShow; i++) {
            const dayName = dayNames[currentDate.getDay()];
            const date = currentDate.toISOString().slice(0, 10);
            week.push({ date, dayName, day: date && date.split('-')[2] });
            currentDate.setDate(currentDate.getDate() + 1);
        }
        return week;
    }


    getFormattedWeek(daysToShow) {
        const currentDate = new Date(this.currentDate);
        const firstDayOfWeek = new Date(currentDate);
        const lastDayOfWeek = new Date(firstDayOfWeek);
        lastDayOfWeek.setDate(firstDayOfWeek.getDate() + daysToShow - 1);
        const lastDayOfMonth = new Date(firstDayOfWeek.getFullYear(), firstDayOfWeek.getMonth() + 1, 0).getDate();
        if (lastDayOfWeek.getDate() > lastDayOfMonth) {
            lastDayOfWeek.setDate(lastDayOfMonth);
        }
        const startDateFormatted = this.formatDate(firstDayOfWeek);
        const endDateFormatted = this.formatDate(lastDayOfWeek);
        const startDateFormattedDisplay = this.formatDateDisplay(firstDayOfWeek);
        const endDateFormattedDisplay = this.formatDateDisplay(lastDayOfWeek);
        this.startDate = startDateFormatted;
        this.endDate = endDateFormatted;
        this.weekdays = this.getCurrentWeek(startDateFormatted, endDateFormatted, daysToShow);
        this.currentWeek = `${startDateFormattedDisplay} - ${endDateFormattedDisplay}`;
    }

    formatDateDisplay(date) {
        const monthNames = ["January", "February", "March", "April", "May", "June",
            "July", "August", "September", "October", "November", "December"];
        const day = date.getDate().toString().padStart(2, '0');
        const month = monthNames[date.getMonth()].slice(0, 3);
        const year = date.getFullYear();
        return `${day}-${month}-${year}`;
    }


    formatDate(date) {
        return `${date.getFullYear()}-${(date.getMonth() + 1).toString().padStart(2, '0')}-${date.getDate().toString().padStart(2, '0')}`;
    }

    getWeekDates() {
        const today = new Date();
        const dayOfWeek = today.getDay();
        const diff = today.getDate() - dayOfWeek + (dayOfWeek === 0 ? -6 : 1);
        const weekStart = new Date(today.setDate(diff));
        const weekDates = [];
        for (let i = 0; i < 7; i++) {
            const date = new Date(weekStart);
            date.setDate(date.getDate() + i);
            weekDates.push(date.toISOString().slice(0, 10));
        }
        return weekDates;
    }

    goToPreviousWeek() {
        this.currentDate.setDate(this.currentDate.getDate() - this.daysToShow);
        this.weekdays = this.getCurrentWeek(this.startDate, this.endDate);
        this.fetchData(this.daysToShow);
        this.selectedMonth = this.getMonthDiff(this.currentDate);
    }

    goToNextWeek() {
        this.currentDate.setDate(this.currentDate.getDate() + this.daysToShow);
        this.weekdays = this.getCurrentWeek(this.startDate, this.endDate);
        this.fetchData(this.daysToShow);
        this.selectedMonth = this.getMonthDiff(this.currentDate);
    }


    get filteredResourceData() {
        return this.resouceData.filter(resource => resource.Name.toLowerCase().includes(this.searchKeyword.toLowerCase()));
    }

    handleSearch(event) {
        this.searchKeyword = event.target.value;
    }

    handleSubmit(event) {
        this.navigateToRecordPage(event,'dmpl__Resource__c');
    }
    
    navigateToRecordPage(event, objectApiName) {
        const recordId = event.currentTarget.dataset.recordid;
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: recordId,
                objectApiName: objectApiName,
                actionName: 'view'
            }
        });
    }

    checkIfPresentWeek() {
        const displayedWeekStart = new Date(this.startDate).toISOString().split('T')[0];
        const displayedWeekEnd = new Date(this.endDate).toISOString().split('T')[0];

        const currentDate = new Date();
        const currentWeekStart = new Date(currentDate);
        currentWeekStart.setDate(currentDate.getDate() - currentDate.getDay() + 1);
        const currentWeekEnd = new Date(currentWeekStart);
        currentWeekEnd.setDate(currentWeekStart.getDate() + 6);

        const currentWeekStartString = currentWeekStart.toISOString().split('T')[0];
        const currentWeekEndString = currentWeekEnd.toISOString().split('T')[0];

        if (displayedWeekStart === currentWeekStartString && displayedWeekEnd === currentWeekEndString) {
            this.isPresentWeek = true;
        } else {
            this.isPresentWeek = false;
        }
    }

    @track hasData = false;
    getResourceDetailsData() {
        getResourceDetailsByBranch({ branchId: this.selectedBranch, startDate: this.startDate, endDate: this.endDate })
            .then((data) => {
                this.hasData = data.length > 0;
                this.processResourceData(data);
            })
            .catch((error) => {
                this.hasData = false;
                console.error('Error fetching resource details:', error);
        });
    }

    processResourceData(data) {
        try {
            this.resouceData = data;
            this.isLoading = false;
            // Check if any resource has availability data
            this.hasAvailabilityArray = this.checkAvailabilityArray(data);

            // Process each resource item
            this.resouceData = this.resouceData.map(item => this.processResourceItem(item));

        } catch (error) {
            console.error('Error processing resource data:', error);
        }
    }

    checkAvailabilityArray(data) {
        return data.some(item => item && item.dmpl__ResourceAvailabilities__r && item.dmpl__ResourceAvailabilities__r.length > 0);
    }

    processResourceItem(item) {
        let resouceArr = this.processAvailabilityData(item);
        let updatedResouceArr = this.updateAvailabilityClasses(resouceArr);
        if (item.dmpl__DefaultBranchId__r && item.dmpl__DefaultBranchId__r.length > 0) {
            const branchData = item.dmpl__DefaultBranchId__r;
            return { ...item, dmpl__ResourceAvailabilities__r: updatedResouceArr, dmpl__DefaultBranchId__r: branchData };
        }
        else {
            return { ...item, dmpl__ResourceAvailabilities__r: updatedResouceArr };
        }
    }

    // Process availability data for a resource item
    processAvailabilityData(item) {
        let resouceArr = item?.dmpl__ResourceAvailabilities__r?.map(avail => ({
            ...avail,
            dmpl__AvailabilityType__c: avail?.dmpl__AvailabilityType__c ?? '-',
            class: 'default-class dmpl-cal-box slds-p-around_small'
        })) || [];
        resouceArr = this.fillMissingDates(resouceArr);
        resouceArr.sort((a, b) => new Date(a.dmpl__Date__c) - new Date(b.dmpl__Date__c));
        return resouceArr.slice(0, this.daysToShow);
    }

    updateAvailabilityClasses(resouceArr) {
        return resouceArr.map(avail => {
            let availabilityClass = 'dmpl-default  dmpl-cal-box slds-p-around_small';
            let day = avail.dmpl__Date__c;
            let date = new Date(day);
            let dayOfWeek = date.getDay();

            if (avail.dmpl__AvailabilityType__c) {
                switch (avail.dmpl__AvailabilityType__c) {
                    case 'Holiday':
                        availabilityClass = 'dmpl-holiday  dmpl-cal-box  slds-p-around_small';
                        break;
                    case 'Absent':
                        availabilityClass = 'dmpl-absent dmpl-cal-box  slds-p-around_small';
                        break;
                    case 'Present':
                        availabilityClass = 'dmpl-present  dmpl-cal-box  slds-p-around_small';
                        break;
                    case 'Weekend':
                        availabilityClass = 'dmpl-weekend  dmpl-cal-box  slds-p-around_small';
                        break;
                    case 'Leave':
                        availabilityClass = 'dmpl-leave  dmpl-cal-box  slds-p-around_small';
                        break;
                    case 'HalfDay':
                        availabilityClass = 'dmpl-half-day  dmpl-cal-box  slds-p-around_small';
                        break;
                    default:
                        break;
                }

            }
            return { ...avail, class: availabilityClass, firstLetter: avail.dmpl__AvailabilityType__c ? avail.dmpl__AvailabilityType__c.charAt(0).toUpperCase() : '' };
        });

    }

    fillMissingDates(resouceArr) {
        const existingDates = resouceArr.map(avail => avail.dmpl__Date__c);
        const currentDate = new Date(this.startDate);
        const weekDates = [];
        for (let i = 0; i < this.daysToShow; i++) {
            const date = new Date(currentDate);
            date.setDate(date.getDate() + i);
            weekDates.push(date.toISOString().slice(0, 10));
        }
        weekDates.forEach(date => {
            if (!existingDates.includes(date)) {
                resouceArr.push({
                    dmpl__AvailabilityType__c: '-',
                    dmpl__Date__c: date,
                    class: 'default-class dmpl-cal-box slds-p-around_small'
                });
            }
        });
        return resouceArr;
    }

}