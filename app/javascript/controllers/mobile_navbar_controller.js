import {Controller} from "@hotwired/stimulus"
import {enter, leave} from "el-transition"

export default class extends Controller {
    static targets = ["menu", "hamburgerIcon", "closeIcon"];

    menuVisible = false;

    connect() {
        console.log("MobileNavbarController connected");
    }

    toggle() {
        if (this.menuVisible)
            this.hide();
        else
            this.show();
    }

    show() {
        this.menuTarget.classList.remove("hidden");
        this.hideHamburgerIcon();
        this.showCloseIcon();
        enter(this.menuTarget);
        this.menuVisible = true;
    }

    hide() {
        Promise.all([
            leave(this.menuTarget)
        ]).then(() => {
            this.menuTarget.classList.add("hidden");
            this.showHamburgerIcon();
            this.hideCloseIcon();
            this.menuVisible = false;
        });
    }

    hideHamburgerIcon() {
        this.hamburgerIconTarget.classList.add("hidden");
        this.hamburgerIconTarget.classList.remove("block");
    }

    showHamburgerIcon() {
        this.hamburgerIconTarget.classList.remove("hidden");
        this.hamburgerIconTarget.classList.add("block");
    }

    hideCloseIcon() {
        this.closeIconTarget.classList.add("hidden");
        this.closeIconTarget.classList.remove("block");
    }

    showCloseIcon() {
        this.closeIconTarget.classList.remove("hidden");
        this.closeIconTarget.classList.add("block");
    }
}
