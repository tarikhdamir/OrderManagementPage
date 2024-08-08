import { LightningElement, api, track, wire } from 'lwc';
import getCartProducts from '@salesforce/apex/cartService.getCartProducts';
import checkoutCart from '@salesforce/apex/cartService.checkoutCart';
import { CurrentPageReference } from 'lightning/navigation';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

export default class CartModal extends NavigationMixin(LightningElement) {
    accountId;
    @track cartProducts = [];
    @track simplifiedCartProducts = [];
    @track isOpen = false;


    @wire(CurrentPageReference)
    setCurrentPageReference(currentPageReference) {
        if (currentPageReference) {
            this.accountId = currentPageReference.state.c__accountId;
        }
    }

    connectedCallback() {
        this.addEventListener('cartupdate', this.refreshCartItems.bind(this));
    }

    refreshCartItems() {
        console.log('refreshed');
        return refreshApex(this.cartProducts);
    }


    @wire(getCartProducts, { accountId: '$accountId' })
    wiredProducts(result) {
        this.wiredCartProductsResult = result;  // Save the result for refreshApex
        if (result.data) {
            this.cartProducts = result.data;
            this.simplifiedCartProducts = this.cartProducts.map(product => ({
                productName: product.Product__r.Name__c,
                quantity: product.Quantity__c,  // Add this line
                price: product.Price__c
            }));
        } else if (result.error) {
            console.error('Error fetching cart products:', result.error);
        }
    }

    @api openModal() {
        this.isOpen = true;
    }

    closeModal() {
        this.isOpen = false;
        this.dispatchEvent(new CustomEvent('close'));
    }

    async handleCheckout() {
        try {
            const orderId = await checkoutCart({ accountId: this.accountId });
            console.log("asdasda1");
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: 'Order created successfully!',
                variant: 'success'
            }));

            console.log("asdasda");
            this.closeModal();
            // Redirect to the standard Order layout
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: orderId,
                    objectApiName: 'Order__c',
                    actionName: 'view',
                },
            });

        } catch (error) {
            console.error('Error during checkout:', error);
            this.dispatchEvent(new ShowToastEvent({
                title: 'Error',
                message: 'An error occurred during checkout.',
                variant: 'error'
            }));
        }
    }
}
