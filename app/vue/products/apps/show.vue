<script type="text/javascript">
import ComponentFiles from '../../components/component-files.vue'
    import componentForm from '../components/form.vue'
    import componentStatistics from '../components/statistics.vue'

    export default {
        components:{
            'component-form': componentForm,
            'component-statistics': componentStatistics,
                ComponentFiles
        },
        data() {
            return {
                statistics: null,
                product: {},
                id: null,
                tabIndex: 0
            }
        },
        mounted(){
            this.setId()
            this.getData()
        },
        methods:{
            setId(){
                this.id = this.$route.params.id
            },
            getData(){
                const url = this.url.build('products/:id', {id: this.id})
                this.http.get(url).then(result => {
                    if (result.successful) {
                        this.product = result.data.product
                        this.statistics = result.data.statistics
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
    <section class="application-component">
        <component-header-form
            title="Producto">
        </component-header-form>
        <b-card no-body>
            <b-tabs card pills fill v-model="tabIndex">
                <b-tab title="Formulario" fill>
                    <component-form :product="product"></component-form>
                </b-tab>
                <b-tab title="Imágenes" fill>
                    <component-files v-if="product.id" :url="url.build('products/:id/files', {id: this.product.id}).toString(false)"> </component-files>
                </b-tab>
                <b-tab title="Estadísticas" fill>
                    <component-statistics :activeTab="tabIndex === 2" v-if="product && statistics" :product="product" :statistics="statistics"></component-statistics>
                </b-tab>
            </b-tabs>
        </b-card>
    </section>
</template>