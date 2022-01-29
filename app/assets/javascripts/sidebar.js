
if (document) {
    document.onreadystatechange = () => {
        if (document.readyState === 'complete') {
            document.getElementById("sidebarCollapse").addEventListener('click', () => {
                const sidebar = document.getElementsByClassName("sidebar")[0]
                sidebar.classList.toggle('active');
            })
        }
    }
}