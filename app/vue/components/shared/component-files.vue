<script>

import VueDropzone from 'vue2-dropzone'
import 'vue2-dropzone/dist/vue2Dropzone.min.css'

export default {
    props: {
        url: {
            type: String,
            required: true
        },

        hasPicture: {
            type: Boolean,
            default: true
        },

        fileId: {
            type: Number,
            default: null
        },

        defaultFileKey: {
            type: String,
            default: null
        },

        maxFiles: {
            type: Number,
            default: 1
        }
    },

    components: {
        'vue-dropzone': VueDropzone
    },

    data(){
        return {
            dropzone_options: {
                url: null,
                maxFiles: this.maxFiles,
                thumbnailWidth: 150,
                paramName: null,
                autoProcessQueue: false,
                addRemoveLinks: true,
                method: 'POST',
                headers: {
                    'X-CSRF-Token': document
                    .querySelector('meta[name="csrf-token"]')
                    .getAttribute('content')
                }
            },
            fields: [{
                label: 'Fecha de creación',
                key: 'created_at_raw',
                sortable: true
            },{
                label: 'Nombre',
                key: 'name',
                sortable: true
            },{
                label: 'Usuario',
                key: 'user_creator_name',
                sortable: true
            },{
                label: '',
                key: 'actions'
            }],
            submitting: false,
            loading: false,
            file: {
                id: null,
                name: null,
                extension: ''
            },
            acceptedFile: false,
            pagination: {
                total: 0,
                per_page: 10,
                current_page: 1
            },
            sorting: {
                desc: false,
                column: 'name'
            },
            search_text: '',
            files: [],
            tabIndex: 0,
            defaultFileId: null,
            fileExtensions: []
        }
    },

    mounted(){
        this.defaultFileId = this.fileId

        this.setDropzoneOptions()
        this.getFiles()
        this.getFileExtensions()
    },

    methods: {
        getFiles(){
            this.loading = true

            const url = this.url + '.json'

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.files = result.data
                }

                this.loading = false
            }).catch(error => {
                console.log(error)
            })
        },

        getFileExtensions(){
            const url = this.url.replace(/\/[0-9]+/g, '') + '/extensions.json'

            this.http.get(url).then(result => {
                if (result.successful) {
                    this.fileExtensions = result.data
                }
            }).catch(error => {
                console.log(error)
            })
        },

        setDropzoneOptions(){
            this.dropzone_options.url = this.url
            this.dropzone_options.paramName = 'file[attachment]'
            this.dropzone_options.dictRemoveFile = "Quitar archivo";
            this.dropzone_options.dictMaxFilesExceeded = 'Ah excedido la cantidad de archivos.'
            this.dropzone_options.dictUploadCanceled  = 'Error al subir el archivo.'
        },


        submitForm(event){
            if(event){
                event.preventDefault()
            }

            this.postFile()
        },

        putObjectDefaultFile(file_id){
            const url = this.url.replace('/files', '.json')

            const attribute = this.defaultFileKey + '_file_id'
            const form = {
                [this.defaultFileKey]: {
                    [attribute]: file_id
                }
            }

            this.http.put(url, form).then(result => {
                if (result.successful) {
                    this.defaultFileId = file_id

                    this.$toast.success('Imagen por defecto actualizada exitosamente.')
                } else {
                    this.$toast.error(result.error.message)
                }
            }).catch(error => {
                console.log(error)
            })
        },

        postFile(){
            let dropzone = this.$refs['dropzone']
            this.submitting = true

            // Updating the dropzone options in case they change
            dropzone.dropzone.options.url = this.url
            dropzone.dropzone.options.method = 'POST'

            if(dropzone.getAcceptedFiles().length > 0){
                dropzone.processQueue()
            }else{
                this.submitting = false
                this.$toast.error('Debe adjuntar un archivo.')
            }
        },

        verifyFileAdded(file){
            if(! this.fileExtensions){
                return
            }

            let acceptedFile = false

            let extension = ''
            for(let i = 0; i < this.fileExtensions.length; i++){
                extension = this.fileExtensions[i]

                if(file.name.toLowerCase().endsWith(extension)){
                    acceptedFile = true
                    break
                }
            }

            if(! acceptedFile){

                this.$toast.error(`Extensión no permitida, las extensiones válidas son [${this.fileExtensions.join(', ')}].`, {
                    timeout: 4000
                })

                this.$refs['dropzone'].removeFile(file)
            } else {
                if (!this.file.name) {
                    this.$set(this.file, 'name', file.name.replace('.' + extension, ''))
                }

                this.$set(this.file, 'extension', extension)
            }
        },

        analizeResponse(_file, result){
            if(result.successful){
                this.$toast.success('Archivo subido exitosamente.')

                setTimeout(() => {
                    this.cleanDropzone()
                    this.getFiles()
                    this.tabIndex = 1
                }, 500);
            }else{
                this.$toastt.error(result.error.message)
            }
        },

        removeFile(file){
            this.$set(this.file, 'name', '')
            this.$set(this.file, 'extension', '')
        },

        displayUploadError(_file, message){
            this.msg.error(message)
        },

        maxFilesExceeded(file){
            this.$refs['dropzone'].removeFile(file)
        },

        cleanDropzone(){
            this.submitting_form = false

            this.$set(this.file, 'name', '')
            this.$emit('upload-complete')
            this.$refs['dropzone'].removeAllFiles(true)
        },

        addCustomParams(file, xhr, formData){
            formData.append('file[name]', this.file.name)
        },

        onFiltered(filteredItems) {
            this.totalRows = filteredItems.length
            this.currentPage = 1
        },

        downloadFile(file_id){
            window.open(`${this.url}/${file_id}?download=true`, '_blank')
        },

        deleteFile(file_id){
            const url = `${this.url}/${file_id}.json`

            this.http.delete(url).then(result => {
                if (result.successful) {
                    this.files = this.files.filter(e => e.id !== file_id)
                    this.$toast.success('Archivo eliminado exitosamente.')
                }
            }).catch(error => {
                console.log(error)
            })
        },

        extensionIsValid(extension){
            this.fileExtensions.includes(extension)
        }
    }
}
</script>


