import { LightningElement, api, track } from 'lwc';

export default class ProductDetailsModal extends LightningElement {
    @api product;
    @track isOpen = false;

    @api
    openModal() {
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
