
if (document) {
    document.onreadystatechange = () => {
        if (document.readyState === 'complete') {
            document.getElementById("sidebarCollapse").addEventListener('click', () => {
                const sidebar = document.getElementById("sidebar")
                sidebar.classList.toggle('active');
            })
        }
    }
}