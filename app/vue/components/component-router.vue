<script>
export default {
    mouted () {
        console.log('ÑÑEGA')
        window.addEventListener(
            'popstate', this.handleHistoryChange
        )
    },

    destroyed () {
        window.removeEventListener(
            'popstate', this.handleHistoryChange
        )
    },

    methods: {
        handleHistoryChange(){
            console.log('handleHistoryChange')
        }
    }
}
</script>

<template>
</template>