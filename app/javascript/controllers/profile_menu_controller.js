import {Controller} from "@hotwired/stimulus"
import {enter, leave} from "el-transition"
import {useClickOutside} from "stimulus-use"

export default class extends Controller {
    static targets = ["menu"];

    menuVisible = false;

    connect() {
        console.log("ProfileMenuController connected");
        useClickOutside(this)
    }

    clickOutside(event) {
        event.preventDefault();
        this.hide();
        this.menuVisible = false;
    }

    toggle() {
        if (this.menuVisible)
            this.hide();
        else
            this.show();
    }

    show() {
        this.menuTarget.classList.remove("hidden");
        enter(this.menuTarget);
        this.menuVisible = true;
    }

    hide() {
        Promise.all([
            leave(this.menuTarget)
        ]).then(() => {
            this.menuTarget.classList.add("hidden");
            this.menuVisible = false;
        });
    }
}
