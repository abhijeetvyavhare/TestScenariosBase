import { LightningElement, track, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';
import getUserDetails from '@salesforce/apex/ResourceAvailabilityController.getUserDetails';
import postCheckIn from '@salesforce/apex/ResourceAvailabilityController.postCheckIn';
import postCheckOut from '@salesforce/apex/ResourceAvailabilityController.postCheckOut';
import getCheckInLocationTolerance from '@salesforce/apex/ResourceAvailabilityController.getCheckInLocationTolerance';

export default class ResourceAvailabilityCheckIn extends LightningElement {

    @track isResourceAvailable;
    @track elapsedSeconds = 0;
    @track isCheckedIn;
    @track firstCheckIn;
    @track disableButton;
    @track entitlements = [];
    @track checkInLocationTolerance = null;
    @track userData;

    wiredUserDataResult;
    latitude = null;
    longitude = null;
    isDisabled = false;
    intervalId;

    get formattedHours() {
        const hours = Math.floor(this.elapsedSeconds / 3600);
        return isNaN(hours) ? '00' : String(hours).padStart(2, '0'); 
    }

    get formattedMinutes() {
        const minutes = Math.floor((this.elapsedSeconds % 3600) / 60);
        return isNaN(minutes) ? '00' : String(minutes).padStart(2, '0'); 
    }

    get formattedSeconds() {
        const seconds = this.elapsedSeconds % 60;
        return isNaN(seconds) ? '00' : String(seconds).padStart(2, '0');
    }

    get buttonLabel() {
        return this.isCheckedIn ? 'Check Out' : 'Check In ';
    }

    get buttonVariant() {
        return this.isCheckedIn ? 'destructive' : 'success';
    }

    get currentDate() {
        const date = new Date();
        return `${date.toLocaleDateString('en-US', { weekday: 'long' })}, ${date.toLocaleDateString('en-US', { month: 'long' })} ${date.getDate()}, ${date.getFullYear()}`;
    }

    async connectedCallback() {
        try {
            const result = await getUserDetails();
            this.initialize(result);
            this.checkInLocationTolerance = await getCheckInLocationTolerance();
        }catch(error) {
            console.error('error');
        }        
    }

    @wire(getUserDetails)
    wiredUserData(result) {
        this.wiredUserDataResult = result;
        if (result.data) {
            this.userData = result.data;
        } else if (result.error) {
            console.error(error);
        }
    }

    initialize(result) {
        try {
            if (result) {
                if (result.isResourceAvailable === true) {
                    this.isResourceAvailable = true;

                    const resourceData = result.resourceData;
                    if (resourceData != null && resourceData.dmpl__ResourceAvailabilities__r != null) {
                        const availabilities = resourceData.dmpl__ResourceAvailabilities__r;

                        if (availabilities.length > 0) {
                            const latestAvailability = availabilities[0];

                            if(latestAvailability.dmpl__ResourceAvailabilities__r != null){
                                const nestedAvailabilities = latestAvailability.dmpl__ResourceAvailabilities__r;
                                this.firstCheckIn = latestAvailability?.dmpl__FirstCheckInTime__c;
                                if (nestedAvailabilities && nestedAvailabilities.length > 0) {
                                    const firstNestedAvailability = nestedAvailabilities[0];
                                    if (firstNestedAvailability.dmpl__Type__c === 'Check-Out') {
                                        this.isCheckedIn = false;
                                        this.elapsedSeconds = this.getDuration(latestAvailability.dmpl__Duration__c);
                                    } else {
                                        this.isCheckedIn = true;
                                        //this.lastCheckIn = firstNestedAvailability?.dmpl__AttendenceTime__c;
                                        this.elapsedSeconds =this.CurrentTime(this.firstCheckIn);
                                        this.startTimer();
                                    }
                                }
                            }
                        }

                        if (resourceData.dmpl__DefaultBranchId__r 
                            && resourceData.dmpl__DefaultBranchId__r.dmpl__GeoLocation__Latitude__s !== null 
                                && resourceData.dmpl__DefaultBranchId__r.dmpl__GeoLocation__Longitude__s !== null) {
                            
                            this.latitude = resourceData.dmpl__DefaultBranchId__r.dmpl__GeoLocation__Latitude__s;
                            this.longitude = resourceData.dmpl__DefaultBranchId__r.dmpl__GeoLocation__Longitude__s;
                        }

                        if(resourceData.dmpl__ResourceLeaves__r) {
                            const leaves = resourceData.dmpl__ResourceLeaves__r;

                            if(leaves !== null && leaves !== 0)
                            {
                                this.entitlements = leaves.map(leave => {
                                    return {
                                        Name: leave.dmpl__LeaveTypeId__r?.Name,  
                                        Available: leave.dmpl__Available__c,   
                                        Balance: leave.dmpl__Balance__c,
                                        Booked: leave.dmpl__Available__c - leave.dmpl__Balance__c
                                    };
                                });
                            }
                        }
                    }
                } else {
                    this.isResourceAvailable = false;
                    this.disableButton = true;
                }
            }
        } catch (error) {
            console.error('Error in connectedCallback:', error);
        }
    }

    async handleClick() {
        
        if(this.isDisabled === true)
            return;

        this.isDisabled = true;

        if (this.isCheckedIn) {
            await this.markCheckOut();
        } else {
            await this.markCheckIn();
        }

        this.isDisabled = false;    
    }

    async markCheckIn() {
        const timeDate = this.getCurrentFormattedDateTime();
        try {
            const { latitude, longitude } = await this.getGeolocation();
            const result = await postCheckIn({
                latitude: latitude,
                longitude: longitude,
                currentDateTime: timeDate,
            });
    
            if (result) {
                this.isCheckedIn = true;
                if(this.firstCheckIn != null){
                    this.elapsedSeconds = this.CurrentTime(this.firstCheckIn);
                }else{
                    this.elapsedSeconds = 0;
                }
                this.startTimer();

                if(latitude !== null && longitude !== null && this.latitude !== null && this.longitude !== null && this.checkInLocationTolerance != null) {
                    if(this.haversineDistance(latitude, longitude, this.latitude, this.longitude) > this.checkInLocationTolerance) {
                        this.showToast('Warning',`Out of ${this.checkInLocationTolerance} meter Radius`,'warning');
                    }
                }

                await refreshApex(this.wiredUserDataResult);
            } else {
                this.showToast('Error', 'Check-In failed. Please try again.', 'error');
            }
        } catch (error) {
            console.error('Error during check-in:', error);
        }
    }
    
    async markCheckOut() {
        const timeDate = this.getCurrentFormattedDateTime();
        try {
            const { latitude, longitude } = await this.getGeolocation();
            const result = await postCheckOut({
                latitude: latitude,
                longitude: longitude,
                currentDateTime: timeDate,
            });

            if (result) {
                this.isCheckedIn = false;
                this.stopTimer();
                await refreshApex(this.wiredUserDataResult);
            } else {
                this.showToast('Error','Check-Out failed. Please try again.', 'error');
            }
        } catch (error) {
            console.error('Error during check-out:', error);
        }
    }  

    CurrentTime(lastCheckIn) {
        const lastCheckInDate = new Date(lastCheckIn);
        const currentDate = new Date();
        const timeDifferenceMs = currentDate - lastCheckInDate;
        return Math.floor(timeDifferenceMs / 1000);
    }


    getDuration(duration) {
        const hours = Math.floor(duration); 
        const decimalPart = duration - hours; 
        
        const minutes = Math.floor(decimalPart * 60);
        const seconds = Math.round((decimalPart * 60 - minutes) * 60);
        
        const totalSeconds = hours * 3600 + minutes * 60 + seconds;
        return totalSeconds;
    }

    haversineDistance(latitude1, longitude1, latitude2, longitude2) {
        const R = 6371000; 
        const toRadians = Math.PI / 180;
        
        const latitude1Rad = latitude1 * toRadians;
        const longitude1Rad = longitude1 * toRadians;
        const latitude2Rad = latitude2 * toRadians;
        const longitude2Rad = longitude2 * toRadians;
    
        const dLat = latitude2Rad - latitude1Rad;
        const dLon = longitude2Rad - longitude1Rad;
    
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                  Math.cos(latitude1Rad) * Math.cos(longitude2Rad) *
                  Math.sin(dLon / 2) * Math.sin(dLon / 2);
    
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        const distance = R * c;
        
        return distance;
    }

    startTimer() {
        if (!this.intervalId) {  
            this.intervalId = setInterval(() => {
                this.elapsedSeconds += 1;
            }, 1000);
        }
    }

    stopTimer() {
        clearInterval(this.intervalId);
        this.intervalId = null;
    }

    getGeolocation() {
        return new Promise((resolve, reject) => {
            if ('geolocation' in navigator) {
                navigator.geolocation.getCurrentPosition(
                    (position) => {
                        const { latitude, longitude } = position.coords;
                        resolve({ latitude, longitude });
                    },
                    (error) => {
                        console.error('Geolocation error:', error);
                        this.showToast('Error', 'Please allow location access.', 'error');
                        reject(error);
                    }
                );
            } else {
                this.showToast('Error', 'Geolocation is not supported by this browser.', 'error');
                reject(new Error('Geolocation is not supported by this browser.'));
            }
        });
    }    

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }    

    getCurrentFormattedDateTime() {
        const date = new Date();
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, '0'); 
        const day = String(date.getDate()).padStart(2, '0');
        const hours = String(date.getHours()).padStart(2, '0');
        const minutes = String(date.getMinutes()).padStart(2, '0');
        const seconds = String(date.getSeconds()).padStart(2, '0');
    
        return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
    }

    disconnectedCallback() {
        this.stopTimer();
     }
}