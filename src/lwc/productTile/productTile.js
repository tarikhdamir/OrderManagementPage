import { LightningElement, api } from 'lwc';

export default class ProductTile extends LightningElement {
    @api product;

    handleDetails() {
        // Handle showing product details
    }

    handleAdd() {
        // Handle adding product to cart
    }
}
