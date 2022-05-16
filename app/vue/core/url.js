export default {

    install (Vue, options) {
        class BuildUrl {


            constructor(base_path) {
                this.base_path = base_path

                this.parsedPath = ""
                this.query = {}
                this.url=""
            }

            // parse, join and create a well formated url object
            _build(api = true) {

                let url = ""

                // if path exists for the url
                if (this.parsedPath != "") {
                    url = url.concat("/").concat(this.parsedPath)
                }

                // normally all the requests are sent to the internal Lesli api
                // so, the requests should include the json suffix
                if (api) {
                    url = url.concat(".json")
                }

                // concat query string if available
                url = url.concat(this._parseQuery(this.query))

                // build a native URL object
                // this.url = new URL(url, this.base_path)
                this.url = url

                // return this to enable methods chaining pattern
                return this

            }

            // parse a string template into a string path
            // example: domain.com/user/:id, { id: 1 }
            // result: domain.com/user/1
            // this is good to avoid string interpolation :)
            _parsePath(path, params = {}) {

                // shortcut to get specific resource
                if (typeof params == 'string' || typeof params == 'number') {
                    params = { id: params }
                }

                // remaining params are useful if we want to work with the params
                // that does not belongs to a any part of the path template
                const remainingParams = { ...params };

                const renderedPath = path.replace(/:[_A-Za-z][_A-Za-z0-9]*/g, p => {
                    const key = p.slice(1);
                    delete remainingParams[key];
                    return encodeURIComponent(params[key])
                })

                for (let param in remainingParams) {
                    this.query[param] = remainingParams[param]
                }

                return renderedPath

            }

            // convert a key value object into a standard queryString. This custom implementation
            // supports deep object parsing and array parsing
            // example: { name: {first: "luis"}, age: 25 }
            // result: domain.com?name[first]=luis&age=25
            _parseQuery(query) {
                function recursion(query, path) {
                    if (Array.isArray(query)) {
                        query.forEach(function (element) {
                            recursion(element, path + "[]")
                        })
                        return
                    }
                    if (query !== null && typeof query === "object") {
                        Object.keys(query).forEach(function (param) {
                            recursion(query[param], path + "[" + param + "]")
                        });
                        return
                    }
                    data.push(path + "=" + query)
                }

                var data = []
                Object.keys(query).forEach(function (param) {
                    recursion(query[param], param)
                })

                if(data.length > 0){
                    return "?".concat(data.join("&"))
                }

                return ""
            }

            // convert the url object to string automatically if object as string is needed
            toString(api=true) {
                this._build(api)
                return this.url
            }

            // insert search param into query string
            search(text) {
                this.query["search"] = text
                return this._build()
            }


            // insert pagination params into query string
            paginate(page, perPage=0) {
                if (!page) {
                    this.query["disable_pagination"] = true
                } else {
                    this.query["current_page"] = page
                    if (perPage > 0) {
                        this.query["per_page"] = perPage
                    }
                }

                return this._build()
            }


            // insert order params into query string
            order(column, direction=null) {
                this.query["order_by"] = column
                if (direction) {
                    this.query["order"] = direction
                }
                return this._build()
            }

            filters(filters){
                if(this.query.filters){
                    for(let key in filters){
                        this.query.filters[key] = filters[key]
                    }
                }else{
                    this.query.filters = filters
                }

                return this._build()
            }

            tokenUrl() {
                const urlParams = new URLSearchParams(window.location.search);
                this.query["t"] = urlParams.get("t")
                return this._build()
            }

            dayTimestamp(day){
                if(! day instanceof Date){
                    return this._build()
                }

                let start_date = new Date(day.getTime())
                start_date.setHours(0)
                start_date.setMinutes(0)
                start_date.setSeconds(0)
                start_date.setMilliseconds(0)

                // We substract 1 second for the date and add 1 day
                let end_date = new Date(start_date.getTime() - 1000)
                end_date.setDate(end_date.getDate() + 1)

                return this.filters({
                    start_date: start_date.toISOString(),
                    end_date: end_date.toISOString()
                })
            }

            monthTimestamp(month){
                if(! month instanceof Date){
                    return this._build()
                }

                let start_date = new Date(month.getTime())
                start_date.setDate(1)
                start_date.setHours(0)
                start_date.setMinutes(0)
                start_date.setSeconds(0)

                // We substract 1 second for the date and add 1 month
                let end_date = new Date(start_date.getTime() - 1000)
                end_date.setMonth(end_date.getMonth() + 1)

                return this.filters({
                    start_date: start_date.toISOString(),
                    end_date: end_date.toISOString()
                })
            }

            // build a url for a specific module
            buildModuleUrl(module, path, params) {
                this.parsedPath = module.concat("/").concat(this._parsePath(path, params))
                return this._build()
            }

            buildUrl(path, params){
                this.parsedPath = this._parsePath(path, params)
                return this._build()
            }
        }

        Vue.prototype.url = {

            // · Redirect to specific url
            go(url=null) {
                url = new URL(url, options.root)
                window.location.href = url.href;
            },

            // · Get well formated url
            to(path=null) {

                if (path) {
                    return new URL(path, options.root);
                }

                return new URL("/", options.root);

            },

            search(engine, text) {

                engine = engine.replace('cloud_', '').replace('_cloud', '')

                return this[engine]('search').search(text)

            },

            crm(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('crm', path, params)
            },

            finance(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('finance', path, params)
            },

            inventory(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('inventory', path, params)
            },

            admin(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('administration', path, params)
            },

            hr(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('hr', path, params)
            },

            pos(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('pos', path, params)
            },

            config(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('configurations', path, params)
            },

            reports(path, params={}) {
                let url = new BuildUrl(options.root)
                return url.buildModuleUrl('reports', path, params)
            },

            build(path, params={}) {
                const url = new BuildUrl(options.root)
                return url.buildUrl(path, params)
            }
        }
    }
}