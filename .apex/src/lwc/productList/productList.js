// import { LightningElement, api, track } from 'lwc';
// import getFilteredProducts from '@salesforce/apex/productController.getFilteredProducts';
//
// export default class ProductList extends LightningElement {
//     @track products = [];
//     @track error;
//     @api filters = {};
//     @api searchTerm = '';
//
//     connectedCallback() {
//         this.loadProducts();
//     }
//
//     @api
//     async loadProducts() {
//         try {
//             console.log('Filter: ', JSON.stringify(this.filters));
//             const data = await getFilteredProducts({ filters: this.filters, searchTerm: this.searchTerm });
//             // console.log('Loaded products:', JSON.stringify(data));
//             // this.products = [];
//             this.products = data;
//             // console.log('Products after setting:', JSON.stringify(this.products));
//             this.error = undefined;
//         } catch (error) {
//             this.error = error;
//             this.products = undefined;
//         }
//     }
//
//     @api
//     refreshProducts() {
//         this.loadProducts();
//     }
// }

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

    loadProducts() {
        // Re-fetch products based on the new filters and search term
        refreshApex(this.wiredProductsResult);
    }
}
