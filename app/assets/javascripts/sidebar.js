if (document) {
    const current_page = location.pathname

    const openCaret = (li) => {
        const classes = Array.from(li.classList)

        if (classes.includes('list')) {
            el = li.childNodes[4]
            if (el) {
                const ul = el.parentElement.nextElementSibling

                const classes = Array.from(el.classList)
                if (classes.includes('right')) {
                    el.classList.remove('right')
                    el.classList.add('down')

                    ul.style.opacity = 1
                    ul.style.visibility = "visible"
                    ul.style.display = "block"
                } else {
                    el.classList.remove('down')
                    el.classList.add('right')

                    ul.style.opacity = 0
                    ul.style.visibility = "hidden"
                    ul.style.display = "none"
                }
            }
        }
    }

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
                // if (!activeEl || !(activeEl.parentElement.parentElement.isSameNode(el.parentElement))) {
                //     el.parentElement.style = '';
                // }
            }
        }
    }

    const setActiveWithDropdown = (el, pageReloaded = false) => {
        el.parentElement.classList.add('active')
        el.parentElement.parentElement.style.opacity = 1
        el.parentElement.parentElement.style.visibility = "visible"
        el.parentElement.parentElement.style.display = "block"

        if (pageReloaded) {
            openCaret(el.parentElement.parentElement.previousElementSibling)
        }
    }

    const setActive = (el) => {
        el.parentElement.classList.add('active')
    }

    const getRelativePath = (url) => {
        url = url.replace('http://localhost:3000', '')
        url = url.replace('https://klugsystem.com', '')

        return url
    }

    const activeCurrentPage = (current_path = null) => {
        if (!current_path) {
            current_path = current_page
        }

        let path = ''

        // special cases
        const regex = RegExp(`cash_registers/${system.current_user.cash_register_id}`)

        if (current_path.match(regex, current_path) || 
            current_path.match(/cash_registers\/new/)
        ) {
            path = '/profile/cash_register'
        } else if (current_path.includes('catalog')) {
            path = ('/'+current_path.split('/')[1] + "/" + current_path.split('/')[2])
        } else {
            path = ('/'+current_path.split('/')[1])
        }

        el = gethrefElement(path)

        if (el) {
            const classes = Array.from(el.parentElement.parentElement.classList)

            if (classes.includes('dropdown')) {
                setActiveWithDropdown(el, true)
            } else {
                setActive(el)
            }
        }
    }

    const onUrlChange = () => {
        disableActiveItems()

        activeCurrentPage(getRelativePath(location.href))
    }

    document.onreadystatechange = () => {

        if (document.readyState === 'complete') {
            // show side bar
            const topbar = document.getElementsByClassName("sidebar")[0]
            topbar.style.visibility = "visible"

            document.getElementById("sidebarCollapse").addEventListener('click', () => {
                tooggleSideBar()
            })

            if (current_page) {
                activeCurrentPage()
            }

            // Watch on click for sidebar icon
            let lastUrl = location.href;
            new MutationObserver(() => {
              const url = location.href;
              if (url !== lastUrl) {
                lastUrl = url;
                onUrlChange();
              }
            }).observe(document, {subtree: true, childList: true});
        }

        const firstLevel = document.querySelectorAll(".sidebar ul li a")
        for (var i = 0, length = firstLevel.length; i < length; i++) {
            firstLevel[i].onclick = function() {
                const tag = this.getAttribute('href')

                openCaret(this)

                if (tag === "#") return

                disableActiveItems(this)
                toggleMobile()
                setActive(this)
            }
        }

        const secondLevel = document.querySelectorAll(".sidebar ul li ul li a")
        for (var i = 0, length = secondLevel.length; i < length; i++) {
            secondLevel[i].onclick = function() {
                const tag = this.getAttribute('href')

                openCaret(this)

                if (tag === "#") return

                disableActiveItems(this)

                setTimeout(() => {
                    toggleMobile()
                    setActiveWithDropdown(this)
                }, 200);
            }
        }
    }
}