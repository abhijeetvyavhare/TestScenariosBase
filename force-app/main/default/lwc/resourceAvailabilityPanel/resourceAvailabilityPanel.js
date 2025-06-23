import { LightningElement, track, api } from 'lwc';
import getResourceDetailsByResource from '@salesforce/apex/AttendanceManagementController.getResourceDetailsByResource';

export default class ResourceAvailabilityPanel extends LightningElement {
    @track currentDate = new Date();
    @track currentMonth;
    @track weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    @track calendarDates = [];
    @api recordId;
    @track resourceName;
    @track currentYear = this.currentDate.getFullYear();
    @track month = this.currentDate.getMonth() + 1;
    @track isLoading = false;
    @track showDays = true;
    
    markers = [
        { Name: "Present", class: "slds-p-right_xx-small green-utility-icon" },
        { Name: "Absent", class: "slds-p-right_xx-small red-utility-icon" },
        { Name: "Leave", class: "slds-p-right_xx-small yellow-utility-icon" },
        { Name: "Holiday", class: "slds-p-right_xx-small blue-utility-icon" },
        { Name: "Weekend", class: "slds-p-right_xx-small gray-utility-icon" },
        { Name : "HalfDay", class: "slds-p-right_xx-small purple-utility-icon"}
    ];

    statusCounts = {};

    connectedCallback() {
        this.updateCalendar();
    }

    updateCalendar() {
        this.currentMonth = this.currentDate.toLocaleString('default', { month: 'long', year: 'numeric' });
        this.initializeCalendarDates();
        this.fetchResourceDetailsAndUpdateCalendar();
    }

    initializeCalendarDates() {
        const firstDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), 1);
        const lastDayOfMonth = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 0);
        const daysInMonth = lastDayOfMonth.getDate();
        const firstDayOfWeek = firstDayOfMonth.getDay();
        const offset = firstDayOfWeek === 0 ? 6 : firstDayOfWeek - 1;
        
        this.calendarDates = [];
        
        for (let i = 0; i < offset; i++) {
            this.calendarDates.push({ day: "", dateValue: "", class: "" });
        }

        for (let i = 1; i <= daysInMonth; i++) {
            const currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth(), i);
            let year = currentDate.getFullYear(), 
            month = String(currentDate.getMonth() + 1).padStart(2, '0'), 
            day = String(currentDate.getDate()).padStart(2, '0');
            this.calendarDates.push({ day: i, dateValue: `${year}-${month}-${day}`, class: "" });
        }

        const remainingColumns = 7 - (this.calendarDates.length % 7);
        if (remainingColumns !== 7) {
            for (let i = 0; i < remainingColumns; i++) {
                this.calendarDates.push({ day: "", dateValue: "", class: "" });
            }
        }
    }

    fetchResourceDetailsAndUpdateCalendar() {
        this.isLoading = true;
        getResourceDetailsByResource({ resourceId: this.recordId, month: this.month, year: this.currentYear })
            .then((data) => {
                console.log(JSON.stringify(data),'dataresources')
                console.log(this.currentYear,'dataresources')
                console.log(this.month,'dataresources')
                this.isLoading = false;
                this.processResourceData(data);
            })
            .catch((error) => {
                console.error(error);
                this.isLoading = false;
            });
    }

    processResourceData(data) {
        this.resourceName = data[0]?.Name || '';
        let _data = data && data[0] || {};
        let resourceDetails = _data?.dmpl__ResourceAvailabilities__r || [];

        this.calendarDates = this.calendarDates.map(e => {
            if (e) {
                let matchingDate = resourceDetails.find(v => v.dmpl__Date__c == e.dateValue);
                e = {...e, status: matchingDate?.dmpl__AvailabilityType__c || ''}
                if(e.dateValue != "" || e.day != 0) {
                    switch (e.status) {
                        case "Absent": e.class = "dmpl-absent dmpl-cal-box"; break;
                        case "Present": e.class = "dmpl-present  dmpl-cal-box"; break;
                        case "Weekend": e.class = "dmpl-weekend  dmpl-cal-box"; break;
                        case "Holiday": e.class = "dmpl-holiday  dmpl-cal-box"; break;
                        case "Leave": e.class = "dmpl-leave  dmpl-cal-box"; break;
                        case "HalfDay" : e.class = "dmpl-half-day dmpl-cal-box"; break
                        default: e.class = "dmpl-default  dmpl-cal-box"; break;
                    }
                } else {
                    e.class = "empty  dmpl-cal-box";
                }
                return e
            } else {
                return e;
            }
        });

        this.calculateStatusCounts();
        this.updateMarkers();
    }

    calculateStatusCounts() {
        this.statusCounts = {
            Present: 0,
            Absent: 0,
            Leave: 0,
            Holiday: 0,
            HalfDay: 0,
            Weekend:0
        };
        this.calendarDates.forEach(date => {
            switch (date.status) {
                case 'Weekend': this.statusCounts.Weekend++; break;
                case 'Present': this.statusCounts.Present++; break;
                case 'Absent': this.statusCounts.Absent++; break;
                case 'Leave': this.statusCounts.Leave++; break;
                case 'Holiday': this.statusCounts.Holiday++; break;
                case "HalfDay" : this.statusCounts.HalfDay++;break;
                default: break;
            }
        });
    }

    updateMarkers() {
        this.markers = this.markers.map(e => {
            return {...e, days: this.statusCounts[e.Name], showDays: this.showDays };
        });
    }

    goToPreviousMonth() {
        this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() - 1, 1);
        this.month-- ;
        this.updateCalendar();
    }

    goToNextMonth() {
        this.currentDate = new Date(this.currentDate.getFullYear(), this.currentDate.getMonth() + 1, 1);
        this.month++ ; 
        this.updateCalendar();
    }
}