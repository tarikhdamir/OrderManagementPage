import { LightningElement, api, track, wire } from 'lwc';
import getFilteredProducts from '@salesforce/apex/productController.getFilteredProducts';
import { refreshApex } from '@salesforce/apex';

export default class ProductList extends LightningElement {
    @api filters;
    @api searchTerm;
    @track products;
    @track selectedProduct;
    @track isModalOpen = false;
    wiredProductsResult;

    @wire(getFilteredProducts, { filters: '$filters', searchTerm: '$searchTerm' })
    wiredProducts(result) {
        this.wiredProductsResult = result;
        if (result.data) {
            this.products = result.data;
        } else if (result.error) {
            this.products = undefined;
            console.error(result.error);
        }
    }

    refreshProducts() {
        // Re-fetch products based on the new filters and search term
        refreshApex(this.wiredProductsResult);
    }
}
