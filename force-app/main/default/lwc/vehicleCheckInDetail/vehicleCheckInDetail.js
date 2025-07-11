import { LightningElement, api, track, wire } from 'lwc';
import getCheckInTemplates from '@salesforce/apex/CheckInController.getCheckInTemplates';
import getCheckInInspection from '@salesforce/apex/CheckInController.getCheckInInspection';
import getCheckInTemplateLineAttachments from '@salesforce/apex/CheckInController.getCheckInTemplateLineAttachments';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { RefreshEvent } from 'lightning/refresh';
import { createRecord, deleteRecord, updateRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class VehicleCheckInDetail extends LightningElement {

    @api title;
    @api recordId;
    @api defaultFieldsArray = ["dmpl__CheckInInspection__c.Id", "dmpl__CheckInInspection__c.Name", "dmpl__CheckInInspection__c.dmpl__AssetId__c", "dmpl__CheckInInspection__c.dmpl__AssetId__r.dmpl__ItemId__c"];
    @api renderData = [];
    @api renderRemarks = [];
    @api sections = [];
    @api renderDetails = false;
    @api activeSubSections = [];

    @api activeSection;
    @api activeSubSection;
    @api showRemarksAndUpload = false;
    @api previousData = [];
    @api isCommunityLayout;

    @track currentImageURL = '';
    @track hostUrl = window.location.origin + '/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId=VERSIONID&operationContext=CHATTER&contentId=CONTENTENDID';
    @track communityHostUrl = window.location.origin + '/sfsites/c/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId=VERSIONID&operationContext=CHATTER&contentId=CONTENTENDID';

    defaultSection = 'Sample';
    configuredSectionImages = [];
    configuredSections = []

    activeSubSectionClass = "slds-vertical-tabs__nav-item slds-is-active slds-vertical-tabs__link";
    inActiveSubSectionClass = "slds-vertical-tabs__nav-item slds-vertical-tabs__link";
    activeIssuesClass = "slds-vertical-tabs__content slds-show";
    inActiveIssuesClass = "slds-vertical-tabs__content slds-hide"

    connectedCallback() {
    }

    @wire(getRecord, {
        recordId: "$recordId",
        fields: "$defaultFieldsArray"
    })
    handle({ error, data }) {
        if (data) {
            this.renderData = [];
            getCheckInTemplates({ itemId: data.fields.dmpl__AssetId__r.value.fields.dmpl__ItemId__c.value }).then((result) => {
                if (result && result.length > 0) {
                    result.forEach((vehicleCheckIn) => {
                        vehicleCheckIn.dmpl__Check_In_section_Templates__r.forEach((checkInSectionTemplate) => {
                            if (this.configuredSections.filter(x => x.Name == checkInSectionTemplate.dmpl__SectionName__c).length == 0)
                                this.configuredSections.push({ Name: checkInSectionTemplate.dmpl__SectionName__c, contentVersionId: '', contentDocumentId: '', Show: false });

                            if (this.renderData.filter(p => p.Section === checkInSectionTemplate.dmpl__SectionName__c).length == 0) {
                                let issues = [];
                                checkInSectionTemplate.dmpl__Issues__c.split(';').forEach((issue) => {
                                    issues.push({ RecordId: '', Value: checkInSectionTemplate.dmpl__SectionName__c + "-" + checkInSectionTemplate.dmpl__SubSection__c + "-" + issue, Name: issue, IsSelected: false });
                                })
                                let newData = { Section: checkInSectionTemplate.dmpl__SectionName__c, SubSections: [{ SubSectionName: checkInSectionTemplate.dmpl__SubSection__c, Issues: [...issues], Class: this.inActiveSubSectionClass, SubClass: this.inActiveIssuesClass }] };
                                this.activeSubSections.push({ Section: checkInSectionTemplate.dmpl__SectionName__c, LastActiveSubSection: checkInSectionTemplate.dmpl__SubSection__c });
                                this.renderData.push(newData);
                            }
                            else {
                                this.renderData.forEach((internalData) => {
                                    if (internalData.Section === checkInSectionTemplate.dmpl__SectionName__c) {
                                        if (internalData.SubSections.filter(p => p.SubSectionName === checkInSectionTemplate.dmpl__SubSection__c).length == 0) {
                                            let issues = [];
                                            checkInSectionTemplate.dmpl__Issues__c.split(';').forEach((issue) => {
                                                issues.push({ RecordId: '', Value: checkInSectionTemplate.dmpl__SectionName__c + "-" + checkInSectionTemplate.dmpl__SubSection__c + "-" + issue, Name: issue, IsSelected: false });
                                            })
                                            internalData.SubSections.push({ SubSectionName: checkInSectionTemplate.dmpl__SubSection__c, Issues: [...issues], Class: this.inActiveSubSectionClass, SubClass: this.inActiveIssuesClass });
                                        }
                                        else {
                                            internalData.SubSections.forEach((subSectionDetails) => {
                                                if (subSectionDetails.SubSectionName === checkInSectionTemplate.dmpl__SubSection__c) {
                                                    checkInSectionTemplate.dmpl__Issues__c.split(';').forEach((issue) => {
                                                        subSectionDetails.Issues.push({ RecordId: '', Value: checkInSectionTemplate.dmpl__SectionName__c + "-" + checkInSectionTemplate.dmpl__SubSection__c + "-" + issue, Name: issue, IsSelected: false });
                                                    })
                                                }
                                            })
                                        }
                                    }
                                })
                            }
                        })
                    })

                    this.activeSection = this.configuredSections[0]['Name'];
                    let indexOfActiveSection = this.renderData.indexOf(this.renderData.find(p => p.Section === this.activeSection));
                    this.activeSubSection = this.renderData.length > 0 && this.renderData[indexOfActiveSection].SubSections.length > 0 ? this.renderData[indexOfActiveSection].SubSections[0]["SubSectionName"] : "";
                    this.renderData.forEach((record) => {
                        record.SubSections.forEach((subSection) => {
                            this.renderRemarks.push({ RecordId: '', Section: record.Section, SubSection: subSection.SubSectionName, Remarks: '' });
                        })
                    })

                    this.configuredSections.forEach((configuredSection) => {
                        getCheckInTemplateLineAttachments({ sectionName: configuredSection.Name, itemId: data.fields.dmpl__AssetId__r.value.fields.dmpl__ItemId__c.value }).then((attachmentResult) => {
                            attachmentResult.forEach((attachment) => {
                                if (attachment.dmpl__SectionName__c == configuredSection.Name && attachment.ContentDocumentLinks && attachment.ContentDocumentLinks.length > 0) {
                                    let versionId = attachment.ContentDocumentLinks[0]['ContentDocument']['LatestPublishedVersionId'];
                                    let contentDocId = attachment.ContentDocumentLinks[0]['ContentDocumentId'];
                                    this.configuredSectionImages.push({ Name: configuredSection.Name, contentVersionId: versionId, contentDocumentId: contentDocId });
                                    if (configuredSection.Name == this.activeSection)
                                        this.currentImageURL = this.isCommunityLayout ? this.communityHostUrl.replace('VERSIONID', versionId).replace('CONTENTENDID', contentDocId) : this.hostUrl.replace('VERSIONID', versionId).replace('CONTENTENDID', contentDocId);
                                }
                            })
                        }).catch((error) => {
                            console.log('Error ', error);
                        })
                    })

                    getCheckInInspection({ recordId: this.recordId }).then((postingDetails) => {
                        if (postingDetails && postingDetails.dmpl__Check_In_Inspection_Lines__r) {
                            postingDetails.dmpl__Check_In_Inspection_Lines__r.forEach((posting) => {
                                this.renderData.forEach((section) => {
                                    if (section.Section === posting.dmpl__Section__c) {
                                        section.SubSections.forEach((subSection) => {
                                            if (subSection.SubSectionName === posting.dmpl__SubSection__c) {
                                                let remarksRecord = this.renderRemarks.find(p => p.Section === section.Section && p.SubSection === subSection.SubSectionName);
                                                if (remarksRecord) {
                                                    remarksRecord["Remarks"] = posting.dmpl__Remarks__c;
                                                    remarksRecord["RecordId"] = posting.Id;
                                                }
                                                if (posting.dmpl__Condition__c) {
                                                    let receivedIssues = posting.dmpl__Condition__c.split(';');
                                                    subSection.Issues.forEach((issue) => {
                                                        if (receivedIssues.includes(issue.Name)) {
                                                            issue.RecordId = posting.Id;
                                                            issue.IsSelected = true;
                                                        }
                                                    })
                                                }
                                            }
                                        })
                                    }
                                })
                            })
                            this.previousData = [...this.renderData];
                            this.renderDetails = true;
                        }
                    })
                    this.renderDetails = true;
                }
            }).catch((error) => {
                console.log('Error ', error);
            })
        }
        if (error)
            console.log('error : ', error);
    }


    get getDetails() {
        this.renderDetails = false;
        this.activeSection = this.activeSection;
        let result = this.filterData();

        this.renderDetails = true;
        return result;
    }

    filterData() {
        let result = [];
        this.activeSubSection = this.activeSubSections.find(p => p.Section === this.activeSection)["LastActiveSubSection"];
        this.renderData.forEach((info) => {
            if (info.Section === this.activeSection) {
                info.SubSections.forEach((subSectionDetails) => {
                    subSectionDetails.Class = subSectionDetails.SubSectionName === this.activeSubSection ? this.activeSubSectionClass : this.inActiveSubSectionClass;
                    subSectionDetails.SubClass = subSectionDetails.SubSectionName === this.activeSubSection ? this.activeIssuesClass : this.inActiveIssuesClass;
                })
                result = [...info.SubSections];
            }
        })
        return result;
    }

    handleCheck(event) {
        let values = event.target.value.split('-');
        this.renderData.forEach((record) => {
            if (record.Section === values[0]) {
                record.SubSections.forEach((subsection) => {
                    if (subsection.SubSectionName === values[1]) {
                        subsection.Issues.forEach((issue) => {
                            if (issue.Name === values[2]) {
                                this.renderDetails = false;
                                issue.IsSelected = true;
                                this.renderDetails = true;
                            }
                        })
                    }
                })
            }
        })
    }

    handleSubSectionSelection(event) {
        this.handleClick(this.activeSection, event.detail.openSections);
    }

    handleClick(side, subSection) {
        this.renderDetails = false;
        if (side) {
            this.activeSubSections.find(p => p.Section === side)["LastActiveSubSection"] = subSection;
        }
        this.renderDetails = true;
    }

    handleUnCheck(event) {
        let values = event.target.value.split('-');
        this.renderData.forEach((record) => {
            if (record.Section === values[0]) {
                record.SubSections.forEach((subsection) => {
                    if (subsection.SubSectionName === values[1]) {
                        subsection.Issues.forEach((issue) => {
                            if (issue.Name === values[2]) {
                                this.renderDetails = false;
                                issue.IsSelected = false;
                                this.renderDetails = true;
                            }
                        })
                    }
                })
            }
        })
    }

    handleSectionSelection(event) {
        this.activeSection = event.target.value;
        this.currentImageURL = '';
        let configuredSectionImages = this.configuredSectionImages.filter(x => x.Name == this.activeSection);
        if (configuredSectionImages.length > 0) {
            this.currentImageURL = this.isCommunityLayout ? this.communityHostUrl.replace('VERSIONID', configuredSectionImages[0]['contentVersionId']).replace('CONTENTENDID', configuredSectionImages[0]['contentDocumentId']) : this.hostUrl.replace('VERSIONID', configuredSectionImages[0]['contentVersionId']).replace('CONTENTENDID', configuredSectionImages[0]['contentDocumentId']);
        }
    }

    get currentRecordId() {
        let currentRemarks = this.renderRemarks.find(p => p.Section === this.activeSection && p.SubSection === this.activeSubSection);
        return currentRemarks?.RecordId;
    }

    get currentRemarksId() {
        return this.activeSection + '-' + this.activeSubSection;
    }

    get currentRemarks() {
        let currentRemarks = this.renderRemarks.find(p => p.Section === this.activeSection && p.SubSection === this.activeSubSection);
        return currentRemarks.Remarks;
    }

    updateRemarks(event) {
        let values = event.target.id.split('-');
        let currentRemarks = this.renderRemarks.find(p => p.Section === values[0] && p.SubSection === values[1]);
        if (currentRemarks) {
            currentRemarks.Remarks = event.target.value;
        }
    }

    refreshStdComponents(){
        try{
            eval("$A.get('e.force:refreshView').fire();");
        }catch(e){
            this.dispatchEvent(new RefreshEvent());
        }
    }

    handleSave() {
        this.renderData.forEach((renderedDetails) => {
            if (renderedDetails.SubSections) {
                renderedDetails.SubSections.forEach((subSectionDetails) => {
                    let existingIssues = subSectionDetails.Issues.filter(p => p.RecordId != '');
                    let issues = subSectionDetails.Issues.filter(p => p.IsSelected === true).map(p => p.Name).join(';');
                    if (existingIssues.length > 0) {
                        let recordId = existingIssues[0]["RecordId"];
                        if (issues) {
                            let fields = {};
                            fields["Id"] = recordId;
                            fields["dmpl__Condition__c"] = issues;
                            fields['dmpl__Remarks__c'] = this.renderRemarks.find(p => p.Section === renderedDetails.Section && p.SubSection === subSectionDetails.SubSectionName)["Remarks"]
                            updateRecord({ fields })
                                .then(() => {
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Success',
                                            message: 'Issue added successfully.',
                                            variant: 'success'
                                        })
                                    );
                                    this.refreshStdComponents();
                                    this.renderDetails = true;
                                })
                                .catch(error => {
                                    console.log('error :', error);
                                });
                        }
                        else {
                            deleteRecord(recordId)
                                .then(() => {
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Removed',
                                            message: 'Issue was removed!',
                                            variant: 'error'
                                        })
                                    );
                                    subSectionDetails.Issues.forEach((issue) => {
                                        issue.RecordId = '';
                                        issue.IsSelected = false;
                                    })
                                    let currentRemarks = this.renderRemarks.find(p => p.Section === renderedDetails.Section && p.SubSection === subSectionDetails.SubSectionName);
                                    currentRemarks.RecordId = '';
                                    currentRemarks.Remarks = '';
                                    this.refreshStdComponents();
                                    this.renderDetails = true;
                                })
                                .catch(error => {
                                    console.log('failed to delete old record');
                                });
                        }
                    }
                    else {
                        if (issues) {
                            let fields = {}
                            fields["dmpl__CheckInInspectionId__c"] = this.recordId;
                            fields["dmpl__Section__c"] = renderedDetails.Section;
                            fields["dmpl__SubSection__c"] = subSectionDetails.SubSectionName;
                            fields["dmpl__Condition__c"] = issues;
                            fields['dmpl__Remarks__c'] = this.renderRemarks.find(p => p.Section === renderedDetails.Section && p.SubSection === subSectionDetails.SubSectionName)["Remarks"]
                            const recordInput = { apiName: 'dmpl__CheckInInspectionLine__c', fields };
                            createRecord(recordInput)
                                .then((result) => {
                                    subSectionDetails.Issues.forEach((issue) => {
                                        issue.RecordId = result.id;
                                    })
                                    let currentRemarks = this.renderRemarks.find(p => p.Section === renderedDetails.Section && p.SubSection === subSectionDetails.SubSectionName);
                                    currentRemarks.RecordId = result.id;
                                    this.dispatchEvent(
                                        new ShowToastEvent({
                                            title: 'Success',
                                            message: 'Issue added successfully.',
                                            variant: 'success'
                                        })
                                    );
                                    this.refreshStdComponents();
                                    this.renderDetails = true;
                                })
                                .catch(error => {
                                    console.log('err ', error);
                                });
                        }
                    }
                });
            }
        });
    }
}