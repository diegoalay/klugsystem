
if (document) {
    const current_sub_tab = this.localStorage.getItem('current_sub_tab')
    const current_tab = this.localStorage.getItem('current_tab')

    if (current_sub_tab) {
        const el = document.querySelectorAll('a[href="' + (current_sub_tab) + '"]')[0]

        if (el) {
            el.parentElement.classList.add('active')
            el.parentElement.parentElement.style.opacity = 1
            el.parentElement.parentElement.style.visibility = "visible"
            el.parentElement.parentElement.style.display = "block"
        }
    }

    if (current_tab) {
        const el = document.querySelectorAll('a[href="' + (current_tab) + '"]')[0]

        if (el ){
            el.parentElement.classList.add('active')
        }
    }

    const first_elements = document.querySelectorAll(".sidebar ul li a")
    for (var i = 0, length = first_elements.length; i < length; i++) {
        first_elements[i].onclick = function() {
            const b = document.querySelector(".sidebar ul li.active")
            if (b) b.classList.remove("active");
            this.parentNode.classList.add('active')

            const url = getRelativePath(this.href)
            if (url === "/#") return

            localStorage.setItem("current_sub_tab", null)
            localStorage.setItem("current_tab", url)
        };
    }

    const second_elements = document.querySelectorAll(".sidebar ul li ul li a")
    for (var i = 0, length = second_elements.length; i < length; i++) {
        second_elements[i].onclick = function() {
            const b = document.querySelector("sidebar ul li ul li.active")
            if (b) b.classList.remove("active");

            localStorage.setItem("current_tab", null)
            localStorage.setItem("current_sub_tab", getRelativePath(this.href))
        }
    }

    // Watch on click for sidebar icon
    document.onreadystatechange = () => {
        if (document.readyState === 'complete') {
            document.getElementById("sidebarCollapse").addEventListener('click', () => {
                const sidebar = document.getElementsByClassName("sidebar")[0]
                sidebar.classList.toggle('active')
            })
        }
    }

    getRelativePath = (url) => {
        url = url.replace('http://localhost:3000', '')
        url = url.replace('https://klugsystem.com', '')

        return url
    }
}