<template>
    <b-card no-body>
        <b-tabs v-model="tabIndex" pills fill>
            <br>
            <b-tab title="Cargar archivo">
                <form @submit="submitForm">
                    <b-form-group>
                        <template #label>
                            Archivo <sup class="text-danger">*</sup>
                            <span><small> {{ fileExtensions }} </small></span>
                        </template>

                        <vue-dropzone
                            id="vue-dropzone"
                            ref="dropzone"
                            v-if="dropzone_options.url"
                            :options="dropzone_options"
                            v-on:vdropzone-file-added="verifyFileAdded"
                            v-on:vdropzone-sending="addCustomParams"
                            v-on:vdropzone-error="displayUploadError"
                            v-on:vdropzone-queue-complete="cleanDropzone"
                            v-on:vdropzone-success="analizeResponse"
                            v-on:vdropzone-max-files-exceeded="maxFilesExceeded"
                            v-on:vdropzone-removed-file="removeFile"
                        >
                        </vue-dropzone>
                    </b-form-group>

                    <b-form-group>
                        <template #label>
                            Nombre <sup class="text-danger">*</sup>
                        </template>

                        <b-input-group>
                            <b-form-input
                                v-model="file.name"
                                type="text"
                                placeholder=""
                                required
                            >
                            </b-form-input>
                            <b-input-group-append>
                                <b-input-group-text > {{ '.' + file.extension }} </b-input-group-text>
                            </b-input-group-append>
                        </b-input-group>
                    </b-form-group>

                    <b-button type="submit" variant="primary">Guardar</b-button>
                </form>
            </b-tab>
            <b-tab title="Listado">
                <b-table
                    striped
                    hover
                    :items="files"
                    :fields="fields"
                    :current-page="pagination.current_page"
                    :per-page="pagination.per_page"
                    :filter="search_text"
                    @filtered="onFiltered"
                    :sort-desc.sync="sorting.desc"
                    :sort-by.sync="sorting.column"
                    responsive
                >
                    <template #head()="{ label, field: { key, sortable }}">
                        {{ label }}
                        <template v-if="sortable">
                            <template>
                                <font-awesome-icon v-if="((sorting.desc) && (sorting.column === key))" icon="sort-down" />
                                <font-awesome-icon v-else-if="((!sorting.desc) && (sorting.column === key))" icon="sort-up" />
                            </template>
                        </template>
                    </template>

                    <template v-slot:cell(actions)="row">
                        <template v-if="hasPicture">
                            <b-button v-if="defaultFileId == row.item.id" variant="success" class="mr-1">
                                <font-awesome-icon icon="image" />
                            </b-button>

                            <b-button v-else-if="extensionIsValid(row.item.file_extension)" variant="info" @click.stop="putObjectDefaultFile(row.item.id)" class="mr-1">
                                <font-awesome-icon icon="image"/>
                            </b-button>
                        </template>

                        <b-button variant="dark" @click.stop="downloadFile(row.item.id)" class="mr-1">
                            <font-awesome-icon icon="download"/>
                        </b-button>

                        <b-button v-if="defaultFileId !== row.item.id" variant="danger" @click.stop="deleteFile(row.item.id)" class="mr-1">
                            <font-awesome-icon icon="trash" />
                        </b-button>
                    </template>
                </b-table>
                <b-col sm="4" md="4" class="my-1">
                    <b-pagination
                        v-model="pagination.current_page"
                        :simple="false"
                        :total-rows="pagination.total"
                        :per-page="pagination.per_page"
                        align="fill"
                        size="sm"
                        class="my-0"
                    >
                    </b-pagination>
                </b-col>
            </b-tab>
        </b-tabs>
    </b-card>
</template>


<style lang="css">
    .vue-dropzone > .dz-preview .dz-remove {
        color: black;
        padding: 5px;
        margin: 5px;
        margin-top: 25px;
    }
</style>