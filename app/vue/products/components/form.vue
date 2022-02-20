<script>
export default {
    props: {
        product: {
            required: true,
            type: Object
        }
    },
    components: {

    },
    data() {
        return {
            options: {
                branch_offices: [],
                departments: [],
                brands: []
            }
        }
    },
    mounted() {
        this.getOptions()
    },
    methods: {
        onSubmit(){
            if (this.product.id) {
                this.putForm()
            } else {
                this.postForm()
            }
        },
        postForm(){
            const url = this.url.build('products')
            let form = {
                product: this.product
            }

            this.http.post(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Producto creado exitosamente.')
                    this.$router.push(`/products/${result.data.id}`)
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        putForm(){
            const url = this.url.build('products/:id', {id: this.product.id})
            let form = {
                product: this.product
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.$toast.success('Producto actualizado exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },
        getOptions(){
            const url = this.url.build('products/options')
            this.http.get(url).then(result => {
                if (result.successful) {
                    this.options = result.data
                } else {
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
    <b-form @submit.prevent="onSubmit">
        <b-card>
            <b-card-body>
                <b-container>
                    <b-row>
                        <b-col md="6" sm="12">
                            <b-form-group>
                                <label> Nombre <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="product.name"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                        <b-col md="6" sm="12">
                            <b-form-group>
                                <label> Sku <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="product.sku"
                                    type="text"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Cantidad <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="product.quantity"
                                    type="number"
                                    placeholder=""
                                    required
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>

                    <b-row>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Precio <sup class="text-danger">*</sup> </label>

                                <b-form-input
                                    v-model="product.retail_price"
                                    type="number"
                                    placeholder=""
                                    required
                                    step="any"
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Precio mayoreo </label>

                                <b-form-input
                                    v-model="product.wholesale_price"
                                    type="number"
                                    placeholder=""
                                    step="any"
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                        <b-col sm="12">
                            <b-form-group>
                                <label> Precio compra </label>

                                <b-form-input
                                    v-model="product.purchase_price"
                                    type="number"
                                    placeholder=""
                                    step="any"
                                >
                                </b-form-input>
                            </b-form-group>
                        </b-col>
                    </b-row>

                    <b-form-group>
                        <label> Marca </label>
                        <b-form-select v-model="product.brands_id" :options="options.brands">
                        </b-form-select>
                    </b-form-group>

                    <b-form-group>
                        <label> Sucursal <sup class="text-danger">*</sup> </label>
                        <b-form-select required v-model="product.branch_office_id" :options="options.branch_offices">
                        </b-form-select>
                    </b-form-group>

                    <b-form-group>
                        <label> Departamento </label>
                        <b-form-select v-model="product.departments_id" :options="options.departments">
                        </b-form-select>
                    </b-form-group>
                </b-container>

                <b-container>
                    <b-button type="submit" variant="primary">Guardar</b-button>
                    <b-button type="reset" variant="outline-dark">Limpiar</b-button>
                </b-container>
            </b-card-body>
        </b-card>
    </b-form>
</template>