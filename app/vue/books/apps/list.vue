<script type="text/javascript">
    export default {
        components: {

        },
        data() {
            return {
                books: [
                    {
                        path: 'purchases_book',
                        title: 'libro de ventas',
                        description: 'Libro donde se registran las ventas a crédito que hace la empresa.'
                    },
                    {
                        path: 'sales_book',
                        title: 'libro de compras',
                        description: 'Libro donde se registran las ventas a crédito que hace la empresa.'
                    },
                ]
            }
        },
        mounted() {

        },
        methods: {
            showBook(path){
                this.$router.push(`/books/${path}`)
            }
        }
    }
</script>

<template>
    <section>
        <b-row>
            <b-col
                md="3"
                sm="12"
                v-for="(book, index) in books"
                :key="index"
            >
                <b-card
                    @click="showBook(book.path)"
                    border-variant="dark"
                    style="cursor: pointer;"
                >

                    <b-card-header>
                        <b-card-text class="text-center">
                            {{ book.title }}
                        </b-card-text>
                    </b-card-header>
                    <b-card-body>
                        <b-card-text class="text-justify">
                            {{ book.description }}
                        </b-card-text>
                    </b-card-body>
                </b-card>
            </b-col>
        </b-row>
</section>
</template>