<script>
export default {
    props: {
        title: {
            default: null,
            type: String
        },
        subtitle: {
            default: null,
            type: String
        },
        buttons: {
            default: true,
            type: Boolean
        },
        titleButtonCreate: {
            default: "Crear",
            type: String
        },
        loading: {
            default: false,
            type: Boolean
        }
    },
    methods: {
        reloadList() {
            this.$emit("reloadList");
        }
    }
}
</script>
<template>
    <div class="navbar component-header-list">
        <div class="float-left">
            <h3 v-if="title" class="is-size-3">
                {{ title }}
            </h3>
            <h4 v-if="subtitle" class="is-size-4">
                {{ subtitle }}
            </h4>
        </div>
        <div class="float-right">
            <slot></slot>
            <div class="buttons" v-if="buttons">
                <b-button :disabled="loading" variant="primary" class="mb-2" @click="reloadList">
                    {{ loading ? "Cargando" : 'Recargar' }}
                    <font-awesome-icon v-if="loading" icon="spinner" spin />
                    <font-awesome-icon v-else icon="sync" />
                </b-button>
                <b-button v-if="this.$route.path=='/'" variant="outline-dark" class="mb-2" to="/new">
                    {{ titleButtonCreate }} <font-awesome-icon icon="plus" />
                </b-button>
            </div>
        </div>
    </div>
</template>