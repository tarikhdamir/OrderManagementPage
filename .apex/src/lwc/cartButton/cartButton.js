import { LightningElement, track } from 'lwc';

export default class CartButton extends LightningElement {
    @track isModalOpen = false;

    openCart() {
        this.template.querySelector('c-cart-modal').openModal();
        console.log("modal open");
    }

    handleModalClose() {
        this.isModalOpen = false;
    }
}
