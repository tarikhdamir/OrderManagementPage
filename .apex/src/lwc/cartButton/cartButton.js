import { LightningElement, track } from 'lwc';

export default class CartButton extends LightningElement {
    @track isModalOpen = false;

    openCart() {
        this.template.querySelector('c-cart-modal').openModal();
    }

    handleModalClose() {
        this.isModalOpen = false;
    }
}
