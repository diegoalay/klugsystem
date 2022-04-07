<script type="text/javascript">
    export default {
        components:{},
        data() {
            return {
            }
        },
        mounted(){
            this.getData()
        },
        methods:{
            getData(){
                const url = this.url.build('profile/cash_register')

                this.http.get(url).then(result => {
                    if (result.successful) {
                        const cash_register = result.data
                        if (cash_register) {
                            const url = this.url.build('cash_registers/:id',
                                {
                                    id: cash_register.id
                                }
                            ).toString(false)

                            this.$router.push(url)
                        } else {
                            this.$router.push('/cash_registers/new')
                        }
                    }else{
                        this.$toast.error(result.error.message)
                    }
                }).catch(error => {
                    console.log(error)
                })
            }
        }
    }
</script>

<template>

</template>