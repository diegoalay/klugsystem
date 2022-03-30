<script>
export default {
    props: {
        product: {
            type: Object,
            required: false
        }
    },

    data(){
        return {
            slide: 0,
            sliding: null,
            files: []
        }
    },

    mounted() {
        this.getFiles()
    },
    methods: {
        getFiles(){
            this.loading = true

            const url = this.url.finance('products/:id/files', {id: this.product.id})

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.files = result.data
                }

                if (this.files.length === 0) {
                    this.files.push({
                        url: this.tools.getProductImage()
                    })
                }

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },

        getProductImage(file_id){
            const url = this.url.finance('products/:product_id/files/:id',
                {
                    product_id: this.product.id,
                    id: file_id,
                }
            ).toString(false)

            return url
        },
    }
}

</script>
<template>
    <b-container class="p-2">
        <div class="text-center"> <h4> {{ product.name }} </h4> </div>

        <b-carousel
            id="carousel"
            v-model="slide"
            background="#ababab"
            img-width="300"
            img-height="250"
            controls
            :interval="0"
            style="text-shadow: 1px 1px 2px #333;"
        >
            <b-carousel-slide
                v-for="(file) in files"
                :key="file.id"
                :text="file.name"
                :img-src="file.id ? getProductImage(file.id) : file.url"
            >
            </b-carousel-slide>
        </b-carousel>

        <div class="mt-4">
            <b> Disponibles: </b> {{ product.quantity }} <br>
            <b> Precio: </b> {{ 'Q. ' + product.retail_price }} <br>
            <b> Marca: </b> {{ product.brand_name }} <br>
            <b> Sucursal: </b> {{ product.branch_office_name }} <br>
            <b> Departamento: </b> {{ product.department_name }}
        </div>
    </b-container>
</template>