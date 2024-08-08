import { LightningElement, api, track } from 'lwc';

export default class ProductDetailsModal extends LightningElement {
    @api product; // Product details to display
    @track isOpen = false;

    @api
    openModal() {
        console.log(JSON.stringify(this.product));
        this.isOpen = true;
    }

    @api
    closeModal() {
        this.isOpen = false;
    }

    handleCloseModal() {
        this.closeModal();
    }
}
