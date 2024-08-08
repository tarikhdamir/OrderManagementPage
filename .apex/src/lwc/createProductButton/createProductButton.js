import { LightningElement, track, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import USER_ID from '@salesforce/user/Id';
import IS_MANAGER_FIELD from '@salesforce/schema/User.IsManager__c';

export default class CreateProductButton extends LightningElement {
    @track isManager = false;

    @wire(getRecord, { recordId: USER_ID, fields: [IS_MANAGER_FIELD] })
    user({ error, data }) {
        if (data) {
            this.isManager = data.fields.IsManager__c.value;
        } else if (error) {
            this.isManager = false;
        }
    }

    handleCreateProduct() {
        this.template.querySelector('c-create-product-modal').openModal();
    }

    handleProductCreated() {
        console.log("refresh called");
        this.dispatchEvent(new CustomEvent('productcreated'));
    }

}
