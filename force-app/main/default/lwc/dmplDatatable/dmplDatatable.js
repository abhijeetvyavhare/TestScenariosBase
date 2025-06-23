import LightningDatatable from 'lightning/datatable';
import toggleButtonColumnTemplate from './toggleButtonColumnTemplate.html';
import checkButtonColumnTemplate from './checkButtonColumnTemplate.html';
import FileUploadTemplate  from        './fileUpload.html';
import lookupTemplate      from        './lookup.html';
import picklistTemplate    from        './picklist.html';
import imageTemplate       from        './image.html';

export default class dmplDatatable extends LightningDatatable {
    static customTypes = {
        toggleButton: {
            template: toggleButtonColumnTemplate,
            standardCellLayout: true,
            typeAttributes: ['buttonDisabled', 'rowId', 'fieldApiName'],
        },
        checkButton: {
            template: checkButtonColumnTemplate,
            standardCellLayout: true,
            typeAttributes: ['buttonDisabled', 'rowId'],
        },
        fileUpload: {
            template: FileUploadTemplate,
            typeAttributes: ['value', 'relatedRecord', 'acceptedFormats', 'valueFieldName']
        },
        picklist : {
            template: picklistTemplate,
            typeAttributes: ['label', 'placeholder', 'options', 'value', 'relatedRecord', 'variant', 'name', 'valueFieldName']
        },
        lookup : {
            template: lookupTemplate,
            typeAttributes: ['label', 'value', 'relatedRecord', 'valueFieldName']
        },
        image : {
            template: imageTemplate,
            typeAttributes: ['alttxt','width','height'],
        }
    };
}