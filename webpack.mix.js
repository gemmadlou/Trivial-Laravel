const mix = require('laravel-mix');

/*
 |--------------------------------------------------------------------------
 | Mix Asset Management
 |--------------------------------------------------------------------------
 |
 | Mix provides a clean, fluent API for defining some Webpack build steps
 | for your Laravel applications. By default, we are compiling the CSS
 | file for the application as well as bundling up all the JS files.
 |
 */

mix.extend('preons', function(webpackConfig, ...args) {
    // The webpack configuration object.
    webpackConfig.module.rules.push({
        test: /\.ya?ml$/,
        use: [
          "style-loader",
          "css-loader",
          {
            loader: "preons-webpack-loader",
            options: {
              /* ... */
            },
          },
          "yaml-loader",
        ],
    })
});



mix.js('resources/js/app.js', 'public/js')
    .preons()
    .postCss('resources/css/app.css', 'public/css', [
        //
    ])
