<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                filters: {
                    data: 'mine'
                }
            }
        },
        mounted() {

        },
        methods: {
            getButtonText(){
                return 'Seleccione un rango'
            }
        }
    }
</script>

<template>
    <section class="application-component">
        <b-row>
            <b-col>
                <b-row>
                    <b-col md="4" sm="12">
                        <b-card class="dashboard-top-box text-center">
                            <b-row>
                                <b-col md="4" sm="4" class="text-left">
                                    10
                                </b-col>
                                <b-col md="7" sm="7" class="dashboard-value text-right">
                                    Q. 100.00
                                </b-col>
                            </b-row>
                        </b-card>
                    </b-col>
                    <b-col md="4" sm="12">
                        <b-card class="dashboard-top-box">
                            <b-row>
                                <b-col md="4" sm="4" class="dashboard-counter text-left">
                                    10
                                </b-col>
                                <b-col md="8" sm="8" class="dashboard-value text-right">
                                    Q. 100.00
                                </b-col>
                            </b-row>
                        </b-card>
                    </b-col>
                    <b-col md="4" sm="12">
                        <b-card class="dashboard-top-box">
                            <b-row>
                                <b-col md="4" sm="4" class="dashboard-counter text-left">
                                    10
                                </b-col>
                                <b-col md="8" sm="8" class="dashboard-value text-right">
                                    Q. 100.00
                                </b-col>
                            </b-row>
                        </b-card>
                    </b-col>
                </b-row>
                <b-row>
                    <b-col md="12" sm="12">
                        <b-card class="dashboard-graph">
                            GRAPH
                        </b-card>
                    </b-col>
                </b-row>
            </b-col>
            <b-col md="4" sm="12">
                <b-card class="dashboard-products">
                </b-card>
            </b-col>
        </b-row>
    </section>
</template>