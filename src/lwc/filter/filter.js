import { LightningElement, api, track, wire } from 'lwc';
import getPicklistValues from '@salesforce/apex/productController.getPicklistValues';

export default class filter extends LightningElement {
    @track familyOptions = [];
    @track typeOptions = [];
    @track selectedFamily = '';
    @track selectedType = '';

    @wire(getPicklistValues)
    picklistValues({ error, data }) {
        if (data) {
            this.familyOptions = [{ label: 'All', value: '' }, ...data.Family.map(value => ({ label: value, value }))];
            this.typeOptions = [{ label: 'All', value: '' }, ...data.Type.map(value => ({ label: value, value }))];
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }

    handleFamilyChange(event) {
        this.selectedFamily = event.target.value;
    }

    handleTypeChange(event) {
        this.selectedType = event.target.value;
    }

    applyFilters() {
        const filters = {
            family: this.selectedFamily,
            type: this.selectedType
        };
        const filterEvent = new CustomEvent('filterchange', { detail: filters });
        this.dispatchEvent(filterEvent);
    }
}
