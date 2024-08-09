import {LightningElement, api, wire} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import addProductToCart from '@salesforce/apex/cartService.addProductToCart';
import createOrUpdateCart from '@salesforce/apex/cartService.createOrUpdateCart';
import getCartProducts from '@salesforce/apex/cartService.getCartProducts';
import { CurrentPageReference } from 'lightning/navigation';

export default class ProductTile extends LightningElement {
    @api product;
    accountId;

    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference) {
            this.accountId = currentPageReference.state.c__accountId;
        }
    }


    handleDetails() {
        this.template.querySelector('c-product-details-modal').openModal();
    }

    handleAdd() {
        createOrUpdateCart({ accountId: this.accountId, cartName: 'My Cart' })
            .then(cart => {
                return addProductToCart({ cartId: cart.Id, productId: this.product.Id, price: this.product.Price__c, quantity: 1 });
            })
            .then(() => {

                const refreshEvent = new CustomEvent('cartupdate');
                this.dispatchEvent(refreshEvent);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Product added to cart!',
                        variant: 'success',
                    })
                );
                this.dispatchEvent(new CustomEvent('productaddedtocart'));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error adding product to cart',
                        message: error.body.message,
                        variant: 'error',
                    })
                );
            });
    }
}
