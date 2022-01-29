<script type="text/javascript">
    export default {
        components:{
        },
        data() {
            return {
                product_text: null,
                product_quantity: 0,
                main_path: '/departments',
                fields: [{
                    label: 'Artículo',
                    key: 'name',
                    sortable: true
                },{
                    label: 'Unidad',
                    key: 'unit'
                },{
                    label: 'Cantidad',
                    key: 'quantity'
                },{
                    label: 'Precio',
                    key: 'price'
                },{
                    label: 'Subtotal',
                    key: 'subtotal'
                },{
                    label: 'Descuento',
                    key: 'discount'
                },{
                    label: '',
                    key: 'actions'
                }],
            }
        },
    }
</script>

<template>
    <section class="application-component">
        <component-header-form
            title="Vender">
        </component-header-form>
            <b-row>
                <b-col cols="8">
                    <b-card>
                        <b-row>
                            <b-col cols="7">
                                <b-form-group>
                                    <b-input-group>
                                        <b-form-input
                                            type="text"
                                            placeholder="Buscar producto ...."
                                            v-model="product_text"
                                        >
                                        </b-form-input>
                                        <b-input-group-append>
                                            <b-button :disabled="!text" @click="product_text = ''"><font-awesome-icon icon="times" /></b-button>
                                        </b-input-group-append>
                                    </b-input-group>
                                </b-form-group>
                            </b-col>
                            <b-col cols="3">
                                <b-form-group>
                                    <b-input-group>
                                        <b-form-input
                                            type="number"
                                            placeholder="Ingrese cantidad"
                                            v-model="product_quantity"
                                        >
                                        </b-form-input>
                                        <b-input-group-append>
                                            <b-button :disabled="!text" @click="product_quantity = ''"><font-awesome-icon icon="times" /></b-button>
                                        </b-input-group-append>
                                    </b-input-group>
                                </b-form-group>
                            </b-col>
                            <b-col cols="2">
                                <b-form-group>
                                    <b-button variant="primary">Agregar </b-button>
                                </b-form-group>
                            </b-col>
                        </b-row>
                        <br>
                        <b-table
                            striped
                            hover
                            :items="data"
                            :fields="fields"
                        >
                            <template v-slot:cell(actions)="row">
                                <b-button variant="outline-danger" @click.stop="deleteRecord(row.item.id)" class="mr-1">
                                    <b-icon icon="trash-fill"></b-icon>
                                </b-button>
                            </template>
                        </b-table>
                    </b-card>
                </b-col>
                <b-col>
                    <b-card>
                        <b-form-group label="Departamento mayor">
                            <b-form-select v-model="department.departments_id" :options="options.departments"></b-form-select>
                        </b-form-group>

                        <b-form-group label="Fecha de emisión">
                            <component-datepicker
                                :focus="false"
                                lang="es"
                                valueType="format"
                                format="DD-MM-YYYY"
                                v-model="sale.billing_date"
                                placeholder="">
                            </component-datepicker>
                        </b-form-group>
                    </b-card>
                </b-col>
            </b-row>
    </section>
</template>