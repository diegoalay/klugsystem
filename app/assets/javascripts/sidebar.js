
if (document) {
    const current_page = location.pathname

    const sideBarIsActive = () => {
        const sidebar = document.getElementsByClassName("sidebar")[0]

        const classes = Array.from(sidebar.classList)

        if (classes.includes('active')) return true

        return false
    }

    const toggleMobile = () => {
        const w = window.innerWidth;

        if (w <= 768) {
            tooggleSideBar()
        }
    }

    const tooggleSideBar = () => {
        const sidebar = document.getElementsByClassName("sidebar")[0]
        sidebar.classList.toggle('active')
    }

    const gethrefElement = (path) => {
        return document.querySelectorAll('a[href="' + path + '"]')[0]
    }

    const disableActiveItems = (activeEl) => {
        const el = document.querySelector(".sidebar ul li.active")

        if (el) {
            el.classList.remove("active");

            const classes = Array.from(el.parentElement.classList)

            if (classes.includes('dropdown')) {
                if (!(activeEl.parentElement.parentElement.isSameNode(el.parentElement))) {
                    el.parentElement.style = '';
                }
            }
        }
    }

    const setActiveWithDropdown = (el) => {
        el.parentElement.classList.add('active')
        el.parentElement.parentElement.style.opacity = 1
        el.parentElement.parentElement.style.visibility = "visible"
        el.parentElement.parentElement.style.display = "block"

        toggleMobile()
    }

    const setActive = (el) => {
        el.parentElement.classList.add('active')

        toggleMobile()
    }

    const getRelativePath = (url) => {
        url = url.replace('http://localhost:3000', '')
        url = url.replace('https://klugsystem.com', '')

        return url
    }

    // Watch on click for sidebar icon
    document.onreadystatechange = () => {
        if (document.readyState === 'complete') {
            document.getElementById("sidebarCollapse").addEventListener('click', () => {
                tooggleSideBar()
            })
        }

        let el = null

        if (current_page) {
            let path = ('/'+current_page.split('/')[1])

            el = gethrefElement(path)
        }

        if (el) {
            const classes = Array.from(el.parentElement.parentElement.classList)

            if (classes.includes('dropdown')) {
                setActiveWithDropdown(el)
            } else {
                setActive(el)
            }
        }

        const first_elements = document.querySelectorAll(".sidebar ul li a")
        for (var i = 0, length = first_elements.length; i < length; i++) {
            first_elements[i].onclick = function() {
                const tag = this.getAttribute('href')

                if (tag === "#") return

                disableActiveItems(this)
                setActive(this)
            };
        }

        const second_elements = document.querySelectorAll(".sidebar ul li ul li a")
        for (var i = 0, length = second_elements.length; i < length; i++) {
            second_elements[i].onclick = function() {
                disableActiveItems(this)
                console.log(2)

                setTimeout(() => {
                    setActiveWithDropdown(this)
                }, 200);
            }
        }
    }
}