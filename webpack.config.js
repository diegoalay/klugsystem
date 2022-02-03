// · Including plugins and dependencies
// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
var fs = require('fs')
var path = require('path')
var webpack = require("webpack")
var VueLoaderPlugin = require('vue-loader/lib/plugin')
let webpackConfig = []

// ·
module.exports = env => {

    // set mode
    env.mode = env.mode ? env.mode : 'development'
    env.watch = env.watch ? env.watch : false
    var production = env.mode == "production" ? true : false

    // ·
    let webpackBase = {
        watch: env.watch == 'true',
        mode: production ? "production" : "development",
        performance: { hints: false },
        optimization: !production ? { minimize: false } :  {
            minimizer: [
                new TerserPlugin({
                    terserOptions: {
                        output: {
                            comments: false
                        }
                    }
                })
            ]
        },
        entry: {},
        output: {
            path: __dirname,
            filename: "app/assets/javascripts/[name].js"
        },
        resolve: {
            alias: {

                // resolve vuejs
                vue: production ? 'vue/dist/vue.min.js' : 'vue/dist/vue.js',

            },
            extensions: [".js", ".mjs"]
        },

        module: {

            rules:[
                {
                    test: /\.pug$/,
                    loader: 'pug-plain-loader'
                }, {
                    test: /\.vue$/,
                    loader: 'vue-loader'
                }, {
                    test: /\.css$/,
                    use: [
                        'style-loader',
                        'css-loader'
                    ]
                },{
                  test: /\.scss$/,
                  use: [
                      'style-loader', // creates style nodes from JS strings
                      'css-loader',   // translates CSS into CommonJS
                      {
                          loader: 'sass-loader', // compiles Sass to CSS, using Node Sass by default
                      }

                  ]
                }
            ]
        },

        watchOptions: {
            poll: 1000,
            aggregateTimeout: 300,
            ignored: /node_modules/
        },
        plugins: [
            new VueLoaderPlugin()
        ]

    }

    fs.readdirSync(path.join('app', 'vue')).forEach(action => {
        if (action === 'core' || action === 'components') {
            return
        }

        let filePath = './'+path.join('app', 'vue', action, 'app.js')
        let fileName = `${action.replace('.js')}`
        webpackBase.entry[fileName] = filePath

    })

    webpackConfig.push(webpackBase)

    return webpackConfig
}