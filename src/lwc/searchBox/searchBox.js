import { LightningElement, track } from 'lwc';

export default class SearchBox extends LightningElement {
    @track searchTerm = '';

    handleInputChange(event) {
        this.searchTerm = event.target.value;
    }

    handleKeyPress(event) {
        if (event.keyCode === 13) { // Check if Enter key is pressed
            this.triggerSearch();
        }
    }

    triggerSearch() {
        const searchEvent = new CustomEvent('searchchange', {
            detail: { searchTerm: this.searchTerm }
        });
        this.dispatchEvent(searchEvent);
    }
}
